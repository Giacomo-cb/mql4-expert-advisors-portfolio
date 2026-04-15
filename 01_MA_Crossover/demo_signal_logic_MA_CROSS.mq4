/*
============================================================
Demo File: MA_Crossover_EA - Signal Logic Showcase
Category: Trend Following
Platform: MetaTrader 4 (MQL4)
Version: 1.0
Author: Giacomo Cipolat Bares
Portfolio: MQL4 Expert Advisors Portfolio
============================================================

Description:
This is a simplified public demo derived from the full
Moving Average Crossover EA.

Included in this demo:
- moving average signal logic
- crossover detection
- minimum cross distance validation
- basic on-chart signal output

Excluded from this demo:
- order execution
- risk management engine
- break-even / trailing stop
- retry logic
- broker protection handling
- full production trade framework
============================================================
*/

#property strict
#property version "1.00"

//========================= INPUTS ==================================
input string __01_GeneralSettings         = "01 ======== General Settings ========";
input int    FastMAPeriod                 = 10;
input int    SlowMAPeriod                 = 20;
input int    MAMethod                     = MODE_EMA;
input int    MAPrice                      = PRICE_CLOSE;
input double MinCrossDistancePips         = 0.5;

//======================= GLOBALS ===================================
double   g_point;
double   g_pip;
int      g_digits;
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

   if(FastMAPeriod >= SlowMAPeriod)
   {
      Print("ERROR: FastMAPeriod must be smaller than SlowMAPeriod");
      return(INIT_FAILED);
   }

   Print("MA Crossover demo initialized");
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
//| Moving average helper                                            |
//+------------------------------------------------------------------+
double GetMA(int period, int shift)
{
   return iMA(NULL, 0, period, 0, MAMethod, MAPrice, shift);
}

//+------------------------------------------------------------------+
//| Minimum cross distance filter                                    |
//+------------------------------------------------------------------+
bool CrossDistancePassed(double fastValue, double slowValue)
{
   double distance = MathAbs(fastValue - slowValue);
   return (distance >= MinCrossDistancePips * g_pip);
}

//+------------------------------------------------------------------+
//| Bullish crossover                                                |
//+------------------------------------------------------------------+
bool IsBullishCross()
{
   double fastPrev = GetMA(FastMAPeriod, 2);
   double slowPrev = GetMA(SlowMAPeriod, 2);
   double fastCurr = GetMA(FastMAPeriod, 1);
   double slowCurr = GetMA(SlowMAPeriod, 1);

   if(!(fastPrev <= slowPrev && fastCurr > slowCurr))
      return false;

   if(!CrossDistancePassed(fastCurr, slowCurr))
      return false;

   return true;
}

//+------------------------------------------------------------------+
//| Bearish crossover                                                |
//+------------------------------------------------------------------+
bool IsBearishCross()
{
   double fastPrev = GetMA(FastMAPeriod, 2);
   double slowPrev = GetMA(SlowMAPeriod, 2);
   double fastCurr = GetMA(FastMAPeriod, 1);
   double slowCurr = GetMA(SlowMAPeriod, 1);

   if(!(fastPrev >= slowPrev && fastCurr < slowCurr))
      return false;

   if(!CrossDistancePassed(fastCurr, slowCurr))
      return false;

   return true;
}

//+------------------------------------------------------------------+
//| Demo buy signal wrapper                                          |
//+------------------------------------------------------------------+
bool BuySignal()
{
   return IsBullishCross();
}

//+------------------------------------------------------------------+
//| Demo sell signal wrapper                                         |
//+------------------------------------------------------------------+
bool SellSignal()
{
   return IsBearishCross();
}

//+------------------------------------------------------------------+
//| Expert tick                                                      |
//+------------------------------------------------------------------+
void OnTick()
{
   if(!IsNewBar())
      return;

   if(BuySignal())
      Comment("Demo Signal: BUY crossover detected");

   else if(SellSignal())
      Comment("Demo Signal: SELL crossover detected");

   else
      Comment("Demo Signal: No valid crossover");
}