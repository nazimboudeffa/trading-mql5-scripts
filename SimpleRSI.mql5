//+------------------------------------------------------------------+
//|                                                  SimpleRSIEA.mq5 |
//|                                  Copyright 2022, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"

#include<Trade\Trade.mqh>
CTrade trade;

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
   double Ask = NormalizeDouble (SymbolInfoDouble (_Symbol, SYMBOL_ASK), _Digits);
   double Bid = NormalizeDouble (SymbolInfoDouble (_Symbol, SYMBOL_BID), _Digits);
   string signal = "";
   double myRSIArray[];
   ArraySetAsSeries(myRSIArray, true);
   int myRSIDefinition = iRSI(_Symbol, _Period, 14, PRICE_CLOSE); 
   CopyBuffer (myRSIDefinition, 0, 0, 3, myRSIArray);
   double myRSIValue = NormalizeDouble (myRSIArray[0], 0);
   
   if (myRSIValue > 70)
   signal="sell";
   
   if (myRSIValue < 30)
   signal="buy";
   
   if (signal == "sell" && PositionsTotal() < 1)
   trade.Sell(0.10, NULL, Bid, (Bid + 200 * _Point), (Bid - 150 * _Point), NULL);
   
   if (signal == "buy" && PositionsTotal() < 1)
   trade.Buy(0.10, NULL, Ask, (Ask - 200 * _Point), (Ask + 150 * _Point), NULL);
   
   Comment ("The signal is: ", signal);
  }
//+------------------------------------------------------------------+
