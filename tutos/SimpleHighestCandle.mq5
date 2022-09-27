//+------------------------------------------------------------------+
//|                                          SimpleHighestCandle.mq5 |
//|                                  Copyright 2022, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//|        ORIGINAL TUTO https://www.youtube.com/watch?v=S7AiX4Qyvws |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   double HighestCandleM1;
   double High[];
   ArraySetAsSeries(High, true);
   CopyHigh(_Symbol, PERIOD_M1, 0, 11, High);
   HighestCandleM1 = ArrayMaximum(High, 0, 11);
   
   Comment ("Highest candle within the last 10 candles: " + HighestCandleM1);
  }
//+------------------------------------------------------------------+
