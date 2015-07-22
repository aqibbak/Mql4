//+------------------------------------------------------------------+
//|                                                 night trader.mq4 |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2015, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
input int    Magic            =1;
input string TimeToSetOrders  ="02:00";
bool TradeSwitcher            =false;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
  
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
      Count();
   
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//Проверка количества открытых ордеров условие 
//+------------------------------------------------------------------+
void Count()
{
   if(TimeToSetOrders == TimeToString(TimeCurrent(),TIME_MINUTES))
     {
       int  countb = CountB();
       int  counts = CountS();
      if( countb  + counts ==0) TradeSwitcher=true;
      Comment(TimeToString(TimeCurrent(),TIME_MINUTES));
     }
   
   
}
//+------------------------------------------------------------------+
int CountB() //На покупку
{
int count=0;
for (int i=OrdersTotal()-1; i>=0; i--)
   {
	if(OrderSelect(i,SELECT_BY_POS, MODE_TRADES))
	   {
		if (OrderSymbol()==Symbol()&& OrderMagicNumber()==Magic && OrderType()== OP_BUYSTOP)
          count++;
	   }
   }
   return(count);
}
//+------------------------------------------------------------------+
int CountS() //На продажу
{
int count=0;
for (int i=OrdersTotal()-1; i>=0; i--)
   {
	if(OrderSelect(i,SELECT_BY_POS, MODE_TRADES))
	   {
		if (OrderSymbol()==Symbol()&& OrderMagicNumber()==Magic && OrderType()== OP_SELLSTOP)
          count++;
	   }
   }
   return(count);
 }