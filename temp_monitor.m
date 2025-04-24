function temp_monitor(arduinoObj, duration, tempRange)
% TEMP_MONITOR Real-time temperature monitoring and LED control system.
% Monitors temperature via Arduino, controls LEDs based on predefined ranges,
% and plots live temperature data. Supports error handling and resource cleanup.
%
% Inputs:
% arduinoObj : Initialized Arduino object (from arduino()).
% duration : Total monitoring duration in seconds.
% tempRange : Comfort range [min, max] in °C.
%
% LED Behavior:
% - Green (D9): Steady if temp in range.
% - Yellow (D10): Blinks at 0.5s interval if temp < min.
% - Red (D11): Blinks at 0.25s interval if temp > max.
%
% Example:
% a = arduino('COM3', 'Uno');
% temp_monitor(a, 600, [18, 24]);
%
% Initialize variables
startTime = tic; % Timer
timeData = []; % Time storage
tempData = []; % Temperature storage

% Pin configuration
greenPin = 'D9';
yellowPin = 'D10';
redPin = 'D11';

% Plot setup
figure;
hPlot = plot(NaN, NaN, 'bo-');
xlabel('Time (s)');
ylabel('Temperature (°C)');
title('Live Temperature Monitoring');
grid on;

try
     % Main monitoring loop
     while toc(startTime) < duration
         % Read temperature from analog pin A0
         voltage = readVoltage(arduinoObj, 'A0');
         tempC = (voltage - 0.5) * 100; % MCP9700A formula

         % Update data buffers
         currentTime = toc(startTime);
         timeData(end+1) = currentTime;
         tempData(end+1) = tempC;

         % Update plot
         set(hPlot, 'XData', timeData, 'YData', tempData);
         xlim([0, duration]);
         ylim([min(tempData)-2, max(tempData)+2]);
         drawnow;

         % LED control logic
         if tempC >= tempRange(1) && tempC <= tempRange(2)
             writeDigitalPin(arduinoObj, 'D9', 1);
             writeDigitalPin(arduinoObj, 'D10', 0);
             writeDigitalPin(arduinoObj, 'D11', 0);
        elseif tempC < tempRange(1)
             writeDigitalPin(arduinoObj, 'D10', 1);
             pause(0.25);
             writeDigitalPin(arduinoObj, 'D10', 0);
             pause(0.25);
        else
             writeDigitalPin(arduinoObj, 'D11', 1);
             pause(0.125);
             writeDigitalPin(arduinoObj, 'D11', 0);
             pause(0.125);
        end
     end

catch ME
    % Error handling: Turn off all LEDs
    writeDigitalPin(arduinoObj, 'D9', 0);
    writeDigitalPin(arduinoObj, 'D10', 0);
    writeDigitalPin(arduinoObj, 'D11', 0);
    error('Monitoring halted: %s', ME.message);
end

% Cleanup after monitoring
writeDigitalPin(arduinoObj, 'D9', 0);
writeDigitalPin(arduinoObj, 'D10', 0);
writeDigitalPin(arduinoObj, 'D11', 0);
end