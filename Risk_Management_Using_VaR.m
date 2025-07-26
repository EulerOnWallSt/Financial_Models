%% Project 3: Simplified Risk Management using VaR and CVaR (No CSV)
clc; clear; close all;

% -------------------------------
% STEP 1: Simulate Portfolio Returns
% -------------------------------
n_assets = 3;
n_days = 250;  % Simulate ~1 year of daily returns

% Simulate daily returns (normally distributed, mean 0.001, std 0.02)
mu = [0.001, 0.0005, 0.0015];  % expected daily returns
sigma = [0.02, 0.015, 0.025];  % standard deviations

returns = randn(n_days, n_assets) .* sigma + mu;

% -------------------------------
% STEP 2: Define Portfolio Weights
% -------------------------------
weights = [0.4, 0.3, 0.3];  % must sum to 1
port_returns = returns * weights';

% -------------------------------
% STEP 3: Compute Parametric VaR (99% Confidence)
% -------------------------------
port_mean = mean(port_returns);
port_std = std(port_returns);
z_99 = norminv(0.01);  % 1% left tail
parametric_VaR = -(port_mean + z_99 * port_std);

fprintf('Parametric 1-day 99%% VaR: %.4f (%.2f%% of portfolio)\n', parametric_VaR, parametric_VaR*100);

% -------------------------------
% STEP 4: Monte Carlo Simulation for VaR and CVaR
% -------------------------------
n_sim = 10000;
simulated_returns = randn(n_sim, 1) * port_std + port_mean;

sorted_losses = sort(-simulated_returns);  % losses = -returns
VaR_99 = sorted_losses(round(0.01 * n_sim));
CVaR_99 = mean(sorted_losses(1:round(0.01 * n_sim)));

fprintf('Monte Carlo 1-day 99%% VaR: %.4f\n', VaR_99);
fprintf('Monte Carlo 1-day 99%% CVaR: %.4f\n', CVaR_99);

% -------------------------------
% STEP 5: Plot Histogram
% -------------------------------
figure;
histogram(simulated_returns, 50);
hold on;
xline(-VaR_99, 'r--', 'VaR 99%', 'LabelHorizontalAlignment','left');
xline(-CVaR_99, 'k--', 'CVaR 99%', 'LabelHorizontalAlignment','left');
title('Simulated Portfolio Returns');
xlabel('Daily Return'); ylabel('Frequency');
grid on;
