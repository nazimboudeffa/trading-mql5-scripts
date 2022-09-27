//+------------------------------------------------------------------+
//|                                         based on MM_CROS_IFR.mq5 |
//|                                                  Copyright 2018. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Anonymous. Copyright 2022."
#property link      "https://www.mql5.com"
#property version   "1.00"
//---

#include<Trade\Trade.mqh>
CTrade trade;

enum STRATEGY_IN
  {
   ONLY_MA,  	// Only moving averages
   ONLY_RSI, 	// Only RSI
   MA_AND_RSI	// moving averages plus RSI
  };

//---
// Variables Input
sinput string s0; //-----------Strategy-------------
input STRATEGY_IN   strategy               = ONLY_RSI;       // Trader Entry Strategy

sinput string s1; //-----------Moving Averages-------------
input int ma_fast_period                   = 12;            // Fast Moving Average Period
input int ma_slow_period                   = 32;            // Slow Moving Average Period
input ENUM_TIMEFRAMES ma_time_graphic      = PERIOD_CURRENT;// Graphic Time
input ENUM_MA_METHOD  ma_method            = MODE_EMA;      // Method 
input ENUM_APPLIED_PRICE  ma_price         = PRICE_CLOSE;   // Price Applied

sinput string s2; //-----------RSI-------------
input int rsi_period                       = 5;             // RSI Period
input ENUM_TIMEFRAMES rsi_time_graphic     = PERIOD_CURRENT; // Graphic Time  
input ENUM_APPLIED_PRICE rsi_price         = PRICE_CLOSE;   // Price Applied

input int rsi_overbought                   = 70;             // Level Overbought
input int rsi_oversold                     = 30;              // Level Oversold

sinput string s3; //---------------------------
input double num_lots                         = 0.10;           // Number of lots
input double TK                            = 60;            // Take Profit
input double SL                            = 30;            // Stop Loss

sinput string s4; //---------------------------
input string limit_close_op                 = "17:40";       // Time Limit Close Position

//+------------------------------------------------------------------+
//|  Variables for indicators                                        |
//+------------------------------------------------------------------+
//--- Moving Averages
// FAST - shorter period
int ma_fast_Handle;      // Handle Fast Moving Average
double ma_fast_Buffer[]; // Buffer Fast Moving Average

// SLOW - longer period
int ma_slow_Handle;      // Handle Slow Moving Average
double ma_slow_Buffer[]; // Buffer Slow Moving Average

//--- RSI
int rsi_Handle;           // Handle for RSI
double rsi_Buffer[];      // Buffer for RSI

//+------------------------------------------------------------------+
//| Variables for functions                                          |
//+------------------------------------------------------------------+

int magic_number = 123456;   // Magic Number

