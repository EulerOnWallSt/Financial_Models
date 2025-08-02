clc; 
clear; 
close all;

% Generate synthetic stock price (true trend + noise)
n = 100;
true_price = cumsum(randn(n,1) * 0.5 + 0.1);     % Simulated upward trend
obs_noise = randn(n,1) * 2;                      % Observation noise
observed_price = true_price + obs_noise;

% Initialize Kalman filter variables
x_est = zeros(n,1);      % Estimated true price
P = zeros(n,1);          % Estimation error covariance
Q = 0.01;                % Process noise variance
R = 4;                   % Observation noise variance

% Initial estimates
x_est(1) = observed_price(1);
P(1) = 1;

% Kalman Filter loop
for t = 2:n
    % Prediction step
    x_pred = x_est(t-1);         % Predict next state
    P_pred = P(t-1) + Q;         % Predict error covariance

    % Kalman gain
    K = P_pred / (P_pred + R);

    % Update step
    x_est(t) = x_pred + K * (observed_price(t) - x_pred);
    P(t) = (1 - K) * P_pred;
end

% Plotting results
figure;
plot(1:n, observed_price, 'r.', 'DisplayName', 'Observed Price');
hold on;
plot(1:n, true_price, 'k--', 'DisplayName', 'True Price');
plot(1:n, x_est, 'b-', 'LineWidth', 2, 'DisplayName', 'Kalman Estimate');
legend();
xlabel('Time'); ylabel('Price');
title('Simple Kalman Filter for Stock Price Smoothing');
