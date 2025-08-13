//+------------------------------------------------------------------+
//|                                             Auto Trend Lines.mq5 |
//|                                                                  |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "TradingFinder.com - 2025"
#property link      "https://tradingfinder.com/products/indicators/mt5/"
#property version   "1.08"
#property description ""
#property description "Risk Warning: Trading in financial markets involves risk, and you may lose part or all of your money. Using this indicator is at your own risk. we create software for educational purposes. We are not responsible for any losses or damages."
#property description ""
#property description "Find out more on TradingFinder.com"
#property icon    "\\Images\\Logo.ico"

#property strict
#property indicator_chart_window
#property indicator_plots 0

//+------------------------------------------------------------------+
//|                  inputs and variables                            |
//+------------------------------------------------------------------+
input group "==== Long Term Zig Zag Line Properties ====";
input bool show_long_line = true; // Display the Long Term Zig Zag Line
input int long_period = 36; // Pivot period for the Long Term Zig Zag Line
input ENUM_LINE_STYLE long_line_style = STYLE_SOLID; // Style of the Long Term Zig Zag Line
input color long_color = clrCornflowerBlue; // Color of the Long Term Zig Zag Line
input int long_line_width = 2; // Width of the Long Term Zig Zag Line

input group "==== Long Term Trend Line Properties ====";
input bool show_long_trend_line = true; // Display the Long Term Trend Line
input color trend_long_color = clrDarkOrange; // Color of the Long Term Trend Line

input group "==== Medium Term Zig Zag Line Properties ====";
input bool show_medium_line = true; // Display the Medium Term Zig Zag Line
input int medium_period = 21; // Pivot period for the Medium Term Zig Zag Line
input ENUM_LINE_STYLE medium_line_style = STYLE_SOLID; // Style of the Medium Term Zig Zag Line
input color medium_color = clrMediumTurquoise; // Color of the Medium Term Zig Zag Line
input int medium_line_width = 1; // Width of the Medium Term Zig Zag Line

input group "==== Medium Term Trend Line Properties ====";
input bool show_medium_trend_line = true; // Display the Medium Term Trend Line
input color trend_medium_color = clrLightSeaGreen; // Color of the Medium Term Trend Line

input group "==== Short Term Zig Zag Line Properties ====";
input bool show_short_line = true; // Display the Short Term Zig Zag Line
input int short_period = 9; // Pivot period for the Short Term Zig Zag Line
input ENUM_LINE_STYLE short_line_style = STYLE_DASHDOT; // Style of the Short Term Zig Zag Line
input color short_color = clrSalmon; // Color of the Short Term Zig Zag Line
input int short_line_width = 1; // Width of the Short Term Zig Zag Line

input group "==== Short Term Trend Line Properties ====";
input bool show_short_trend_line = true; // Display the Short Term Trend Line
input color trend_short_color = clrLightSteelBlue; // Color of the Short Term Trend Line


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

int atr_handle = NULL;
double atr_buffer[];
datetime one_candle_time = NULL;
bool first_run = false;
int last_rates_total = NULL;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   atr_handle = iATR(Symbol(), PERIOD_CURRENT, 360);
   ArraySetAsSeries(atr_buffer, true);

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
   object_delete(loop, "ATTEXT");
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

   CopyBuffer(atr_handle, 0, 0, 1, atr_buffer);

   if(first_run == false)
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

      first_run = true;
     }

   if(first_run == true)
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
   ObjectSetInteger(ChartID(), "CB_ATTL" + IntegerToString(object_counter), OBJPROP_RAY_RIGHT, false);
   ObjectSetInteger(ChartID(), "CB_ATTL" + IntegerToString(object_counter), OBJPROP_SELECTABLE, false);
   ObjectSetInteger(ChartID(), "CB_ATTL" + IntegerToString(object_counter), OBJPROP_RAY_RIGHT, ray_right);
   object_counter += 1;
   return "CB_ATTL" + IntegerToString(object_counter - 1);
  }
//text
void create_text(int anchor, datetime t, double p, string text, color clr, int size)
  {
   ObjectCreate(ChartID(), "ATTEXT" + IntegerToString(object_counter), OBJ_TEXT, 0, t, p);
   ObjectSetString(ChartID(), "ATTEXT" + IntegerToString(object_counter), OBJPROP_TEXT,text);
   ObjectSetInteger(ChartID(), "ATTEXT" + IntegerToString(object_counter), OBJPROP_FONTSIZE, size);
   ObjectSetInteger(ChartID(), "ATTEXT" + IntegerToString(object_counter), OBJPROP_COLOR, clr);
   ObjectSetInteger(ChartID(), "ATTEXT" + IntegerToString(object_counter), OBJPROP_SELECTABLE, false);
   ObjectSetString(ChartID(), "ATTEXT" + IntegerToString(object_counter), OBJPROP_FONT, "Arial Black");
   ObjectSetInteger(ChartID(), "ATTEXT" + IntegerToString(object_counter), OBJPROP_ANCHOR, anchor);
  }
