/*
============================================================
Demo File: Asia_Session_Breakout_EA - Signal Logic Showcase
Category: Session Breakout
Platform: MetaTrader 4 (MQL4)
Version: 1.0
Author: Giacomo Cipolat Bares
Portfolio: MQL4 Expert Advisors Portfolio
============================================================

Description:
This is a simplified public demo derived from the full
Asia Session Breakout EA.

Included in this demo:
- Asia session high/low detection
- session range calculation
- breakout trigger calculation
- Asia range filter
- late breakout filter
- basic on-chart signal output

Excluded from this demo:
- order execution
- pending order management
- risk management engine
- break-even / trailing stop
- retry logic
- broker protection handling
- full production trade framework
- chart visualization layer
============================================================
*/

#property strict
#property version "1.00"

//========================= INPUTS ==================================
input string __01_SessionSettings         = "01 ======== Session Settings ========";
input int    AsiaStartHour                = 0;
input int    AsiaEndHour                  = 6;
input int    LondonStartHour              = 7;
input int    LondonEndHour                = 12;
input int    SessionCalculationTimeframe  = PERIOD_M1;

input string __02_BreakoutSettings        = "02 ======== Breakout Settings ========";
input double BreakoutBufferPips           = 1.0;
input bool   UseAsiaRangeFilter           = true;
input bool   NoLateBreakout               = true;
input double MinAsiaRangePips             = 5.0;
input double MaxAsiaRangePips             = 30.0;

//======================= GLOBALS ===================================
double   g_point;
double   g_pip;
int      g_digits;

double   g_asiaHigh = -1.0;
double   g_asiaLow  = -1.0;
bool     g_asiaRangeFinalized = false;
datetime g_lastSessionDay = -1;
datetime g_lastBarTime = 0;

