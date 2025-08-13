# Auto Trend Lines Indicator for MetaTrader 4 & 5

An intelligent trend line detection indicator that automatically identifies and draws trend lines with trend channels across multiple timeframes. Perfect for technical analysis and trend following strategies.

## Description

Advanced auto trend line indicator with multi-timeframe analysis for MT4/MT5. Automatically detects swing highs/lows and draws trend lines with channels. Features long-term (36), medium-term (21), and short-term (9) period analysis. Includes ATR filtering and customizable colors/styles for precise trend identification.

The Auto Trend Lines indicator automatically analyzes price action and draws:
- **Zig-Zag Lines**: Connecting significant swing points across three timeframes
- **Trend Lines**: Automatic trend line detection with forward projection
- **Trend Channels**: Parallel support and resistance lines around main trend
- **ATR Filtering**: Uses Average True Range to filter out noise and false signals

This sophisticated indicator works on both MetaTrader 4 and MetaTrader 5 platforms, providing traders with professional-grade automated technical analysis.

## Features

- ✅ Compatible with both **MetaTrader 4** and **MetaTrader 5**
- ✅ **Three timeframe analysis** (Long, Medium, Short term)
- ✅ **Automatic trend line detection** with swing point analysis
- ✅ **Trend channels** with parallel support/resistance lines
- ✅ **ATR-based filtering** to eliminate false signals
- ✅ **Customizable colors and styles** for each timeframe
- ✅ **Real-time updates** as new swing points develop
- ✅ **Forward projection** of trend lines for future analysis
- ✅ **Works on all timeframes** and instruments

## Installation

### For MetaTrader 5:
1. Download the `.mq5` file
2. Copy to: `MT5 Data Folder/MQL5/Indicators/`
3. Restart MT5 or refresh Navigator
4. Find "Auto Trend Lines" in Custom Indicators
5. Drag and drop onto your chart

### For MetaTrader 4:
1. Download the `.mq4` file
2. Copy to: `MT4 Data Folder/MQL4/Indicators/`
3. Restart MT4 or refresh Navigator
4. Find "Auto Trend Lines" in Custom Indicators
5. Drag and drop onto your chart

## Parameters

### Long Term Settings (36 Period)
| Parameter | Default | Description |
|-----------|---------|-------------|
| `show_long_line` | true | Display long-term zig-zag lines |
| `long_period` | 36 | Pivot period for long-term analysis |
| `long_line_style` | STYLE_SOLID | Line style for zig-zag |
| `long_color` | CornflowerBlue | Color of zig-zag lines |
| `long_line_width` | 2 | Width of zig-zag lines |
| `show_long_trend_line` | true | Display long-term trend lines |
| `trend_long_color` | DarkOrange | Color of trend lines |

### Medium Term Settings (21 Period)
| Parameter | Default | Description |
|-----------|---------|-------------|
| `show_medium_line` | true | Display medium-term zig-zag lines |
| `medium_period` | 21 | Pivot period for medium-term analysis |
| `medium_line_style` | STYLE_SOLID | Line style for zig-zag |
| `medium_color` | MediumTurquoise | Color of zig-zag lines |
| `medium_line_width` | 1 | Width of zig-zag lines |
| `show_medium_trend_line` | true | Display medium-term trend lines |
| `trend_medium_color` | LightSeaGreen | Color of trend lines |

### Short Term Settings (9 Period)
| Parameter | Default | Description |
|-----------|---------|-------------|
| `show_short_line` | true | Display short-term zig-zag lines |
| `short_period` | 9 | Pivot period for short-term analysis |
| `short_line_style` | STYLE_DASHDOT | Line style for zig-zag |
| `short_color` | Salmon | Color of zig-zag lines |
| `short_line_width` | 1 | Width of zig-zag lines |
| `show_short_trend_line` | true | Display short-term trend lines |
| `trend_short_color` | LightSteelBlue | Color of trend lines |

## How It Works

### Swing Point Detection
1. **ATR Filtering**: Uses 360-period ATR to filter significant price moves
2. **Pivot Analysis**: Identifies swing highs and lows based on configurable periods
3. **Time Validation**: Ensures sufficient time between swing points
4. **Price Validation**: Confirms moves exceed ATR threshold

### Trend Line Creation
1. **Automatic Detection**: Connects consecutive swing points
2. **Forward Projection**: Extends trend lines into the future
3. **Channel Creation**: Draws parallel lines above and below main trend
4. **Real-time Updates**: Adjusts as new swing points develop

