//+------------------------------------------------------------------+
//|                                                    SimpleRSI.mq5 |
//|                                                   Nazim Boudeffa |
//|                             https://www.github.com/nazimboudeffa |
//+------------------------------------------------------------------+
#property copyright "Nazim Boudeffa"
#property link      "https://www.github.com/nazimboudeffa"
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
