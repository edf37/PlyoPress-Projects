%% Return %%
repet = 'y';
while repet == 'y'
    
%% Open
fprintf('\n      Plyo Press     %s\n',datestr(now))
fprintf('\n             by Evan D. Feigel \n')
fprintf('\n                                  March./2024 \n')

%% Loading Data
[file, path] = uigetfile('*.*', 'Load and open the file');
disp('********************************** ');
disp('The Following File Will Be Loaded ');
disp('Path: ');
disp(path);
disp('File Name: ');
disp(file);
disp('********************************** ');
archive = [path, file];
q = findstr(file, '.');
if isempty(q)
    NEWFILE = file;
else
    b = abs(file);
    NEWFILE = b(1:(q-1));
    NEWFILE = setstr(NEWFILE);
end    
if isstr(file)
    data = dlmread(archive, ',', 1, 0);
    disp('Size of a loaded file is'); 
    disp(size(data));
    [line, colunm] = size(data);
    disp('********************************** ');
else
    disp('Something Wrong with Selected File Name');
    disp('Selected File is NOT LOADED');
end

%% Define variables
Time = data(:,1);
RawFx = data(:,2);
RawFy = data(:,3);
RawFz = data(:,4);
RawMx = data(:,5);
RawMy = data(:,6);
RawMz = data(:,7);
Power = data(:,8);
Velocity = data(:,9);
COPx = data(:,10);
COPy = data(:,11);

%% Figure Fz Raw
figure('Position', [248 124 1024 560]);
plot(RawFz, 'r')
legend('RawFz', 'Location', 'NorthEastOutside')
 
%% Define variables cut
[i, j] = ginput(2);
datacut = data(i(1):i(2), :);
close all
Time = datacut(:,1);
RawFx = datacut(:,2);
RawFy = datacut(:,3);
RawFz = datacut(:,4);
RawMx = datacut(:,5);
RawMy = datacut(:,6);
RawMz = datacut(:,7);
Power = datacut(:,8);
Velocity = datacut(:,9);
COPx = datacut(:,10);
COPy = datacut(:,11);
 
%% Butterworth
N = 4;
F = 10;
Fs = 200;
Wn = F / (Fs / 2);
[B, A] = butter(N, Wn);
RawFzButter = filter(B, A, RawFz);

%% Graphics
figure('Position', [248 124 1024 560]);
plot(Time, RawFz, 'b')
legend('RawFz Cut', 'Location', 'NorthEastOutside')

figure('Position', [248 124 1024 560]);
plot(Time, RawFzButter)
legend('RawFz Butter', 'Location', 'NorthEastOutside')

%% Finding Peak
[xpeak, ypeak] = ginput(20);

%% Table parameters
TpeakLanding = [ypeak(1), ypeak(3), ypeak(5), ypeak(7), ypeak(9), ypeak(11), ypeak(13), ypeak(15), ypeak(17), ypeak(19)];
TpeakPropulsive = [ypeak(2), ypeak(4), ypeak(6), ypeak(8), ypeak(10), ypeak(12), ypeak(14), ypeak(16), ypeak(18), ypeak(20)];
TpeakLandingAVG = mean(TpeakLanding);
TpeakPropulsiveAVG = mean(TpeakPropulsive);

% Create table
Variable = {'Peak1', 'Peak2', 'Peak3', 'Peak4', 'Peak5', 'Peak6', 'Peak7', 'Peak8', 'Peak9', 'Peak10', 'Mean'};
Landing = [ypeak(1), ypeak(3), ypeak(5), ypeak(7), ypeak(9), ypeak(11), ypeak(13), ypeak(15), ypeak(17), ypeak(19), TpeakLandingAVG];
Propulsive = [ypeak(2), ypeak(4), ypeak(6), ypeak(8), ypeak(10), ypeak(12), ypeak(14), ypeak(16), ypeak(18), ypeak(20), TpeakPropulsiveAVG];

% Convert lbf to N
Landing = Landing * 4.44822;
Propulsive = Propulsive * 4.44822;

