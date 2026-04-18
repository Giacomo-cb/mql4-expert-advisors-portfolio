# Moving Average Crossover Expert Advisor

Professional MT4/MT5 Expert Advisor based on fast and slow moving average crossover logic.

##Platforms: MQL4 / MQL5
Status:
- MQL4: original implementation
- MQL5: refactored using shared framework


## Features
- configurable fast and slow MA periods
- buy/sell crossover entries
- optional trend filter
- stop loss and take profit
- trailing stop support
- clean modular architecture
- optimized for easy strategy customization

## Strategy Logic
The EA opens buy positions when the fast moving average crosses above the slow moving average, and sell positions on bearish crossovers.

It includes spread checks, safe order execution, and modular trade management.

## Portfolio Notes
This project is part of a professional Expert Advisor portfolio covering breakout, RSI, session, and basket/grid strategies.
## Demo Code
A simplified public demo of the signal logic is available here:

- [demo_signal_logic.mq4](./demo_signal_logic_MA_CROSS.mq4)

This repository includes a compilable MQL4 signal-logic demo for technical portfolio verification.

## MQL5 Version

This Expert Advisor has been refactored into MQL5 using a shared framework designed for:

- safer order execution (CTrade)
- broker stop-level handling
- consistent position tracking (Magic Number + Symbol)
- modular structure separating signal, execution, and management
- improved robustness compared to the original MQL4 version


The chart visualization shown below belongs to the full production version and is intentionally excluded from the public demo source.

## Screenshot
![MA Crossover Example](EA_movign_average_screen.png)
