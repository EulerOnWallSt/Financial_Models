# Install required packages
install.packages(c("quantmod", "TTR", "PerformanceAnalytics"))

# Load libraries
library(quantmod)
library(TTR)
library(PerformanceAnalytics)

# Get stock data
getSymbols("AAPL", from = "2022-01-01", to = "2023-01-01")
prices <- Cl(AAPL)  # Closing prices

# Calculate Bollinger Bands
bbands <- BBands(prices, n = 20, sd = 2)

# Create trading signals
signal <- ifelse(prices > bbands$up, 1, 
                 ifelse(prices < bbands$dn, -1, 0))
signal <- na.locf(signal, na.rm = FALSE)  # Carry forward last signal

# Calculate daily returns
daily_ret <- ROC(prices) * Lag(signal)
daily_ret[is.na(daily_ret)] <- 0

# Performance summary
charts.PerformanceSummary(daily_ret, main = "Bollinger Bands Breakout Strategy")
