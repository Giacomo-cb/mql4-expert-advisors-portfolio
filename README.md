# MQL4 / MQL5 Expert Advisors Portfolio

Professional MetaTrader Expert Advisors portfolio showcasing multiple automated trading systems developed in **MQL4** and progressively refactored into a more robust and reusable **MQL5 framework**.

This repository is designed as a **technical portfolio for freelance and custom development work**, with a focus on:

- reusable EA architecture
- robust trade execution
- shared risk management
- strategy-specific modular logic
- MT4 to MT5 conversion and refactoring

---

## Portfolio Overview

This portfolio currently includes 5 Expert Advisors covering different strategy categories:

### 1. Moving Average Crossover
**Category:** Trend Following  
A classic crossover strategy using fast and slow moving averages, enhanced with shared trade management and execution protection.

### 2. Range Breakout
**Category:** Breakout  
Detects breakouts from a recent dynamic range, with configurable breakout confirmation, cooldown logic, and shared management features.

### 3. Asian Session Breakout
**Category:** Session Breakout  
Calculates the Asian session range and trades London session breakouts with optional pending orders, session filters, and range validation.

### 4. RSI Mean Reversion
**Category:** Mean Reversion  
Uses RSI-based reversal entries with optional trend and ATR filters, plus shared stop handling, execution logic, and RSI-based exit behavior.

### 5. RSI Basket Grid
**Category:** Basket / Grid / Recovery  
A more advanced basket management EA with RSI initial trigger, grid layering, basket TP logic, average price handling, drawdown protection, and chart objects/panel support.

---

## Current Development Status

This repository started as an **MQL4 Expert Advisors portfolio** and is being progressively expanded into a more complete **MQL4 + MQL5 portfolio**.

### MQL4
- Original strategy implementations
- Public portfolio showcase
- Strategy structure and reusable base components

### MQL5
- Refactored architecture using a shared framework
- Safer order execution and broker protection
- More robust position handling
- Better separation between:
  - signal logic
  - execution
  - risk management
  - trade filters
  - basket / management logic

---

## Shared Framework Features

The MQL5 side of the portfolio is built around a shared framework to keep all Expert Advisors consistent and reusable.

### Core shared features include:
- `CTrade`-based execution
- filling mode handling
- account mode awareness
- shared lot sizing and normalization
- spread / time / equity filters
- stop-level validation and extra broker buffer
- safe order send wrappers with retry logic
- tracked positions by **Magic Number + Symbol**
- daily trade counter
- one-trade-per-bar logic
- break-even and trailing stop management
- shared helper utilities for price, bars, and date handling

This allows strategy logic to stay specific to each EA while the underlying execution and protection layer remains consistent across the portfolio.

---

## Public Showcase vs Commercial Version

This repository is intended to demonstrate:
- code structure
- strategy implementation style
- framework design
- MetaTrader development capabilities

Some projects may include:
- public demo code
- reduced portfolio versions
- technical notes and screenshots

More advanced logic, especially for **basket/grid recovery systems**, may be partially abstracted or simplified in the public portfolio version.

---

## Main Areas of Expertise

- MT4 / MT5 Expert Advisor development
- MT4 to MT5 conversion
- custom trading automation
- breakout and session-based systems
- RSI and mean reversion logic
- basket / grid management systems
- trade management features
- indicator-to-EA conversion
- risk management architecture
- code refactoring and optimization

---

## Repository Structure

- `01_MA_Crossover`
- `02_Range_Breakout`
- `03_Asia_Session_Breakout`
- `04_RSI_Mean_Reversion`
- `05_RSI_Basket_Grid`

Each project folder contains its own README with strategy notes, implementation details, and public showcase material.

---

## Project Goal

The goal of this portfolio is to present a professional and credible MetaTrader development workflow suitable for:

- freelance clients
- custom EA development
- EA conversion projects
- debugging and feature extension work
- strategy prototyping and refactoring

---

## Author

**Giacomo Cipolat Bares**

MetaTrader Expert Advisor Developer  
MQL4 / MQL5 – Automation, Refactoring, Conversion, and Strategy Development
