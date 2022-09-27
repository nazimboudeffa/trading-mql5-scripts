//+------------------------------------------------------------------+
//|                                          SimplePositionCount.mq5 |
//|                                  Copyright 2022, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//|        ORIGINAL TUTO https://www.youtube.com/watch?v=RdXYj1MO7Ac |
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
   int PositionsForThisCurrencyPair = 0;
   for (int i = PositionsTotal()-1; i >=0; i--)
   {
      string symbol = PositionGetSymbol(i);
      
      if (Symbol()==symbol)
      {
         PositionsForThisCurrencyPair+=1;
      }
   }
   
   Comment ("\n\n Positions for this currency pair: ", PositionsForThisCurrencyPair);
  }
//+------------------------------------------------------------------+