### Multi-Timeframe Analysis
- **Long Term (36)**: Major trend identification
- **Medium Term (21)**: Intermediate trend analysis
- **Short Term (9)**: Short-term trend and entry timing

## Trading Applications

### Trend Following
- **Trend Direction**: Identify overall market direction
- **Trend Strength**: Multiple timeframes confirming direction
- **Trend Changes**: Early detection of trend reversals

### Support and Resistance
- **Dynamic Levels**: Trend lines act as dynamic support/resistance
- **Channel Trading**: Trade within trend channels
- **Breakout Signals**: Trend line breaks signal potential reversals

### Entry and Exit Strategies
- **Entry Timing**: Enter on pullbacks to trend lines
- **Stop Placement**: Place stops beyond trend channels
- **Profit Targets**: Use opposing trend lines as targets

### Risk Management
- **Trend Confirmation**: Multiple timeframes reduce false signals
- **Clear Levels**: Well-defined support and resistance
- **Position Sizing**: Adjust based on trend strength

## Visual Elements

### Zig-Zag Lines
- **Long Term**: Cornflower blue, solid, width 2
- **Medium Term**: Medium turquoise, solid, width 1
- **Short Term**: Salmon, dash-dot, width 1

### Trend Lines
- **Long Term**: Dark orange, solid, width 2
- **Medium Term**: Light sea green, solid, width 2
- **Short Term**: Light steel blue, solid, width 2

### Trend Channels
- **Main Line**: Solid trend line
- **Upper Channel**: Dotted line +0.25 ATR above
- **Lower Channel**: Dotted line -0.25 ATR below

## Usage Tips

### Best Practices
1. **Combine timeframes** for comprehensive analysis
2. **Wait for confirmations** from multiple periods
3. **Use with other indicators** for additional confirmation
4. **Adjust periods** based on market volatility

### Trading Strategies
- **Trend Continuation**: Enter on pullbacks to trend lines
- **Channel Trading**: Buy at lower channel, sell at upper
- **Breakout Trading**: Trade breaks of established trend lines
- **Divergence Analysis**: Look for price vs. trend line divergences

## Compatibility

| Platform | Version | Status |
|----------|---------|---------|
| MetaTrader 4 | Build 1380+ | ✅ Supported |
| MetaTrader 5 | Build 3440+ | ✅ Supported |
| All Timeframes | M1 to MN1 | ✅ Compatible |
| All Instruments | Forex, Stocks, Crypto, Commodities | ✅ Compatible |
| All Chart Types | Candlestick, Bar, Line | ✅ Compatible |

## Performance Features

- **Automatic Updates**: Real-time recalculation as price moves
- **Efficient Memory**: Optimized object management
- **Clean Display**: Automatic cleanup of outdated lines
- **Customizable**: Extensive color and style options

## Version History

- **v1.08** - Enhanced stability and MT4/MT5 compatibility
- **v1.07** - Improved ATR filtering and performance
- **v1.06** - Added trend channel functionality
- **v1.05** - Optimized swing point detection
- **v1.04** - Enhanced multi-timeframe analysis
- **v1.03** - Improved visual elements
- **v1.02** - Bug fixes and optimizations
- **v1.01** - Initial release

## Technical Requirements

### Minimum System Requirements
- MetaTrader 4 (Build 1380+) or MetaTrader 5 (Build 3440+)
- Windows 7/8/10/11 or compatible system
- 100MB available storage space
- Stable internet connection for real-time analysis

## Advanced Features

### ATR-Based Filtering
- Uses 360-period ATR for noise reduction
- Filters out insignificant price movements
- Ensures only meaningful swing points are detected

### Intelligent Object Management
- Automatic cleanup of outdated trend lines
- Efficient memory usage
- Real-time updates without performance degradation

### Multi-Layer Analysis
- Three independent timeframe analyses
- Configurable parameters for each timeframe
- Comprehensive trend identification system

## Risk Warning

⚠️ **Important Disclaimer**: 
- Trading involves substantial risk of loss
- Past performance doesn't guarantee future results
- This indicator is for educational purposes only
- Always use proper risk management
- Never risk more than you can afford to lose
- Trend lines can break without warning
- Multiple confirmations are recommended
- Consider seeking professional financial advice

## Support & Resources

- 🌐 **Website**: [TradingFinder.com](https://tradingfinder.com)
- 📊 **More Indicators**: [MT4/MT5 Products](https://tradingfinder.com/products/indicators/)
- 📚 **Trading Education**: Available on our website

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.

**Developed by TFLab | TradingFinder.com**  
*Empowering traders with professional-grade technical analysis tools*
