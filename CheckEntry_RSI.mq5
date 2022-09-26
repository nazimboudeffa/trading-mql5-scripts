//+------------------------------------------------------------------+
//|                                               CheckEntry_RSI.mq5 |
//|                                  Copyright 2022, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//|        ORIGINAL TUTO https://www.youtube.com/watch?v=A_Ezji_e9_M |
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
   
  }
//+------------------------------------------------------------------+
string checkEntry_RSI(){
   // create a string for the signal
   string signal="";
   
   //create an array for the price data
   double myRSIArray[];
   
   // define the properties for the RSI
   int myRSIDefinition = iRSI (_Symbol, _Period, 14, PRICE_CLOSE);
   
   // sort the price data from the current candle downwards
   ArraySetAsSeries(myRSIArray, true);
   
   // Defined EA, from current candle, for 3 candles, save in array
   CopyBuffer(myRSIDefinition, 0, 0, 3, myRSIArray);
   
   // calculate the current RSI value
   double myRSIValue = NormalizeDouble (myRSIArray[0], 2)
   
   if (myRSIValue > 70) signal = "sell";
   
   if (myRSIValue < 30) signal = "buy";
   
   return signal;
}