//+------------------------------------------------------------------+
//|                   initial function                               |
//+------------------------------------------------------------------+
void initial_function(int mode, int i, int time_factor)
  {
   if(initial_low_done[mode] == false && floating_low_value[mode] == NULL)
     {
      floating_low_value[mode] = iLow(Symbol(), PERIOD_CURRENT, iLowest(Symbol(), PERIOD_CURRENT, MODE_LOW, time_factor, i));
      floating_low_time[mode] = iTime(Symbol(), PERIOD_CURRENT, iLowest(Symbol(), PERIOD_CURRENT, MODE_LOW, time_factor, i));

      perv_candle_time[mode] = iTime(Symbol(), PERIOD_CURRENT, i);
     }
   if(initial_low_done[mode] == false && floating_low_value[mode] != NULL && iTime(Symbol(), PERIOD_CURRENT, i) != perv_candle_time[mode] && iLow(Symbol(), PERIOD_CURRENT, i) < floating_low_value[mode])
     {
      floating_low_value[mode] = iLow(Symbol(), PERIOD_CURRENT, i);
      floating_low_time[mode] = iTime(Symbol(), PERIOD_CURRENT, i);

      perv_candle_time[mode] = iTime(Symbol(), PERIOD_CURRENT, i);
     }
   if(
      initial_low_done[mode] == false &&
      floating_low_value[mode] != NULL &&
      iTime(Symbol(), PERIOD_CURRENT, i) != perv_candle_time[mode] &&
      iTime(Symbol(), PERIOD_CURRENT, iHighest(Symbol(), PERIOD_CURRENT, MODE_HIGH, time_factor, i)) - floating_low_time[mode] > time_factor * one_candle_time &&
      iHigh(Symbol(), PERIOD_CURRENT, iHighest(Symbol(), PERIOD_CURRENT, MODE_HIGH, time_factor, i)) - floating_low_value[mode] >= atr_buffer[0]
   )
     {
      perv_low_value[mode] = floating_low_value[mode];
      perv_low_time[mode] = floating_low_time[mode];

      perv_structure[mode] = "low";

      perv_candle_time[mode] = iTime(Symbol(), PERIOD_CURRENT, i);
      initial_low_done[mode] = true;

      floating_high_value[mode] = iHigh(Symbol(), PERIOD_CURRENT, iHighest(Symbol(), PERIOD_CURRENT, MODE_HIGH, time_factor, i));
      floating_high_time[mode] = iTime(Symbol(), PERIOD_CURRENT, iHighest(Symbol(), PERIOD_CURRENT, MODE_HIGH, time_factor, i));
     }
  }
//+------------------------------------------------------------------+
//|                   make high points                               |
//+------------------------------------------------------------------+
void make_high_points(int mode, bool show_line, int i, int time_factor, color line_color, int line_style, int line_width)
  {
   if(initial_low_done[mode] == true && perv_structure[mode] == "low" && iTime(Symbol(), PERIOD_CURRENT, i) != perv_candle_time[mode] && iHigh(Symbol(), PERIOD_CURRENT, i) > floating_high_value[mode])
     {
      floating_high_value[mode] = iHigh(Symbol(), PERIOD_CURRENT, i);
      floating_high_time[mode] = iTime(Symbol(), PERIOD_CURRENT, i);

      perv_candle_time[mode] = iTime(Symbol(), PERIOD_CURRENT, i);
     }
   if(
      initial_low_done[mode] == true &&
      perv_structure[mode] == "low" &&
      iTime(Symbol(), PERIOD_CURRENT, i) != perv_candle_time[mode] &&
      iTime(Symbol(), PERIOD_CURRENT, iLowest(Symbol(), PERIOD_CURRENT, MODE_LOW, time_factor, i)) - floating_high_time[mode] > time_factor * one_candle_time &&
      floating_high_value[mode] - iLow(Symbol(), PERIOD_CURRENT, iLowest(Symbol(), PERIOD_CURRENT, MODE_LOW, time_factor, i)) >= atr_buffer[0]
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

      if(show_line == true)
        {
         line_creator(perv_low_value[mode], perv_low_time[mode], perv_high_value[mode], perv_high_time[mode], line_color, line_style, line_width, false);
        }
      if((mode == 0 && show_long_trend_line) || (mode == 1 && show_medium_trend_line) || (mode == 2 && show_short_trend_line))
        {
         create_high_trend_line(mode);
         perv_low_trend_line_done[mode] = false;
        }
     }
  }
