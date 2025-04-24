function temp_prediction(a, currentDate, location)
% REAL-TIME TEMPERATURE PREDICTION AND ALERT SYSTEM
% Inputs:
% a - Arduino object
% currentDate - String of current date
% location - String of sensor location
%
% Features:
% 1. Calculates temperature change rate
% 2. Predicts temperature in 5 minutes
% 3. Visual alerts through LEDs
% 4. Noise filtering with moving average

fprintf('\n=== Temperature Prediction Initialized ===\n');
fprintf('Date: %s\nLocation: %s\n\n', currentDate, location);

% Initialize parameters
windowSize = 5; % Data window for rate calculation (seconds)
predictionHorizon = 300; % 5 minutes = 300 seconds
tempHistory = []; % Temperature buffer
timeHistory = []; % Time buffer

% LED control parameters
ledUpdateInterval = 1; % LED status check interval (seconds)
lastLedUpdate = tic;

%% Main prediction loop
while true
    % Read current temperature
    voltage = readVoltage(a, 'A0');
    currentTemp = (voltage - 0.5) * 100;
    currentTime = toc;

    % Update data buffers
    tempHistory = [tempHistory currentTemp];
    timeHistory = [timeHistory currentTime];

    % Maintain buffer size
    if length(tempHistory) > windowSize
        tempHistory(1) = [];
        timeHistory(1) = [];
    end

    %% Rate calculation and prediction
    if length(tempHistory) >= windowSize
        % Apply moving average filter
        filteredTemp = movmean(tempHistory, windowSize);

        % Calculate rate of change (°C/s)
        timeDelta = timeHistory(end) - timeHistory(1);
        tempDelta = filteredTemp(end) - filteredTemp(1);
        rate = tempDelta / timeDelta;

        % Convert to °C/min
        ratePerMin = rate * 60;

        % Predict future temperature
        predictedTemp = currentTemp + rate * predictionHorizon;

        %% LED Alert System
        if toc(lastLedUpdate) >= ledUpdateInterval
            % Reset all LEDs first
            writeDigitalPin(a, 'D9', 0);
            writeDigitalPin(a, 'D10', 0);
            writeDigitalPin(a, 'D11', 0);

            % Comfort range & stable
            if (currentTemp >= 18 && currentTemp <= 24) && abs(ratePerMin) <= 4
writeDigitalPin(a, 'D9', 1); % Green LED

            % Rapid heating
            elseif ratePerMin > 4
writeDigitalPin(a, 'D11', 1); % Red LED

            % Rapid cooling
            elseif ratePerMin < -4
writeDigitalPin(a, 'D10', 1); % Yellow LED
            end
           
            lastLedUpdate = tic;
         end

         %% Console Output
         fprintf('Current: %6.2f°C | ', currentTemp);
         fprintf('Rate: %6.2f°C/min | ', ratePerMin);
         fprintf('Predicted: %6.2f°C\n', predictedTemp);
      end 

      pause(0.1); % Reduce CPU usage
   end
end
