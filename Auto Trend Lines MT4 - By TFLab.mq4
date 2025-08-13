//+------------------------------------------------------------------+
//|                                             Auto Trend Lines.mq4 |
//|                                                                  |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "TradingFinder.com - 2023-2024"
#property link      "https://tradingfinder.com/products/indicators/mt4/"
#property version   "1.04"
#property description "Risk Warning: Trading on financial markets involves risk, and you may lose part or all of your money. Using this indicator is at your own risk. TradingFinder [TFLab] creates software as educational material. We are not responsible for any losses or damages."
#property description "   "
#property description "Find out more on TradingFinder.com"
#property icon    "\\Images\\Logo.ico"

#property strict
#property indicator_chart_window

//+------------------------------------------------------------------+
//|                  inputs and variables                            |
//+------------------------------------------------------------------+
input string long_line = "";  //==== Long Term Zig Zag Line Propertise ====
extern bool show_long_line = True;//Display Long Term Zig Zag Line
extern int long_period = 36;//Pivot Period Long Term Zig Zag Line
extern ENUM_LINE_STYLE long_line_style = STYLE_SOLID;//Long Term Zig Zag Line Style
extern color long_color = clrCornflowerBlue;//Long Term Zig Zag Line Color
extern int long_line_width = 2;//Long Term Zig Zag Line Width

input string trend_long_line = ""; //==== Long Term Trend Line Propertise ====
extern bool show_long_trend_line = True;//Display Long Term Trend Line
extern color trend_long_color = clrDarkOrange;//Long Term Trend Line Color

input string medium_line = ""; //==== Medium Term Zig Zag Line Propertise ====
extern bool show_medium_line = True;//Display Medium Term Zig Zag Line
extern int medium_period = 21;//Pivot Period Medium Term Zig Zag Line
extern ENUM_LINE_STYLE medium_line_style = STYLE_SOLID;//Medium Term Zig Zag Line Style
extern color medium_color = clrMediumTurquoise;//Medium Term Zig Zag Line Color
extern int medium_line_width = 1;//Medium Term Zig Zag Line Width

input string trend_medium_line = "";  //==== Medium Term Trend Line Propertise ====
extern bool show_medium_trend_line = True;//Display Medium Term Trend Line
extern color trend_medium_color = clrLightSeaGreen;//Medium Term Trend Line Color

input string short_line = "";  //==== Short Term Zig Zag Line Propertise ====
extern bool show_short_line = True;//Show Short Term Zig Zag Line
extern int short_period = 9;//Pivot Period Short Term Zig Zag Line
extern ENUM_LINE_STYLE short_line_style = STYLE_DASHDOT;//Short Term Zig Zag Line Style
extern color short_color = clrSalmon;//short Term Zig Zag Line Color
extern int short_line_width = 1;//Display Term Zig Zag Line Width

input string trend_short_line = "";   //==== Short Term Trend Line Propertise ====
extern bool show_short_trend_line = True;//Display Short Term Trend Line
extern color trend_short_color = clrLightSteelBlue;//Short Term Trend Line Color
input string S111 = "";  //==== Theme Setting ====

//------------------------------------------------------
bool initial_low_done[3];

double floating_low_value[3];
datetime floating_low_time[3];

double floating_high_value[3];
datetime floating_high_time[3];

string perv_structure[3];

double perv_high_value[3];
double perv_low_value[3];
double second_perv_high_value[3];
double second_perv_low_value[3];

datetime perv_high_time[3];
datetime perv_low_time[3];
datetime second_perv_high_time[3];
datetime second_perv_low_time[3];

string perv_high_trend_line[3][3];
string perv_low_trend_line[3][3];

bool perv_high_trend_line_done[3];
bool perv_low_trend_line_done[3];

datetime perv_candle_time[3];

int object_counter = 0;

double atr = NULL;
datetime one_candle_time = NULL;
bool first_run = False;
int last_rates_total = NULL;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   atr = iATR(Symbol(), PERIOD_CURRENT, 360, 0);
   one_candle_time = iTime(Symbol(), PERIOD_CURRENT, 1) - iTime(Symbol(), PERIOD_CURRENT, 2);

