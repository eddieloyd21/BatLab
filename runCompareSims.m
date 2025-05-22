%% Running simulation that compares our Hibernation model to Equation Model
clear all;
% Set initial pops S, E, I, V, P
S0 = 1499; % initial S pop
E0 = 1; % initial E pop
I0 = 0; % initial I pop
V0 = 0; % initial V pop
P0 = 10; % initial P pop

% define parameters
params.mu = 1/(8.5*365);
params.tau = 1/83;
params.delta = (1/60);
% Using max beta and phi values
params.beta = 1.84*10e-5; % beta can be 0 to 1.84*10e-5
params.phi = 6.92*10e-13; % phi 0 to 6.92*10e-13
params.kPD = 10^10;
params.eta = 0.5;
params.omega = 50;
params.pdMortality = 0;
% Run PAPER hibernation model
paperPopsMatrix = CompareSims(S0, E0, I0, V0, P0, params);
endPops = paperPopsMatrix(end, :); % Get pops at last time step

fprintf('Paper Model End Populations: \n');
fprintf('S: %.2f \n', endPops(1));
fprintf('E: %.2f \n', endPops(2));
fprintf('I: %.2f \n', endPops(3));
fprintf('V: %.2f \n', endPops(4));
fprintf('P: %.2f \n', endPops(5)); % Why is P so high?
fprintf('N: %.2f \n', endPops(1) + endPops(2) + endPops(3));

figure;

% Plot paper S,E,I over time on left subplot
subplot(1,2,1);
time = 1:size(paperPopsMatrix,1);
plot(time, paperPopsMatrix(:,1), '-b', 'DisplayName', 'S'); hold on;
plot(time, paperPopsMatrix(:,2), '-r', 'DisplayName', 'E');
plot(time, paperPopsMatrix(:,3), '-g', 'DisplayName', 'I');
hold off;

xlabel('Time');
ylabel('Population');
title('Paper Model: S, E, I over time');
legend('show');
grid on;
axis([0 215 0 1500]);


% Run OUR hibernation model
maxPop = 10000;
startTime = 0;
endTime = 212;

S_sum = 0;
E_sum = 0;
I_sum = 0;

subplot(1,2,2);

for i = 1:2
    [grid, S_vec, E_vec, I_vec, V_vec, P] = hibernation(maxPop, S0, E0, I0, V0, P0, startTime, endTime, params);
    time = 1:length(S_vec);

    S_sum = S_sum + S_vec(end);
    E_sum = E_sum + E_vec(end);
    I_sum = I_sum + I_vec(end);

    % Plot our S,E,I over time on right subplot
    plot(time, S_vec, '-b'); % , 'DisplayName', 'S'
    hold on;
    plot(time, E_vec, '-r');
    hold on;
    plot(time, I_vec, '-g');
    hold on;
end

xlabel('Time');
ylabel('Population');
title('Our Model: S, E, I over time');
legend('show');
grid on;
axis([0 215 0 1500]);


fprintf('Our Model Average End Populations: \n');
fprintf('S: %.2f \n', S_sum/10);
fprintf('E: %.2f \n', E_sum/10);
fprintf('I: %.2f \n', I_sum/10);
fprintf('V: %.2f \n', V_vec(end));
fprintf('P: %.2f \n', P);
fprintf('N: %.2f \n', S_sum/10 + E_sum/10 + I_sum/10);