/*
============================================================
Demo File: RSI_Mean_Reversion_EA - Signal Logic Showcase
Category: Mean Reversion
Platform: MetaTrader 4 (MQL4)
Version: 1.0
Author: Giacomo Cipolat Bares
Portfolio: MQL4 Expert Advisors Portfolio
============================================================

Description:
This is a simplified public demo derived from the full
RSI Mean Reversion EA.

Included in this demo:
- RSI overbought / oversold logic
- optional candle-close confirmation
- optional moving average trend filter
- optional ATR volatility filter
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
input string __01_RSISettings             = "01 =========== RSI Settings ==========";
input int    RSIPeriod                    = 14;
input double RSIBuyLevel                  = 30.0;
input double RSISellLevel                 = 70.0;
input double RSIExitLevel                 = 50.0;
input int    RSIPrice                     = PRICE_CLOSE;
input bool   UseClosedCandleSignal        = true;

input string __02_TrendFilter             = "02 ========= Trend Filter =========";
input bool   UseTrendFilter               = false;
input int    MAPeriod                     = 200;
input int    MAMethod                     = MODE_SMA;
input int    MAPrice                      = PRICE_CLOSE;

input string __03_ATRFilter               = "03 =========== ATR Filter ==========";
input bool   UseATRFilter                 = false;
input int    ATRPeriod                    = 14;
input double MinATRValuePips              = 5.0;

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

   Print("RSI Mean Reversion demo initialized");
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
//| Indicator helpers                                                |
//+------------------------------------------------------------------+
double GetRSI(int shift)
{
   return iRSI(NULL, 0, RSIPeriod, RSIPrice, shift);
}

double GetMA(int shift)
{
   return iMA(NULL, 0, MAPeriod, 0, MAMethod, MAPrice, shift);
}

double GetATRInPips(int shift)
{
   double atr = iATR(NULL, 0, ATRPeriod, shift);
   return atr / g_pip;
}

//+------------------------------------------------------------------+
//| Filters                                                          |
//+------------------------------------------------------------------+
bool TrendFilterBuyPassed()
{
   if(!UseTrendFilter)
      return true;

   return (Close[1] >= GetMA(1));
}

bool TrendFilterSellPassed()
{
   if(!UseTrendFilter)
      return true;

   return (Close[1] <= GetMA(1));
}

bool ATRFilterPassed()
{
   if(!UseATRFilter)
      return true;

   return (GetATRInPips(1) >= MinATRValuePips);
}

//+------------------------------------------------------------------+
//| RSI signal logic                                                 |
//+------------------------------------------------------------------+
bool IsOversoldSignal()
{
   double rsiPrev = GetRSI(2);
   double rsiCurr = GetRSI(1);

   if(UseClosedCandleSignal)
      return (rsiPrev <= RSIBuyLevel && rsiCurr > RSIBuyLevel);

   return (GetRSI(0) <= RSIBuyLevel);
}

bool IsOverboughtSignal()
{
   double rsiPrev = GetRSI(2);
   double rsiCurr = GetRSI(1);

   if(UseClosedCandleSignal)
      return (rsiPrev >= RSISellLevel && rsiCurr < RSISellLevel);

   return (GetRSI(0) >= RSISellLevel);
}

//+------------------------------------------------------------------+
//| Demo wrappers                                                    |
//+------------------------------------------------------------------+
bool BuySignal()
{
   if(!ATRFilterPassed())
      return false;

   if(!TrendFilterBuyPassed())
      return false;

   return IsOversoldSignal();
}

bool SellSignal()
{
   if(!ATRFilterPassed())
      return false;

   if(!TrendFilterSellPassed())
      return false;

   return IsOverboughtSignal();
}

//+------------------------------------------------------------------+
//| Expert tick                                                      |
//+------------------------------------------------------------------+
void OnTick()
{
   if(!IsNewBar())
      return;

   if(BuySignal())
   {
      Comment("Demo Signal: BUY RSI mean reversion detected");
      return;
   }

   if(SellSignal())
   {
      Comment("Demo Signal: SELL RSI mean reversion detected");
      return;
   }

   Comment("Demo Signal: No valid RSI mean reversion setup");
}