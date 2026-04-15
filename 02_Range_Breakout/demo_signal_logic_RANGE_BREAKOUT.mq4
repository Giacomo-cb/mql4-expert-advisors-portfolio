/*
============================================================
Demo File: Range_Breakout_EA - Signal Logic Showcase
Category: Breakout
Platform: MetaTrader 4 (MQL4)
Version: 1.0
Author: Giacomo Cipolat Bares
Portfolio: MQL4 Expert Advisors Portfolio
============================================================

Description:
This is a simplified public demo derived from the full
Range Breakout EA.

Included in this demo:
- range high/low detection
- breakout trigger calculation
- breakout buffer logic
- one-breakout-per-range logic
- breakout cooldown logic
- basic on-chart signal output

Excluded from this demo:
- order execution
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
input string __01_BreakoutSettings        = "01 ======== Breakout Settings ========";
input int    BreakoutBars                 = 20;
input double BreakoutBufferPips           = 0.5;
input bool   UseCloseBreakout             = false;
input bool   OneBreakoutPerRange          = true;
input bool   ResetRangeAfterTrade         = true;
input bool   UseBreakoutCooldown          = true;
input int    BreakoutCooldownBars         = 5;

//======================= BREAKOUT GLOBALS ==========================
double g_lastRangeHigh      = 0.0;
double g_lastRangeLow       = 0.0;
bool   g_rangeAlreadyTraded = false;
int    g_lastTradeBarIndex  = -1;

//======================= GENERAL GLOBALS ===========================
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

   Print("Range Breakout demo initialized");
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
//| Range high from previous N bars                                  |
//+------------------------------------------------------------------+
double GetBreakoutHigh()
{
   int highestIndex = iHighest(NULL, 0, MODE_HIGH, BreakoutBars, 1);
   return High[highestIndex];
}

//+------------------------------------------------------------------+
//| Range low from previous N bars                                   |
//+------------------------------------------------------------------+
double GetBreakoutLow()
{
   int lowestIndex = iLowest(NULL, 0, MODE_LOW, BreakoutBars, 1);
   return Low[lowestIndex];
}

//+------------------------------------------------------------------+
//| Bullish breakout condition                                       |
//+------------------------------------------------------------------+
bool IsBullishBreakout()
{
   double breakoutHigh = GetBreakoutHigh();
   double triggerPrice = breakoutHigh + BreakoutBufferPips * g_pip;

   if(UseCloseBreakout)
      return (Close[1] > triggerPrice);

   return (Ask > triggerPrice);
}

//+------------------------------------------------------------------+
//| Bearish breakout condition                                       |
//+------------------------------------------------------------------+
bool IsBearishBreakout()
{
   double breakoutLow = GetBreakoutLow();
   double triggerPrice = breakoutLow - BreakoutBufferPips * g_pip;

   if(UseCloseBreakout)
      return (Close[1] < triggerPrice);

   return (Bid < triggerPrice);
}

//+------------------------------------------------------------------+
//| Checks if current range is same as previous tracked range        |
//+------------------------------------------------------------------+
bool IsSameRange(double rangeHigh, double rangeLow)
{
   if(MathAbs(rangeHigh - g_lastRangeHigh) < (g_point * 0.5) &&
      MathAbs(rangeLow  - g_lastRangeLow)  < (g_point * 0.5))
   {
      return true;
   }

   return false;
}

//+------------------------------------------------------------------+
//| Updates tracked breakout range                                   |
//+------------------------------------------------------------------+
void UpdateRangeState()
{
   double currentRangeHigh = GetBreakoutHigh();
   double currentRangeLow  = GetBreakoutLow();

   if(!IsSameRange(currentRangeHigh, currentRangeLow))
   {
      g_lastRangeHigh = currentRangeHigh;
      g_lastRangeLow  = currentRangeLow;

      if(ResetRangeAfterTrade)
         g_rangeAlreadyTraded = false;
   }
}

//+------------------------------------------------------------------+
//| One breakout per range filter                                    |
//+------------------------------------------------------------------+
bool CanTradeCurrentRange()
{
   if(!OneBreakoutPerRange)
      return true;

   if(g_rangeAlreadyTraded)
      return false;

   return true;
}

//+------------------------------------------------------------------+
//| Breakout cooldown filter                                         |
//+------------------------------------------------------------------+
bool BreakoutCooldownPassed()
{
   if(!UseBreakoutCooldown)
      return true;

   if(g_lastTradeBarIndex < 0)
      return true;

   int barsPassed = Bars - g_lastTradeBarIndex;

   if(barsPassed >= BreakoutCooldownBars)
      return true;

   return false;
}

//+------------------------------------------------------------------+
//| Demo buy signal wrapper                                          |
//+------------------------------------------------------------------+
bool BuySignal()
{
   if(!CanTradeCurrentRange())
      return false;

   if(!BreakoutCooldownPassed())
      return false;

   return IsBullishBreakout();
}

//+------------------------------------------------------------------+
//| Demo sell signal wrapper                                         |
//+------------------------------------------------------------------+
bool SellSignal()
{
   if(!CanTradeCurrentRange())
      return false;

   if(!BreakoutCooldownPassed())
      return false;

   return IsBearishBreakout();
}

//+------------------------------------------------------------------+
//| Expert tick                                                      |
//+------------------------------------------------------------------+
void OnTick()
{
   if(!IsNewBar())
      return;

   UpdateRangeState();

   if(BuySignal())
   {
      g_lastTradeBarIndex  = Bars;
      g_rangeAlreadyTraded = true;
      Comment("Demo Signal: BUY breakout detected");
      return;
   }

   if(SellSignal())
   {
      g_lastTradeBarIndex  = Bars;
      g_rangeAlreadyTraded = true;
      Comment("Demo Signal: SELL breakout detected");
      return;
   }

   Comment("Demo Signal: No valid breakout");
}