T1 = table(Variable', Landing', Propulsive', 'VariableNames', {'Variable', 'peakLanding', 'peakPropulsive'});
% Display table
disp(T1);

%% Figure Velocity Raw
figure('Position', [248 124 1024 560]);
plot(-Velocity, 'r')
legend('Velocity', 'Location', 'NorthEastOutside')
 
%% Define variables cut
[i, j] = ginput(2);
datacut = data(i(1):i(2), :);
close all
Time = datacut(:,1);
RawFx = datacut(:,2);
RawFy = datacut(:,3);
RawFz = datacut(:,4);
RawMx = datacut(:,5);
RawMy = datacut(:,6);
RawMz = datacut(:,7);
Power = datacut(:,8);
Velocity = datacut(:,9);
COPx = datacut(:,10);
COPy = datacut(:,11);
 
%% Butterworth
N = 4;
F = 10;
Fs = 200;
Wn = F / (Fs / 2);
[B, A] = butter(N, Wn);
VelocityButter = filter(B, A, Velocity);

%% Graphics
figure('Position', [248 124 1024 560]);
plot(Time, -Velocity, 'b')
legend('Velocity Cut', 'Location', 'NorthEastOutside')

figure('Position', [248 124 1024 560]);
plot(Time, -VelocityButter)
legend('Velocity Butter', 'Location', 'NorthEastOutside')

%% Finding Peak
[xpeak, ypeak] = ginput(10);

%% Table parameters
TpeakVelocity = [ypeak(1), ypeak(2), ypeak(3), ypeak(4), ypeak(5), ypeak(6), ypeak(7), ypeak(8), ypeak(9), ypeak(10)];
TpeakVelocityAVG = mean(TpeakVelocity);

% Create table
Variable = {'Peak1', 'Peak2', 'Peak3', 'Peak4', 'Peak5', 'Peak6', 'Peak7', 'Peak8', 'Peak9', 'Peak10', 'Mean'};
Velocity = [ypeak(1), ypeak(2), ypeak(3), ypeak(4), ypeak(5), ypeak(6), ypeak(7), ypeak(8), ypeak(9), ypeak(10), TpeakVelocityAVG];

% Convert ft/s to m/s
Velocity = Velocity * 0.3048;

T2 = table(Variable', Velocity', 'VariableNames', {'Variable', 'peakVelocity'});
% Display table
disp(T2);

%% Figure Power Raw
figure('Position', [248 124 1024 560]);
plot(-Power, 'r')
legend('Power', 'Location', 'NorthEastOutside')
 
%% Define variables cut
[i, j] = ginput(2);
datacut = data(i(1):i(2), :);
close all
Time = datacut(:,1);
RawFx = datacut(:,2);
RawFy = datacut(:,3);
RawFz = datacut(:,4);
RawMx = datacut(:,5);
RawMy = datacut(:,6);
RawMz = datacut(:,7);
Power = datacut(:,8);
Velocity = datacut(:,9);
COPx = datacut(:,10);
COPy = datacut(:,11);
 
%% Butterworth
N = 4;
F = 10;
Fs = 200;
Wn = F / (Fs / 2);
[B, A] = butter(N, Wn);
PowerButter = filter(B, A, Power);

%% Graphics
figure('Position', [248 124 1024 560]);
plot(Time, -Power, 'b')
legend('Power Cut', 'Location', 'NorthEastOutside')

figure('Position', [248 124 1024 560]);
plot(Time, -PowerButter)
legend('Power Butter', 'Location', 'NorthEastOutside')

%% Finding Peak
[xpeak, ypeak] = ginput(10);

%% Table parameters
TpeakPower = [ypeak(1), ypeak(2), ypeak(3), ypeak(4), ypeak(5), ypeak(6), ypeak(7), ypeak(8), ypeak(9), ypeak(10)];
TpeakPowerAVG = mean(TpeakPower);

% Create table
Variable = {'Peak1', 'Peak2', 'Peak3', 'Peak4', 'Peak5', 'Peak6', 'Peak7', 'Peak8', 'Peak9', 'Peak10', 'Mean'};
Power = [ypeak(1), ypeak(2), ypeak(3), ypeak(4), ypeak(5), ypeak(6), ypeak(7), ypeak(8), ypeak(9), ypeak(10), TpeakPowerAVG];

T3 = table(Variable', Power', 'VariableNames', {'Variable', 'peakPower'});
% Display table
disp(T3);

%% Merge tables
merged_table = outerjoin(outerjoin(T1, T2, 'Keys', 'Variable', 'MergeKeys', true), T3, 'Keys', 'Variable', 'MergeKeys', true);

% Save table to CSV
csvFileName = [NEWFILE, '_results.csv'];
writetable(merged_table, csvFileName);
disp(['Table saved to ', csvFileName]);

%% Looping function
repet = input('Do you want to analyze another subject? (y/n)', 's');
end

