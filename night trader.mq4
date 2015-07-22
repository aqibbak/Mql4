//+------------------------------------------------------------------+
//|                                                 night trader.mq4 |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2015, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
input  int    Magic              =1;
input  string TimeToSetOrders    ="02:00";
input  string TimeToDeleteOrders ="04:00";
input  int    Lot                =1;
extern int    Distance           =20;
extern int    TakeProfit         =60;
extern int    StopLoss           =40;
bool TradeSwitcher               =false;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   if(Digits == 3 || Digits == 5)
     {
         Distance       *=10;
         TakeProfit     *=10;
         StopLoss       *=10;
     }
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
//+----------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//| Expert tick function                                                                                                                                                 |
//+----------------------------------------------------------------------------------------------------------------------------------------------------------------------+
void OnTick()
  {
//---
      Count();
   
  }
//+----------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//+----------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//Проверка количества открытых ордеров условие 
//+----------------------------------------------------------------------------------------------------------------------------------------------------------------------+
void Count()
{
   if(TimeToSetOrders == TimeToString(TimeCurrent(),TIME_MINUTES))
     {
       int  countb = CountB();
       int  counts = CountS();
       if( countb  + counts ==0) Open_Stop_Orders();
     
     }
    
    
   while(TimeToDeleteOrders == TimeToString(TimeCurrent(),TIME_MINUTES))
     {
         Delete_OrderB();
         Delete_OrderS();
     }
   
}
//+----------------------------------------------------------------------------------------------------------------------------------------------------------------------+
int CountB() //На покупку
{
int count=0;
for (int i=OrdersTotal()-1; i>=0; i--)
   {
	   if(OrderSelect(i,SELECT_BY_POS, MODE_TRADES))
	      {
		      if (OrderSymbol()==Symbol()&& OrderMagicNumber()==Magic && OrderType()== OP_BUYLIMIT) count++;
	      }
   }
   return(count);
}
//+----------------------------------------------------------------------------------------------------------------------------------------------------------------------+
int CountS() //На продажу
{
int count=0;
for (int i=OrdersTotal()-1; i>=0; i--)
   {
	  if(OrderSelect(i,SELECT_BY_POS, MODE_TRADES))
	   {
		      if (OrderSymbol()==Symbol()&& OrderMagicNumber()==Magic && OrderType()== OP_SELLLIMIT) count++;
      }
   }
   return(count);
 }
 
 //+----------------------------------------------------------------------------------------------------------------------------------------------------------------------+
 void Open_Stop_Orders()
 {   
         RefreshRates();
         double Price   = NormalizeDouble(Bid+Distance*Point,Digits);
         double TP      = NormalizeDouble(Bid+(Distance-TakeProfit)*Point,Digits);
         double SL      = NormalizeDouble(Ask+(Distance+StopLoss)*Point,Digits);
         int TicketBS   = OrderSend(Symbol(),OP_SELLLIMIT,Lot,Price,5,SL,TP," ",Magic,0,clrGreen);
         if(TicketBS>0)
           {
               Alert(IntegerToString(TicketBS) + " Opened at: " + TimeToString(TimeCurrent(),TIME_SECONDS));
               TicketBS =0;
           }
         else
           {
               Comment("Time: " + TimeToString(TimeCurrent(),TIME_SECONDS) + " Couldn't open order OPEN_BUY_STOP error: " + IntegerToString(GetLastError()));
           }
         
         RefreshRates();
                Price   = NormalizeDouble(Ask-Distance*Point,Digits);
                TP      = NormalizeDouble(Ask-(Distance-TakeProfit)*Point,Digits);
                SL      = NormalizeDouble(Bid-(Distance+StopLoss)*Point,Digits);
         int TicketSS   = OrderSend(Symbol(),OP_BUYLIMIT,Lot,Price,5,SL,TP," ",Magic,0,clrBlue);
         if(TicketSS>0)
           {
               Alert(IntegerToString(TicketSS) + " Opened at: " + TimeToString(TimeCurrent(),TIME_SECONDS));
               TicketSS =0;
           }
         else
           {
               Comment("Time: " + TimeToString(TimeCurrent(),TIME_SECONDS) + " Couldn't open order OPEN_SELL_STOP error: " + IntegerToString(GetLastError()));
           }
 }
 //+----------------------------------------------------------------------------------------------------------------------------------------------------------------------+
void Delete_OrderS()
 {
    for (int i=OrdersTotal()-1; i>=0; i--)
         {
	      if(OrderSelect(i,SELECT_BY_POS, MODE_TRADES))
	         {
		      if (OrderSymbol()==Symbol()&& OrderMagicNumber()==Magic && OrderType()== OP_SELLLIMIT)
           int ticket=OrderDelete(OrderTicket(),clrRed);
	         }
         }
 }
 
void Delete_OrderB()
 {
    for (int i=OrdersTotal()-1; i>=0; i--)
         {
	      if(OrderSelect(i,SELECT_BY_POS, MODE_TRADES))
	         {
		      if (OrderSymbol()==Symbol()&& OrderMagicNumber()==Magic && OrderType()== OP_BUYLIMIT)
           int ticket=OrderDelete(OrderTicket(),clrRed);
	         }
         }
 }