//+------------------------------------------------------------------+
//|                   make low points                                |
//+------------------------------------------------------------------+
void make_low_points(int mode, bool show_line, int i, int time_factor, color line_color, int line_style, int line_width)
  {
   if(initial_low_done[mode] == true && perv_structure[mode] == "high" && iTime(Symbol(), PERIOD_CURRENT, i) != perv_candle_time[mode] && iLow(Symbol(), PERIOD_CURRENT, i) < floating_low_value[mode])
     {
      floating_low_value[mode] = iLow(Symbol(), PERIOD_CURRENT, i);
      floating_low_time[mode] = iTime(Symbol(), PERIOD_CURRENT, i);

      perv_candle_time[mode] = iTime(Symbol(), PERIOD_CURRENT, i);
     }
   if(
      initial_low_done[mode] == true &&
      perv_structure[mode] == "high" &&
      iTime(Symbol(), PERIOD_CURRENT, i) != perv_candle_time[mode] &&
      iTime(Symbol(), PERIOD_CURRENT, iHighest(Symbol(), PERIOD_CURRENT, MODE_HIGH, time_factor, i)) - floating_low_time[mode] > time_factor * one_candle_time &&
      iHigh(Symbol(), PERIOD_CURRENT, iHighest(Symbol(), PERIOD_CURRENT, MODE_HIGH, time_factor, i)) - floating_low_value[mode] >= atr_buffer[0]
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

      if(show_line == true)
        {
         line_creator(perv_high_value[mode], perv_high_time[mode], perv_low_value[mode], perv_low_time[mode], line_color, line_style, line_width, false);
        }
      if((mode == 0 && show_long_trend_line) || (mode == 1 && show_medium_trend_line) || (mode == 2 && show_short_trend_line))
        {
         create_low_trend_line(mode);
         perv_high_trend_line_done[mode] = false;
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

   first_run = false;
   last_rates_total = NULL;

   int loop = 1000000;

   object_delete(loop, "CB_ATTL");
   object_delete(loop, "ATTEXT");
  }
//+------------------------------------------------------------------+
//|              create trend lines                                  |
//+------------------------------------------------------------------+
void create_high_trend_line(int mode)
  {
   if(perv_high_trend_line_done[mode] == false)
     {
      ObjectDelete(ChartID(), perv_high_trend_line[mode][0]);
      ObjectDelete(ChartID(), perv_high_trend_line[mode][1]);
      ObjectDelete(ChartID(), perv_high_trend_line[mode][2]);
      if(mode == 0)
        {
         line_creator(second_perv_high_value[mode], second_perv_high_time[mode], perv_high_value[mode], perv_high_time[mode], trend_long_color, STYLE_SOLID, 2, true);
         perv_high_trend_line[mode][0] = "CB_ATTL" + IntegerToString(object_counter - 1);
         line_creator(second_perv_high_value[mode] + 0.25 * atr_buffer[0], second_perv_high_time[mode], perv_high_value[mode] + 0.25 * atr_buffer[0], perv_high_time[mode], trend_long_color, STYLE_DOT, 1, true);
         perv_high_trend_line[mode][1] = "CB_ATTL" + IntegerToString(object_counter - 1);
         line_creator(second_perv_high_value[mode] - 0.25 * atr_buffer[0], second_perv_high_time[mode], perv_high_value[mode] - 0.25 * atr_buffer[0], perv_high_time[mode], trend_long_color, STYLE_DOT, 1, true);
         perv_high_trend_line[mode][2] = "CB_ATTL" + IntegerToString(object_counter - 1);
        }
      else
         if(mode == 1)
           {
            line_creator(second_perv_high_value[mode], second_perv_high_time[mode], perv_high_value[mode], perv_high_time[mode], trend_medium_color, STYLE_SOLID, 2, true);
            perv_high_trend_line[mode][0] = "CB_ATTL" + IntegerToString(object_counter - 1);
            line_creator(second_perv_high_value[mode] + 0.25 * atr_buffer[0], second_perv_high_time[mode], perv_high_value[mode] + 0.25 * atr_buffer[0], perv_high_time[mode], trend_medium_color, STYLE_DOT, 1, true);
            perv_high_trend_line[mode][1] = "CB_ATTL" + IntegerToString(object_counter - 1);
            line_creator(second_perv_high_value[mode] - 0.25 * atr_buffer[0], second_perv_high_time[mode], perv_high_value[mode] - 0.25 * atr_buffer[0], perv_high_time[mode], trend_medium_color, STYLE_DOT, 1, true);
            perv_high_trend_line[mode][2] = "CB_ATTL" + IntegerToString(object_counter - 1);
           }
         else
            if(mode == 2)
              {
               line_creator(second_perv_high_value[mode], second_perv_high_time[mode], perv_high_value[mode], perv_high_time[mode], trend_short_color, STYLE_SOLID, 2, true);
               perv_high_trend_line[mode][0] = "CB_ATTL" + IntegerToString(object_counter - 1);
               line_creator(second_perv_high_value[mode] + 0.25 * atr_buffer[0], second_perv_high_time[mode], perv_high_value[mode] + 0.25 * atr_buffer[0], perv_high_time[mode], trend_short_color, STYLE_DOT, 1, true);
               perv_high_trend_line[mode][1] = "CB_ATTL" + IntegerToString(object_counter - 1);
               line_creator(second_perv_high_value[mode] - 0.25 * atr_buffer[0], second_perv_high_time[mode], perv_high_value[mode] - 0.25 * atr_buffer[0], perv_high_time[mode], trend_short_color, STYLE_DOT, 1, true);
               perv_high_trend_line[mode][2] = "CB_ATTL" + IntegerToString(object_counter - 1);
              }
      perv_high_trend_line_done[mode] = true;
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void create_low_trend_line(int mode)
  {
   if(perv_low_trend_line_done[mode] == false)
     {
      ObjectDelete(ChartID(), perv_low_trend_line[mode][0]);
      ObjectDelete(ChartID(), perv_low_trend_line[mode][1]);
      ObjectDelete(ChartID(), perv_low_trend_line[mode][2]);
      if(mode == 0)
        {
         line_creator(second_perv_low_value[mode], second_perv_low_time[mode], perv_low_value[mode], perv_low_time[mode], trend_long_color, STYLE_SOLID, 2, true);
         perv_low_trend_line[mode][0] = "CB_ATTL" + IntegerToString(object_counter - 1);
         line_creator(second_perv_low_value[mode] + 0.25 * atr_buffer[0], second_perv_low_time[mode], perv_low_value[mode] + 0.25 * atr_buffer[0], perv_low_time[mode], trend_long_color, STYLE_DOT, 1, true);
         perv_low_trend_line[mode][1] = "CB_ATTL" + IntegerToString(object_counter - 1);
         line_creator(second_perv_low_value[mode] - 0.25 * atr_buffer[0], second_perv_low_time[mode], perv_low_value[mode] - 0.25 * atr_buffer[0], perv_low_time[mode], trend_long_color, STYLE_DOT, 1, true);
         perv_low_trend_line[mode][2] = "CB_ATTL" + IntegerToString(object_counter - 1);
        }
      else
         if(mode == 1)
           {
            line_creator(second_perv_low_value[mode], second_perv_low_time[mode], perv_low_value[mode], perv_low_time[mode], trend_medium_color, STYLE_SOLID, 2, true);
            perv_low_trend_line[mode][0] = "CB_ATTL" + IntegerToString(object_counter - 1);
            line_creator(second_perv_low_value[mode] + 0.25 * atr_buffer[0], second_perv_low_time[mode], perv_low_value[mode] + 0.25 * atr_buffer[0], perv_low_time[mode], trend_medium_color, STYLE_DOT, 1, true);
            perv_low_trend_line[mode][1] = "CB_ATTL" + IntegerToString(object_counter - 1);
            line_creator(second_perv_low_value[mode] - 0.25 * atr_buffer[0], second_perv_low_time[mode], perv_low_value[mode] - 0.25 * atr_buffer[0], perv_low_time[mode], trend_medium_color, STYLE_DOT, 1, true);
            perv_low_trend_line[mode][2] = "CB_ATTL" + IntegerToString(object_counter - 1);
           }
         else
            if(mode == 2)
              {
               line_creator(second_perv_low_value[mode], second_perv_low_time[mode], perv_low_value[mode], perv_low_time[mode], trend_short_color, STYLE_SOLID, 2, true);
               perv_low_trend_line[mode][0] = "CB_ATTL" + IntegerToString(object_counter - 1);
               line_creator(second_perv_low_value[mode] + 0.25 * atr_buffer[0], second_perv_low_time[mode], perv_low_value[mode] + 0.25 * atr_buffer[0], perv_low_time[mode], trend_short_color, STYLE_DOT, 1, true);
               perv_low_trend_line[mode][1] = "CB_ATTL" + IntegerToString(object_counter - 1);
               line_creator(second_perv_low_value[mode] - 0.25 * atr_buffer[0], second_perv_low_time[mode], perv_low_value[mode] - 0.25 * atr_buffer[0], perv_low_time[mode], trend_short_color, STYLE_DOT, 1, true);
               perv_low_trend_line[mode][2] = "CB_ATTL" + IntegerToString(object_counter - 1);
              }
      perv_low_trend_line_done[mode] = true;
     }
  }
