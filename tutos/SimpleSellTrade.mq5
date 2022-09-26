//+------------------------------------------------------------------+
//|                                              SimpleSellTrade.mq5 |
//|                                  Copyright 2022, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//|        ORIGINAL TUTO https://www.youtube.com/watch?v=IwvUPs-JE3A |
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
   
   double Bid = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_BID), _Digits);
   double Balance = AccountInfoDouble(ACCOUNT_BALANCE);
   double Equity = AccountInfoDouble(ACCOUNT_EQUITY);
   
   if (Equity >= Balance)
   trade.Sell(0.01, NULL, Bid, 0, (Bid - 100 * _Point), NULL);
   
  }
//+------------------------------------------------------------------+

/*
void OpenBuyOrder(){
MqlTradeRequest myrequest;
MqlTradeResult myresult;
ZeroMemory(myrequest);

myrequest.action = TRADE_ACTION_DEAL;
myrequest.type = ORDER_TYPE_SELL;
myrequest.symbol = _Symbol;
myrequest.volume = 0.01;
myrequest.type_filling = ORDER_FILLING_FOK;
myrequest.price = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
myrequest.tp = Bid + (ProfitPunkt * _Point);
myrequest.sl = 0;
myrequest.deviation = 50;
OrderSend (myrequest, myresult);
LastEquity= AccountInfoDouble(ACCOUNT_EQUITY);

}
*/
