# Asian Session Breakout Expert Advisor

**Category:** Session Breakout

---

## Overview

This Expert Advisor implements a session-based breakout strategy focused on the Asian trading session.

The system identifies the price range formed during the Asian session and trades breakouts that occur during the London session.

This approach is commonly used to capture volatility expansion after low-volatility periods.

This project is part of a broader portfolio focused on **modular EA design, reusable components, and robust trade execution**.

---

## Platforms

**Platforms:** MQL4 / MQL5

**Status**

* MQL4: original implementation
* MQL5: refactored using shared framework

---

## Features

* Automatic Asian session range detection
* Configurable session start and end times
* Breakout entry logic for both directions
* Optional pending order placement
* Range validation filters (min/max size)
* Single breakout per session control
* Stop Loss and Take Profit management
* Break-even and trailing stop logic
* Spread, time, and execution filters
* Modular structure aligned with shared EA framework

---

## Strategy Logic

### Range Calculation

* The EA calculates the high and low of the Asian session
* This range defines the breakout levels for the next session

---

### Breakout Execution

* A **BUY trade** is triggered when price breaks above the Asian high
* A **SELL trade** is triggered when price breaks below the Asian low

The breakout is typically traded during the London session, where volatility increases.

---

### Trade Management

* Only one breakout per session can be allowed (configurable)
* Optional filters can prevent trading in:

  * low volatility ranges
  * excessively large ranges

The goal is to avoid false breakouts and low-quality setups.

---

## Demo Code

This repository includes a simplified demo version focused on session range calculation and breakout detection:

* [`demo_signal_logic_ASIAN_BREAKOUT.mq4`](./demo_signal_logic_ASIAN_BREAKOUT.mq4)

The demo version illustrates how the session range is calculated and how breakout conditions are detected, without including full trade execution and risk management logic.

---

## MQL5 Version

This Expert Advisor has been refactored into MQL5 using a shared framework designed to improve execution reliability and code structure.

### Key improvements include:

* CTrade-based execution system
* Session time handling using structured time functions
* Accurate range calculation using price series
* Breakout detection based on real-time price data
* Improved control over session state and trade timing
* Consistent position tracking using Magic Number + Symbol
* Separation between:

  * session logic
  * breakout detection
  * execution
  * trade management

The MQL5 version provides a more robust and flexible structure for session-based strategies.

---

## Shared Framework Highlights

The MQL5 version leverages a reusable framework shared across all EAs in this portfolio:

* Unified trade execution via `CTrade`
* Broker stop-level validation and safety buffers
* Spread, time, and equity protection filters
* Safe order send logic with retry handling
* Modular architecture separating signals, execution, and management

---

## Screenshots

### MQL4 Example

![MQL4 Example](./images/asian-session-breakout-example.png)

### MQL5 Version

![MQL5 Example](./images/example_mql5.png)

---

## Notes

This repository represents a **public showcase version** of the strategy.

The focus is on demonstrating:

* session-based logic
* breakout detection
* framework integration

while keeping the implementation clean and modular.

---

## Disclaimer

This software is for educational and demonstration purposes only.
Trading involves risk, and past performance does not guarantee future results.
