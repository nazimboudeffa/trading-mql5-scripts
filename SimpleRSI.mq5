//+------------------------------------------------------------------+
//|                                                  SimpleRSIEA.mq5 |
//|                                  Copyright 2022, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
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

   double myRSIArray[];
   int myRSIDefinition = iRSI (_Symbol, _Period, 14, PRICE_CLOSE);
   ArraySetAsSeries(myRSIArray, true);
   CopyBuffer(myRSIDefinition, 0, 0, 3, myRSIArray);
   double myRSIValue = NormalizeDouble(myRSIArray[0], 32);
   Comment ("myRSIValue : ", myRSIValue);

  }
//+------------------------------------------------------------------+
