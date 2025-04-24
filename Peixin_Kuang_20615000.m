% Peixin Kuangrduin
% ssypk1@nottingham.edu.cn

%% PRELIMINARY TASK - ARDUINO AND GIT INSTALLATION [10 MARKS]

% c)
% Initialize Arduino object
a = arduino('COM3', 'Uno');

% Test LED
for i = 1:10
    writeDigitalPin(a, 'D4', 1);
    pause (0.5);
    writeDigitalPin(a, 'D4', 0);
    pause (0.5);
end

%% TASK 1 - READ TEMPERATURE DATA, PLOT, AND WRITE TO A LOG FILE [20 MARKS]

% b) 
% Initialize Arduino object
a = arduino('COM3', 'Uno');
% Define the duration for data acquisition
duration = 600; % Duration of data acquisition in seconds
time = 0:1:duration;
tempData = zeros(size(time)); % Initialize array to store temperature data

% Loop to collect temperature data from the sensor
for i = 1:length(time)
    voltage = readVoltage(a,"A0");
    % Convert voltage to temperature using sensor's
    % voltage-to-totemperature furmula
    tempData(i) = (voltage - 0.5)*100;
    pause(1); % Wait for 1 second before reading next value
end

% Calculate
minTemp = min(tempData);
maxTemp = max(tempData);
avgTemp = mean(tempData);

% c)
% Figure
plot(time, tempData);
xlabel('Time (s)');
ylabel('Temperature (℃)');
title('Cabin Temperature Monitoring');
grid on;

% d)
% Get the current time and output data
currentTime = datestr(now, 'mm/dd/yyyy');
fprintf('Data logging initiated - %s\n', currentTime);
fprintf('Location - Nottingham\n\n');
fprintf('Minute\tTemperature (℃)\n\n');
 
% Output temperature data for minute to the screen
for minute = 0:10
    idx = minute * 60 +1;
    fprintf('Minute %d\t\t%.2f\n', minute, tempData(idx));
end
fprintf('\n');

% e)
% Open the log file and write the data
fileID = fopen('cabin_temperature.txt', 'w'); % Open file in write mode
fprintf(fileID, 'Data logging initiated - %s\n', currentTime); % Log the start time
fprintf(fileID, 'Location  - Nottingham\n\n'); % Log the location
fprintf(fileID, 'Minute\tTemperature (℃)\n\n'); % Log the minute count
for minute = 0:10
    idx = minute * 60 + 1;
    fprintf(fileID, 'Minute %d\t\t%.2f\n', minute, tempData(idx)); % Log the temperature
end

% Write the statistical data to the file
fprintf(fileID, 'Max temp\t%.2f C\n', maxTemp); % Log maximum temperature
fprintf(fileID, 'Min temp\t%.2f C\n', minTemp); % Log minimum temperature
fprintf(fileID, 'Average temp\t%.2f C\n', avgTemp); % Log average temperature
fprintf(fileID, 'Data logging terminated\n');

% Close the log file
fclose(fileID);

%% TASK 2 - LED TEMPERATURE MONITORING DEVICE IMPLEMENTATION [25 MARKS]

% c)
a = arduino('COM3', 'Uno');
duration = 600;
temp_monitor(a, duration, [18, 24]);

% g)
help temp_monitor

%% TASK 3 - ALGORITHMS – TEMPERATURE PREDICTION [25 MARKS]

a = arduino('COM3', 'Uno');
temp_prediction(a, '25-Apr-2025', 'Nottingham');

% g)
help temp_prediction

%% TASK 4 - REFLECTIVE STATEMENT [5 MARKS]
% This project developed a real-time cabin temperature monitoring system 
% using MATLAB and Arduino, achieving key goals such as data logging, LED alerts, and temperature prediction.
% Three main **challenges** were encountered:
% 1) *Hardware-Software Synchronization* – 
% The MCP9700A sensor's noise required Gaussian-weighted filtering to stabilize 
% temperature data, and LED blinking needed non-blocking timing control to ensure 
% real-time responsiveness; 
% 2) *Algorithmic Issues* – The temperature prediction model was too simple and 
% sensitive to noise, so we had to set limits on the rate of temperature change (±10°C/min)
% and validate the temperature output range (-50°C to 150°C); 
% 3) *Version Control Issues* – Initial inexperience with Git led to incomplete commits,
% which were later resolved by improving the commit process and organizing the repository 
% structure.
% The system’s strengths lie in its modular design: functions like temp_monitor.m and 
% temp_prediction.m were separated for independent testing. Additionally, dynamic data 
% visualization and formatted logging met the project documentation standards. 
% The system’s constraint-driven design helped avoid unrealistic temperature predictions, 
% demonstrating strong engineering practice.
% The main **limitations** include: 
% 1) *Model Simplification* – The assumption of a constant rate of temperature
% change overlooked the cabin's thermal inertia; 
% 2) *Hardware Dependency* – The system's reliance on Arduino I/O limits its scalability 
% for further simulations and testing;
% 3) *Computational Latency* – MATLAB’s interpreted code introduced delays of 
% 200-500 milliseconds, which is not ideal for real-time applications.
% Future improvements** would focus on: 
% 1) Improved Prediction Model – Replacing the simple model with more advanced machine
% ning methods to improve temperature prediction accuracy; 
% 2) Performance Optimization – Moving core algorithms to Arduino or other hardware
% platforms to reduce computation delays; 
% 3) Better Testing Efficiency – Adopting more suitable unit testing frameworks to ensure system reliability.
% This project highlighted the importance of error handling and algorithm optimization in 
% embedded systems and laid the foundation for transitioning academic prototypes into practical applications.