MqlRates candle[];            // Variable for storing candles
MqlTick tick;                 // Variable for storing ticks 

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   ma_fast_Handle = iMA(_Symbol,ma_time_graphic,ma_fast_period,0,ma_method,ma_price);
   ma_slow_Handle  = iMA(_Symbol,ma_time_graphic,ma_slow_period,0,ma_method,ma_price);
   
   rsi_Handle = iRSI(_Symbol,rsi_time_graphic,rsi_period,rsi_price);
   
   if(ma_fast_Handle<0 || ma_slow_Handle<0 || rsi_Handle<0)
     {
      Alert("Error trying to create Handles for indicator - error: ",GetLastError(),"!");
      return(-1);
     }
   
   CopyRates(_Symbol,_Period,0,4,candle);
   ArraySetAsSeries(candle,true);
   
   // To add the indicator to the chart:
   ChartIndicatorAdd(0,0,ma_fast_Handle); 
   ChartIndicatorAdd(0,0,ma_slow_Handle);
   ChartIndicatorAdd(0,1,rsi_Handle);
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
   IndicatorRelease(ma_fast_Handle);
   IndicatorRelease(ma_slow_Handle);
   IndicatorRelease(rsi_Handle);
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
    // Copy a three-dimensional data vector to Buffer 
    CopyBuffer(ma_fast_Handle,0,0,4,ma_fast_Buffer);
    CopyBuffer(ma_slow_Handle,0,0,4,ma_slow_Buffer);
    
    CopyBuffer(rsi_Handle,0,0,4,rsi_Buffer);
    
    //--- Feed candle buffers with data:
    CopyRates(_Symbol,_Period,0,4,candle);
    ArraySetAsSeries(candle,true);
    
    // Sort the data vector:
    ArraySetAsSeries(ma_fast_Buffer,true);
    ArraySetAsSeries(ma_slow_Buffer,true);
    ArraySetAsSeries(rsi_Buffer,true);
    //---
    
    // Feed with tick variable data
    SymbolInfoTick(_Symbol,tick);
   
    // LOGIC TO ACTIVATE PURCHASE
    bool buy_ma_cros = ma_fast_Buffer[0] > ma_slow_Buffer[0] &&
                          ma_fast_Buffer[2] < ma_slow_Buffer[2] ;
                                             
    bool buy_rsi = rsi_Buffer[0] <= rsi_oversold;
    
    // LOGIC TO ACTIVATE SALE
    bool sell_ma_cros = ma_slow_Buffer[0] > ma_fast_Buffer[0] &&
                         ma_slow_Buffer[2] < ma_fast_Buffer[2];
    
    bool sell_rsi = rsi_Buffer[0] >= rsi_overbought;
    //---
    
    bool Buy = false; // Can Buy?
    bool Sell  = false; // Can Sell?
    
    if(strategy == ONLY_MA)
      {
       Buy = buy_ma_cros;
       Sell  = sell_ma_cros;
       
      }
    else if(strategy == ONLY_RSI)
     {
        Buy = buy_rsi;
        Sell  = sell_rsi;
     }
    else
      {
         Buy = buy_ma_cros && buy_rsi;
         Sell  = sell_ma_cros && sell_rsi;
      }  
    
    // returns true if we have a new candle
    bool newBar = isNewBar(); 
    
    // Every time there is a new candle enter this 'if'
    if(newBar)
      {
       
       // Buy Condition:
       if(Buy && PositionSelect(_Symbol)==false)
       //TODO: Check if we entered in the normal RSI area before buy
         {
          drawVerticalLine("Buy",candle[1].time,clrBlue);
          //BuyAtMarket();
          SimpleBuyTrade();
         }
       
       // Sell Condition:
       if(Sell && PositionSelect(_Symbol)==false)
       //TODO: Check if we entered in the normal RSI area before sell
         {
          drawVerticalLine("Sell",candle[1].time,clrRed);
          //SellAtMarket();
          SimpleSellTrade();
         } 
         
      }

      if(newBar && TimeToString(TimeCurrent(),TIME_MINUTES) == limit_close_op && PositionSelect(_Symbol)==true)
        {
            Print("-----> End of Operating Time: End Open Positions!");
            drawVerticalLine("Limit_OP",candle[0].time,clrYellow);
             
            if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)
               {
                  CloseBuy();
               }
            else if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL)
               {
                  CloseSell();
               }
        }

  }
//+------------------------------------------------------------------+
//| FUNCTIONS TO ASSIST IN THE VISUALIZATION OF THE STRATEGY         |
//+------------------------------------------------------------------+

void drawVerticalLine(string name, datetime dt, color cor = clrAliceBlue)
   {
      ObjectDelete(0,name);
      ObjectCreate(0,name,OBJ_VLINE,0,dt,0);
      ObjectSetInteger(0,name,OBJPROP_COLOR,cor);
   } 
   
//+------------------------------------------------------------------+
//| FUNCTIONS FOR SENDING ORDERS                                     |
//+------------------------------------------------------------------+

// BUY TO MARKET
void BuyAtMarket() 
  {
   MqlTradeRequest   request;       // request
   MqlTradeResult    response;      // response
   
   ZeroMemory(request);
   ZeroMemory(response);
   
   //--- For Buy Order
   request.action       = TRADE_ACTION_DEAL;                            // Trade operation type
   request.magic        = magic_number;                                 // Magic number
   request.symbol       = _Symbol;                                      // Trade symbol
   request.volume       = num_lots;                                     // Lots number
   request.price        = NormalizeDouble(tick.ask,_Digits);            // Price to buy
   request.sl           = NormalizeDouble(tick.ask - SL*_Point,_Digits);// Stop Loss Price
   request.tp           = NormalizeDouble(tick.ask + TK*_Point,_Digits);// Take Profit
   request.deviation    = 0;                                            // Maximal possible deviation from the requested price
   request.type         = ORDER_TYPE_BUY;                               // Order type
   request.type_filling = ORDER_FILLING_FOK;                            // Order execution type
   
   //---
   OrderSend(request,response);
   //---
   if(response.retcode == 10008 || response.retcode == 10009)
     {
      Print("Order Buy executed successfully!!");
     }
   else
     {
       Print("Error sending Order to Buy. Error = ", GetLastError());
       ResetLastError();
     }
  }