//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//|              on deinit                                           |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   int loop = 1000000;

   object_delete(loop, "CB_ATTL");
   object_delete(loop, "CB_ATTEXT");
  }
//+------------------------------------------------------------------+
//|                     delete objects                               |
//+------------------------------------------------------------------+
void object_delete(int iter, string name)
  {
   for(int i = iter; i >= 0; i--)
     {
      string obj_name = name + IntegerToString(i);
      bool od = ObjectDelete(ChartID(), obj_name);
     }
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
//---
   if(last_rates_total == NULL)
     {
      last_rates_total = rates_total;
     }
   if(rates_total - last_rates_total == 1)
     {
      last_rates_total = rates_total;
     }
   if(rates_total - last_rates_total > 1)
     {
      reset_every_thing();
     }

   int counted_bars = prev_calculated;

   if(first_run == False)
     {
      for(int i = rates_total - 1; i >= 1; i--)
        {
         initial_function(0, i, long_period);
         make_high_points(0, show_long_line, i, long_period, long_color, long_line_style, long_line_width);
         make_low_points(0, show_long_line, i, long_period, long_color, long_line_style, long_line_width);

         initial_function(1, i, medium_period);
         make_high_points(1, show_medium_line, i, medium_period, medium_color, medium_line_style, medium_line_width);
         make_low_points(1, show_medium_line, i, medium_period, medium_color, medium_line_style, medium_line_width);

         initial_function(2, i, short_period);
         make_high_points(2, show_short_line, i, short_period, short_color, short_line_style, short_line_width);
         make_low_points(2, show_short_line, i, short_period, short_color, short_line_style, short_line_width);
        }

      first_run = True;
     }

   if(first_run == True)
     {
      initial_function(0, 1, long_period);
      make_high_points(0, show_long_line, 1, long_period, long_color, long_line_style, long_line_width);
      make_low_points(0, show_long_line, 1, long_period, long_color, long_line_style, long_line_width);

      initial_function(1, 1, medium_period);
      make_high_points(1, show_medium_line, 1, medium_period, medium_color, medium_line_style, medium_line_width);
      make_low_points(1, show_medium_line, 1, medium_period, medium_color, medium_line_style, medium_line_width);

      initial_function(2, 1, short_period);
      make_high_points(2, show_short_line, 1, short_period, short_color, short_line_style, short_line_width);
      make_low_points(2, show_short_line, 1, short_period, short_color, short_line_style, short_line_width);
     }

//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
//|                    create objects                                |
//+------------------------------------------------------------------+
//line
string line_creator(double p1, datetime t1, double p2, datetime t2, color _color, int _style, int _width, bool ray_right)
  {
   ObjectCreate(ChartID(), "CB_ATTL" + IntegerToString(object_counter), OBJ_TREND, 0, t1, p1, t2, p2);
   ObjectSetInteger(ChartID(), "CB_ATTL" + IntegerToString(object_counter), OBJPROP_COLOR, _color);
   ObjectSetInteger(ChartID(), "CB_ATTL" + IntegerToString(object_counter), OBJPROP_STYLE, _style);
   ObjectSetInteger(ChartID(), "CB_ATTL" + IntegerToString(object_counter), OBJPROP_WIDTH, _width);
   ObjectSetInteger(ChartID(), "CB_ATTL" + IntegerToString(object_counter), OBJPROP_RAY_RIGHT, False);
   ObjectSetInteger(ChartID(), "CB_ATTL" + IntegerToString(object_counter), OBJPROP_SELECTABLE, False);
   ObjectSetInteger(ChartID(), "CB_ATTL" + IntegerToString(object_counter), OBJPROP_RAY_RIGHT, ray_right);
   object_counter += 1;
   return "CB_ATTL" + IntegerToString(object_counter - 1);
  }
//text
void create_text(int anchor, datetime t, double p, string text, color clr, int size)
  {
   ObjectCreate(ChartID(), "CB_ATTEXT" + IntegerToString(object_counter), OBJ_TEXT, 0, t, p);
   ObjectSetString(ChartID(), "CB_ATTEXT" + IntegerToString(object_counter), OBJPROP_TEXT,text);
   ObjectSetInteger(ChartID(), "CB_ATTEXT" + IntegerToString(object_counter), OBJPROP_FONTSIZE, size);
   ObjectSetInteger(ChartID(), "CB_ATTEXT" + IntegerToString(object_counter), OBJPROP_COLOR, clr);
   ObjectSetInteger(ChartID(), "CB_ATTEXT" + IntegerToString(object_counter), OBJPROP_SELECTABLE, False);
   ObjectSetString(ChartID(), "CB_ATTEXT" + IntegerToString(object_counter), OBJPROP_FONT, "Arial Black");
   ObjectSetInteger(ChartID(), "CB_ATTEXT" + IntegerToString(object_counter), OBJPROP_ANCHOR, anchor);
  }
//+------------------------------------------------------------------+
//|                   initial function                               |
//+------------------------------------------------------------------+
void initial_function(int mode, int i, int time_factor)
  {
   if(initial_low_done[mode] == False && floating_low_value[mode] == NULL)
     {
      floating_low_value[mode] = iLow(Symbol(), PERIOD_CURRENT, iLowest(Symbol(), PERIOD_CURRENT, MODE_LOW, time_factor, i));
      floating_low_time[mode] = iTime(Symbol(), PERIOD_CURRENT, iLowest(Symbol(), PERIOD_CURRENT, MODE_LOW, time_factor, i));

      perv_candle_time[mode] = iTime(Symbol(), PERIOD_CURRENT, i);
     }
   if(initial_low_done[mode] == False && floating_low_value[mode] != NULL && iTime(Symbol(), PERIOD_CURRENT, i) != perv_candle_time[mode] && iLow(Symbol(), PERIOD_CURRENT, i) < floating_low_value[mode])
     {
      floating_low_value[mode] = iLow(Symbol(), PERIOD_CURRENT, i);
      floating_low_time[mode] = iTime(Symbol(), PERIOD_CURRENT, i);

      perv_candle_time[mode] = iTime(Symbol(), PERIOD_CURRENT, i);
     }
   if(
      initial_low_done[mode] == False &&
      floating_low_value[mode] != NULL &&
      iTime(Symbol(), PERIOD_CURRENT, i) != perv_candle_time[mode] &&
      iTime(Symbol(), PERIOD_CURRENT, iHighest(Symbol(), PERIOD_CURRENT, MODE_HIGH, time_factor, i)) - floating_low_time[mode] > time_factor * one_candle_time &&
      iHigh(Symbol(), PERIOD_CURRENT, iHighest(Symbol(), PERIOD_CURRENT, MODE_HIGH, time_factor, i)) - floating_low_value[mode] >= atr
   )
     {
      perv_low_value[mode] = floating_low_value[mode];
      perv_low_time[mode] = floating_low_time[mode];

      perv_structure[mode] = "low";

      perv_candle_time[mode] = iTime(Symbol(), PERIOD_CURRENT, i);
      initial_low_done[mode] = True;

      floating_high_value[mode] = iHigh(Symbol(), PERIOD_CURRENT, iHighest(Symbol(), PERIOD_CURRENT, MODE_HIGH, time_factor, i));
      floating_high_time[mode] = iTime(Symbol(), PERIOD_CURRENT, iHighest(Symbol(), PERIOD_CURRENT, MODE_HIGH, time_factor, i));
     }
  }
//+------------------------------------------------------------------+
//|                   make high points                               |
//+------------------------------------------------------------------+
void make_high_points(int mode, bool show_line, int i, int time_factor, color line_color, int line_style, int line_width)
  {
   if(initial_low_done[mode] == True && perv_structure[mode] == "low" && iTime(Symbol(), PERIOD_CURRENT, i) != perv_candle_time[mode] && iHigh(Symbol(), PERIOD_CURRENT, i) > floating_high_value[mode])
     {
      floating_high_value[mode] = iHigh(Symbol(), PERIOD_CURRENT, i);
      floating_high_time[mode] = iTime(Symbol(), PERIOD_CURRENT, i);

      perv_candle_time[mode] = iTime(Symbol(), PERIOD_CURRENT, i);
     }
   if(
      initial_low_done[mode] == True &&
      perv_structure[mode] == "low" &&
      iTime(Symbol(), PERIOD_CURRENT, i) != perv_candle_time[mode] &&
      iTime(Symbol(), PERIOD_CURRENT, iLowest(Symbol(), PERIOD_CURRENT, MODE_LOW, time_factor, i)) - floating_high_time[mode] > time_factor * one_candle_time &&
      floating_high_value[mode] - iLow(Symbol(), PERIOD_CURRENT, iLowest(Symbol(), PERIOD_CURRENT, MODE_LOW, time_factor, i)) >= atr
   )
     {
      second_perv_high_value[mode] = perv_high_value[mode];
      second_perv_high_time[mode] = perv_high_time[mode];

      perv_high_value[mode] = floating_high_value[mode];
      perv_high_time[mode] = floating_high_time[mode];

      perv_structure[mode] = "high";
      perv_candle_time[mode] = iTime(Symbol(), PERIOD_CURRENT, i);

      floating_low_value[mode] = iLow(Symbol(), PERIOD_CURRENT, iLowest(Symbol(), PERIOD_CURRENT, MODE_LOW, time_factor, i));
      floating_low_time[mode] = iTime(Symbol(), PERIOD_CURRENT, iLowest(Symbol(), PERIOD_CURRENT, MODE_LOW, time_factor, i));

      if(show_line == True)
        {
         line_creator(perv_low_value[mode], perv_low_time[mode], perv_high_value[mode], perv_high_time[mode], line_color, line_style, line_width, False);
        }
      if((mode == 0 && show_long_trend_line) || (mode == 1 && show_medium_trend_line) || (mode == 2 && show_short_trend_line))
        {
         create_high_trend_line(mode);
         perv_low_trend_line_done[mode] = False;
        }
     }
  }
//+------------------------------------------------------------------+
//|                   make low points                                |
//+------------------------------------------------------------------+
void make_low_points(int mode, bool show_line, int i, int time_factor, color line_color, int line_style, int line_width)
  {
   if(initial_low_done[mode] == True && perv_structure[mode] == "high" && iTime(Symbol(), PERIOD_CURRENT, i) != perv_candle_time[mode] && iLow(Symbol(), PERIOD_CURRENT, i) < floating_low_value[mode])
     {
      floating_low_value[mode] = iLow(Symbol(), PERIOD_CURRENT, i);
      floating_low_time[mode] = iTime(Symbol(), PERIOD_CURRENT, i);

      perv_candle_time[mode] = iTime(Symbol(), PERIOD_CURRENT, i);
     }
   if(
      initial_low_done[mode] == True &&
      perv_structure[mode] == "high" &&
      iTime(Symbol(), PERIOD_CURRENT, i) != perv_candle_time[mode] &&
      iTime(Symbol(), PERIOD_CURRENT, iHighest(Symbol(), PERIOD_CURRENT, MODE_HIGH, time_factor, i)) - floating_low_time[mode] > time_factor * one_candle_time &&
      iHigh(Symbol(), PERIOD_CURRENT, iHighest(Symbol(), PERIOD_CURRENT, MODE_HIGH, time_factor, i)) - floating_low_value[mode] >= atr
   )
     {
      second_perv_low_value[mode] = perv_low_value[mode];
      second_perv_low_time[mode] = perv_low_time[mode];

      perv_low_value[mode] = floating_low_value[mode];
      perv_low_time[mode] = floating_low_time[mode];

      perv_structure[mode] = "low";
      perv_candle_time[mode] = iTime(Symbol(), PERIOD_CURRENT, i);

      floating_high_value[mode] = iHigh(Symbol(), PERIOD_CURRENT, iHighest(Symbol(), PERIOD_CURRENT, MODE_HIGH, time_factor, i));
      floating_high_time[mode] = iTime(Symbol(), PERIOD_CURRENT, iHighest(Symbol(), PERIOD_CURRENT, MODE_HIGH, time_factor, i));

      if(show_line == True)
        {
         line_creator(perv_high_value[mode], perv_high_time[mode], perv_low_value[mode], perv_low_time[mode], line_color, line_style, line_width, False);
        }
      if((mode == 0 && show_long_trend_line) || (mode == 1 && show_medium_trend_line) || (mode == 2 && show_short_trend_line))
        {
         create_low_trend_line(mode);
         perv_high_trend_line_done[mode] = False;
        }
     }
  }
//+------------------------------------------------------------------+
//|                  reset objects and values                        |
//+------------------------------------------------------------------+
void reset_every_thing()
  {
   ZeroMemory(initial_low_done);

   ZeroMemory(floating_low_value);
   ZeroMemory(floating_low_time);

   ZeroMemory(floating_high_value);
   ZeroMemory(floating_high_time);

   ZeroMemory(perv_structure);

   ZeroMemory(perv_high_value);
   ZeroMemory(perv_low_value);
   ZeroMemory(second_perv_high_value);
   ZeroMemory(second_perv_low_value);

   ZeroMemory(perv_high_time);
   ZeroMemory(perv_low_time);
   ZeroMemory(second_perv_high_time);
   ZeroMemory(second_perv_low_time);

   ZeroMemory(perv_high_trend_line);
   ZeroMemory(perv_low_trend_line);

   ZeroMemory(perv_high_trend_line_done);
   ZeroMemory(perv_low_trend_line_done);

   ZeroMemory(perv_candle_time);

   object_counter = 0;

   first_run = False;
   last_rates_total = NULL;

   int loop = 1000000;

   object_delete(loop, "CB_ATTL");
   object_delete(loop, "CB_ATTEXT");
  }
//+------------------------------------------------------------------+
//|              create trend lines                                  |
//+------------------------------------------------------------------+
void create_high_trend_line(int mode)
  {
   if(perv_high_trend_line_done[mode] == False)
     {
      ObjectDelete(ChartID(), perv_high_trend_line[mode][0]);
      ObjectDelete(ChartID(), perv_high_trend_line[mode][1]);
      ObjectDelete(ChartID(), perv_high_trend_line[mode][2]);
      if(mode == 0)
        {
         line_creator(second_perv_high_value[mode], second_perv_high_time[mode], perv_high_value[mode], perv_high_time[mode], trend_long_color, STYLE_SOLID, 2, True);
         perv_high_trend_line[mode][0] = "CB_ATTL" + IntegerToString(object_counter - 1);
         line_creator(second_perv_high_value[mode] + 0.25 * atr, second_perv_high_time[mode], perv_high_value[mode] + 0.25 * atr, perv_high_time[mode], trend_long_color, STYLE_DOT, 1, True);
         perv_high_trend_line[mode][1] = "CB_ATTL" + IntegerToString(object_counter - 1);
         line_creator(second_perv_high_value[mode] - 0.25 * atr, second_perv_high_time[mode], perv_high_value[mode] - 0.25 * atr, perv_high_time[mode], trend_long_color, STYLE_DOT, 1, True);
         perv_high_trend_line[mode][2] = "CB_ATTL" + IntegerToString(object_counter - 1);
        }
      else
         if(mode == 1)
           {
            line_creator(second_perv_high_value[mode], second_perv_high_time[mode], perv_high_value[mode], perv_high_time[mode], trend_medium_color, STYLE_SOLID, 2, True);
            perv_high_trend_line[mode][0] = "CB_ATTL" + IntegerToString(object_counter - 1);
            line_creator(second_perv_high_value[mode] + 0.25 * atr, second_perv_high_time[mode], perv_high_value[mode] + 0.25 * atr, perv_high_time[mode], trend_medium_color, STYLE_DOT, 1, True);
            perv_high_trend_line[mode][1] = "CB_ATTL" + IntegerToString(object_counter - 1);
            line_creator(second_perv_high_value[mode] - 0.25 * atr, second_perv_high_time[mode], perv_high_value[mode] - 0.25 * atr, perv_high_time[mode], trend_medium_color, STYLE_DOT, 1, True);
            perv_high_trend_line[mode][2] = "CB_ATTL" + IntegerToString(object_counter - 1);
           }
         else
            if(mode == 2)
              {
               line_creator(second_perv_high_value[mode], second_perv_high_time[mode], perv_high_value[mode], perv_high_time[mode], trend_short_color, STYLE_SOLID, 2, True);
               perv_high_trend_line[mode][0] = "CB_ATTL" + IntegerToString(object_counter - 1);
               line_creator(second_perv_high_value[mode] + 0.25 * atr, second_perv_high_time[mode], perv_high_value[mode] + 0.25 * atr, perv_high_time[mode], trend_short_color, STYLE_DOT, 1, True);
               perv_high_trend_line[mode][1] = "CB_ATTL" + IntegerToString(object_counter - 1);
               line_creator(second_perv_high_value[mode] - 0.25 * atr, second_perv_high_time[mode], perv_high_value[mode] - 0.25 * atr, perv_high_time[mode], trend_short_color, STYLE_DOT, 1, True);
               perv_high_trend_line[mode][2] = "CB_ATTL" + IntegerToString(object_counter - 1);
              }
      perv_high_trend_line_done[mode] = True;
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void create_low_trend_line(int mode)
  {
   if(perv_low_trend_line_done[mode] == False)
     {
      ObjectDelete(ChartID(), perv_low_trend_line[mode][0]);
      ObjectDelete(ChartID(), perv_low_trend_line[mode][1]);
      ObjectDelete(ChartID(), perv_low_trend_line[mode][2]);
      if(mode == 0)
        {
         line_creator(second_perv_low_value[mode], second_perv_low_time[mode], perv_low_value[mode], perv_low_time[mode], trend_long_color, STYLE_SOLID, 2, True);
         perv_low_trend_line[mode][0] = "CB_ATTL" + IntegerToString(object_counter - 1);
         line_creator(second_perv_low_value[mode] + 0.25 * atr, second_perv_low_time[mode], perv_low_value[mode] + 0.25 * atr, perv_low_time[mode], trend_long_color, STYLE_DOT, 1, True);
         perv_low_trend_line[mode][1] = "CB_ATTL" + IntegerToString(object_counter - 1);
         line_creator(second_perv_low_value[mode] - 0.25 * atr, second_perv_low_time[mode], perv_low_value[mode] - 0.25 * atr, perv_low_time[mode], trend_long_color, STYLE_DOT, 1, True);
         perv_low_trend_line[mode][2] = "CB_ATTL" + IntegerToString(object_counter - 1);
        }
      else
         if(mode == 1)
           {
            line_creator(second_perv_low_value[mode], second_perv_low_time[mode], perv_low_value[mode], perv_low_time[mode], trend_medium_color, STYLE_SOLID, 2, True);
            perv_low_trend_line[mode][0] = "CB_ATTL" + IntegerToString(object_counter - 1);
            line_creator(second_perv_low_value[mode] + 0.25 * atr, second_perv_low_time[mode], perv_low_value[mode] + 0.25 * atr, perv_low_time[mode], trend_medium_color, STYLE_DOT, 1, True);
            perv_low_trend_line[mode][1] = "CB_ATTL" + IntegerToString(object_counter - 1);
            line_creator(second_perv_low_value[mode] - 0.25 * atr, second_perv_low_time[mode], perv_low_value[mode] - 0.25 * atr, perv_low_time[mode], trend_medium_color, STYLE_DOT, 1, True);
            perv_low_trend_line[mode][2] = "CB_ATTL" + IntegerToString(object_counter - 1);
           }
         else
            if(mode == 2)
              {
               line_creator(second_perv_low_value[mode], second_perv_low_time[mode], perv_low_value[mode], perv_low_time[mode], trend_short_color, STYLE_SOLID, 2, True);
               perv_low_trend_line[mode][0] = "CB_ATTL" + IntegerToString(object_counter - 1);
               line_creator(second_perv_low_value[mode] + 0.25 * atr, second_perv_low_time[mode], perv_low_value[mode] + 0.25 * atr, perv_low_time[mode], trend_short_color, STYLE_DOT, 1, True);
               perv_low_trend_line[mode][1] = "CB_ATTL" + IntegerToString(object_counter - 1);
               line_creator(second_perv_low_value[mode] - 0.25 * atr, second_perv_low_time[mode], perv_low_value[mode] - 0.25 * atr, perv_low_time[mode], trend_short_color, STYLE_DOT, 1, True);
               perv_low_trend_line[mode][2] = "CB_ATTL" + IntegerToString(object_counter - 1);
              }
      perv_low_trend_line_done[mode] = True;
     }
  }