//+------------------------------------------------------------------+
//| Expert initialization                                            |
//+------------------------------------------------------------------+
int OnInit()
{
   g_point  = Point;
   g_digits = Digits;

   if(g_digits == 5 || g_digits == 3)
      g_pip = g_point * 10.0;
   else
      g_pip = g_point;

   Print("Asia Session Breakout demo initialized");
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Detects a new bar                                                |
//+------------------------------------------------------------------+
bool IsNewBar()
{
   datetime currentBarTime = iTime(NULL, 0, 0);

   if(currentBarTime != g_lastBarTime)
   {
      g_lastBarTime = currentBarTime;
      return true;
   }

   return false;
}

//+------------------------------------------------------------------+
//| Current hour helper                                              |
//+------------------------------------------------------------------+
int CurrentHour()
{
   return TimeHour(TimeCurrent());
}

//+------------------------------------------------------------------+
//| Session checks                                                   |
//+------------------------------------------------------------------+
bool IsInsideAsiaSession()
{
   int hour = TimeHour(TimeCurrent());
   return (hour >= AsiaStartHour && hour < AsiaEndHour);
}

bool IsLondonSession()
{
   int hour = CurrentHour();
   return (hour >= LondonStartHour && hour < LondonEndHour);
}

//+------------------------------------------------------------------+
//| Date helper                                                      |
//+------------------------------------------------------------------+
datetime DateOfDay(datetime t)
{
   return t - (t % 86400);
}

//+------------------------------------------------------------------+
//| Session time builders                                            |
//+------------------------------------------------------------------+
datetime GetSessionStart(datetime dayStart, int startHour)
{
   return dayStart + startHour * 3600;
}

datetime GetSessionEnd(datetime dayStart, int endHour)
{
   return dayStart + endHour * 3600;
}

//+------------------------------------------------------------------+
//| Calculates Asia session high/low                                 |
//+------------------------------------------------------------------+
bool CalculateAsiaRange(double &asiaHigh, double &asiaLow)
{
   datetime today = DateOfDay(TimeCurrent());

   datetime asiaStart = GetSessionStart(today, AsiaStartHour);
   datetime asiaEnd   = GetSessionEnd(today, AsiaEndHour);

   int tf = SessionCalculationTimeframe;

   int startShift = iBarShift(Symbol(), tf, asiaEnd - 1, false);
   int endShift   = iBarShift(Symbol(), tf, asiaStart, false);

   if(startShift < 0 || endShift < 0)
      return false;

   int count = endShift - startShift + 1;

   if(count <= 0)
      return false;

   int highestShift = iHighest(Symbol(), tf, MODE_HIGH, count, startShift);
   int lowestShift  = iLowest(Symbol(), tf, MODE_LOW, count, startShift);

   if(highestShift < 0 || lowestShift < 0)
      return false;

   asiaHigh = iHigh(Symbol(), tf, highestShift);
   asiaLow  = iLow(Symbol(), tf, lowestShift);

   return (asiaHigh > 0 && asiaLow > 0);
}

//+------------------------------------------------------------------+
//| Updates tracked Asia range                                       |
//+------------------------------------------------------------------+
void UpdateAsiaRange()
{
   if(g_asiaRangeFinalized)
      return;

   double asiaHigh = -1.0;
   double asiaLow  = -1.0;

   if(CalculateAsiaRange(asiaHigh, asiaLow))
   {
      g_asiaHigh = asiaHigh;
      g_asiaLow  = asiaLow;
   }

   datetime today   = DateOfDay(TimeCurrent());
   datetime asiaEnd = GetSessionEnd(today, AsiaEndHour);

   if(TimeCurrent() >= asiaEnd)
      g_asiaRangeFinalized = true;
}

//+------------------------------------------------------------------+
//| Reset session state daily                                        |
//+------------------------------------------------------------------+
void ResetSessionState()
{
   datetime today = DateOfDay(TimeCurrent());

   if(today != g_lastSessionDay)
   {
      g_lastSessionDay = today;
      g_asiaHigh = -1.0;
      g_asiaLow  = -1.0;
      g_asiaRangeFinalized = false;
   }
}

//+------------------------------------------------------------------+
//| Range and trigger helpers                                        |
//+------------------------------------------------------------------+
double GetAsiaRangePips()
{
   if(g_asiaHigh <= 0 || g_asiaLow <= 0)
      return 0.0;

   return (g_asiaHigh - g_asiaLow) / g_pip;
}

bool AsiaRangeFilterPassed()
{
   if(!UseAsiaRangeFilter)
      return true;

   double asiaRangePips = GetAsiaRangePips();

   if(asiaRangePips < MinAsiaRangePips)
      return false;

   if(asiaRangePips > MaxAsiaRangePips)
      return false;

   return true;
}

double GetBuyTrigger()
{
   return g_asiaHigh + BreakoutBufferPips * g_pip;
}

double GetSellTrigger()
{
   return g_asiaLow - BreakoutBufferPips * g_pip;
}

//+------------------------------------------------------------------+
//| Late breakout filter                                             |
//+------------------------------------------------------------------+
bool LateBreakout()
{
   if(!NoLateBreakout)
      return true;

   if(Ask > GetBuyTrigger() || Bid < GetSellTrigger())
      return false;

   return true;
}

//+------------------------------------------------------------------+
//| Demo breakout signal wrappers                                    |
//+------------------------------------------------------------------+
bool BuySignal()
{
   if(!IsLondonSession())
      return false;

   if(!AsiaRangeFilterPassed())
      return false;

   if(!LateBreakout())
      return false;

   if(g_asiaHigh <= 0 || g_asiaLow <= 0)
      return false;

   return (Ask > GetBuyTrigger());
}

bool SellSignal()
{
   if(!IsLondonSession())
      return false;

   if(!AsiaRangeFilterPassed())
      return false;

   if(!LateBreakout())
      return false;

   if(g_asiaHigh <= 0 || g_asiaLow <= 0)
      return false;

   return (Bid < GetSellTrigger());
}

//+------------------------------------------------------------------+
//| Expert tick                                                      |
//+------------------------------------------------------------------+
void OnTick()
{
   if(!IsNewBar())
      return;

   ResetSessionState();
   UpdateAsiaRange();

   if(BuySignal())
   {
      Comment("Demo Signal: BUY Asia breakout detected");
      return;
   }

   if(SellSignal())
   {
      Comment("Demo Signal: SELL Asia breakout detected");
      return;
   }

   Comment("Demo Signal: No valid Asia breakout");
}