// SELL TO MARKET
void SellAtMarket()
  {
   MqlTradeRequest   request;       // request
   MqlTradeResult    response;      // response
   
   ZeroMemory(request);
   ZeroMemory(response);
   
   //--- For Sell Order
   request.action       = TRADE_ACTION_DEAL;                            // Trade operation type
   request.magic        = magic_number;                                 // Magic number
   request.symbol       = _Symbol;                                      // Trade symbol
   request.volume       = num_lots;                                     // Lots number
   request.price        = NormalizeDouble(tick.bid,_Digits);            // Price to sell
   request.sl           = NormalizeDouble(tick.bid + SL*_Point,_Digits);// Stop Loss Price
   request.tp           = NormalizeDouble(tick.bid - TK*_Point,_Digits);// Take Profit
   request.deviation    = 0;                                            // Maximal possible deviation from the requested price
   request.type         = ORDER_TYPE_SELL;                              // Order type
   request.type_filling = ORDER_FILLING_FOK;                            // Order execution type
   //---
   OrderSend(request,response);
   //---
     if(response.retcode == 10008 || response.retcode == 10009)
       {
        Print("Order to Sell executed successfully!");
       }
     else
       {
        Print("Error sending Order to Sell. Error =", GetLastError());
        ResetLastError();
       } 
 }

//---
void CloseBuy()
   {
      MqlTradeRequest   request;       // request
      MqlTradeResult    response;      // response
      
      ZeroMemory(request);
      ZeroMemory(response);
      
      //--- For Sell Order
      request.action       = TRADE_ACTION_DEAL;
      request.magic        = magic_number;
      request.symbol       = _Symbol;
      request.volume       = num_lots; 
      request.price        = 0; 
      request.type         = ORDER_TYPE_SELL;
      request.type_filling = ORDER_FILLING_RETURN;
      
      //---
      OrderSend(request,response);
      //---
        if(response.retcode == 10008 || response.retcode == 10009)
          {
           Print("Order to Sell executed successfully!");
          }
        else
          {
           Print("Error sending Order to Sell. Error =", GetLastError());
           ResetLastError();
          }
   }

void CloseSell()
   {   
      MqlTradeRequest   request;       // request
      MqlTradeResult    response;      // response
      
      ZeroMemory(request);
      ZeroMemory(response);
      
      //--- For Buy Order
      request.action       = TRADE_ACTION_DEAL;
      request.magic        = magic_number;
      request.symbol       = _Symbol;
      request.volume       = num_lots; 
      request.price        = 0; 
      request.type         = ORDER_TYPE_BUY;
      request.type_filling = ORDER_FILLING_RETURN;
      
      //---
      OrderSend(request,response);
   
      //---
        if(response.retcode == 10008 || response.retcode == 10009)
          {
           Print("Order Buy executed successfully!!");
          }
        else
          {
           Print("Error sending Order to Buy. Error = ", GetLastError());
           ResetLastError();
          }
   }
//+------------------------------------------------------------------+
//| USEFUL FUNCTIONS                                                 |
//+------------------------------------------------------------------+
//--- for bar change
bool isNewBar()
  {
//--- memorize the time of opening of the last bar in the static variable
   static datetime last_time=0;
//--- current time
   datetime lastbar_time= (datetime) SeriesInfoInteger(Symbol(),Period(),SERIES_LASTBAR_DATE); 

//--- if it is the first call of the function
   if(last_time==0)
     {
      //--- set the time and exit
      last_time=lastbar_time;
      return(false);
     }

//--- if the time differs
   if(last_time!=lastbar_time)
     {
      //--- memorize the time and return true
      last_time=lastbar_time;
      return(true);
     }
//--- if we passed to this line, then the bar is not new; return false
   return(false);
  }
  
void SimpleBuyTrade()
{
   double Ask = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK), _Digits);
   double Balance = AccountInfoDouble(ACCOUNT_BALANCE);
   double Equity = AccountInfoDouble(ACCOUNT_EQUITY);
   
   if (Equity >= Balance)
   trade.Buy(0.01, NULL, Ask, 0, (Ask + 100 * _Point), NULL);
}

void SimpleSellTrade()
{
   double Bid = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_BID), _Digits);
   double Balance = AccountInfoDouble(ACCOUNT_BALANCE);
   double Equity = AccountInfoDouble(ACCOUNT_EQUITY);
   
   if (Equity >= Balance)
   trade.Sell(0.01, NULL, Bid, 0, (Bid - 100 * _Point), NULL);
}
