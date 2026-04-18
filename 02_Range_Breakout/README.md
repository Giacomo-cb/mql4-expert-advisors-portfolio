# Range Levels Breakout Expert Advisor

Professional MT4/MT5 Expert Advisor designed to trade breakout movements from dynamically calculated intraday range levels.

Platforms: MQL4 / MQL5
Status:
- MQL4: original implementation
- MQL5: refactored using shared framework

## Features
- automatic high/low range detection
- breakout buy and sell entries
- dynamic upper and lower breakout zones
- optional retest confirmation
- stop loss and take profit management
- breakout invalidation filters
- modular risk and execution architecture

## Strategy Logic
The EA continuously calculates breakout zones from recent price action highs and lows.

A buy position is triggered when price breaks above the upper resistance level, while sell positions activate on bearish downside breaks below support.

The architecture supports spread filtering, safe execution, and reusable level-based trade management.

## Portfolio Notes
This project is part of a professional Expert Advisor portfolio covering moving average crossover, session breakout, RSI mean reversion, and basket/grid systems.

## Demo Code
A simplified public demo of the breakout signal logic is available here:

- [demo_signal_logic.mq4](./demo_signal_logic_RANGE_BREAKOUT.mq4)

This repository includes a compilable MQL4 breakout-logic demo for technical portfolio verification.

## MQL5 Version

This Expert Advisor has been refactored into MQL5 using a shared framework designed for:

- safer order execution (CTrade)
- broker stop-level handling
- consistent position tracking (Magic Number + Symbol)
- modular structure separating signal, execution, and management
- improved robustness compared to the original MQL4 version

The chart visualization shown below belongs to the full production version and is intentionally excluded from the public demo source.

## Screenshot MQL4
![Range Breakout Example](range-breakout-example.png)

## Screenshot MQL5
![Range Breakout Example](range_breakout_screen_MQL5.png)
