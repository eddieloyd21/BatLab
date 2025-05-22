%% Main file for running different controls through simulation
clear all;
%% Constant Parameters
params.mu = 1 / (8.5 * 365);
params.a = 0.75 / 92;
params.Kml = 4500; 
params.gamma = (0.5 * 0.95) / 21;
params.s = 600;
params.omega = 50;
params.years = 2;


%% Changing Control Parameter
diff_vaccRates = [0.0 0.1 0.25 0.75];
diff_uvRates = [0.0 0.1 0.25 0.75];
diff_microclimateRates = [0.0 0.1 0.25 0.75];
diff_fungRates = [0.0 0.1 0.25 0.75];
diff_soilbacteriaRates = [0.0 0.1 0.25 0.75];


% Index into amount of control for each parameter that you would like to use
vaccControl = diff_vaccRates(1);
uvControl = diff_uvRates(1);
microclimControl = diff_microclimateRates(1);
fungicideControl = diff_fungRates(1);
soilControl = diff_soilbacteriaRates(1);

%% Phi and Beta 
% Index 1 is Primarily environment to bat-transmission
% Index 2 is Equivalent contributions
% Index 3 is Primarily Bat to Bat Transmissions
diff_PhiRates = [6.24*10^-13 3.44*10^-13 6.80*10^-14];
diff_BetaRates = [6.79*10^-7 3.89*10^-6 9.00*10^-6];

% 1 = phi dom, 2 = equal, 3 = beta dom
params.phi = diff_PhiRates(3);
params.beta = diff_BetaRates(3);

%% Control Parameters
params.vaccRate = vaccControl; % Vaccination control
params.pdMortality = uvControl; % UV Light control
params.kPD = 10^10 *(1-fungicideControl); % Fungicide control
params.delta = (1 / 60)*(1-microclimControl)*(1-uvControl);% Microclimate, UV control
params.eta = 0.5 * (1 - soilControl); % Soil Bacteria control
params.tau = (1 / 83) * (1-soilControl)*(1-uvControl); % Soil bacteria, Uv light control

%% Initial Parameters
N0 = 1500;
V0 = floor(params.vaccRate*1499); % initial density of vaccinated class
E0 = 1; % initial density of exposed class
I0 = 0; % initial density of infectious class; THIS HAS TO BE ZERO!!!
S0 = N0 - E0 - V0; % initial density of susceptible class
P0 = 10; % initial density of environmental Pd reservoir

%% Run sim

% Initialize plot
tiledlayout(1, 1)

grid = sim(params, S0, E0, I0, V0, P0);

% Different grid colors based on what bats are in the grid
if (ismember(25, grid))
    % 0: white, 1: light blue, 5: medium blue, 10: dark blue, 25: orange
    value_map = [0, 1, 5, 10, 25];  % Your data values
    color_map = [1 1 1;           % white for 0
                0.7 0.85 1;      % light blue for 1
                0.3 0.6 0.9;     % medium blue for 5
                0 0 0.5;         % dark blue for 10
                1 0.64 0];          % orange for 25
elseif (ismember(10, grid))
    % 0: white, 1: light blue, 5: medium blue, 10: dark blue
    value_map = [0, 1, 5, 10];  % Your data values
    color_map = [1 1 1;           % white for 0
                0.7 0.85 1;      % light blue for 1
                0.3 0.6 0.9;     % medium blue for 5
                0 0 0.5];         % dark blue for 10
elseif (ismember(5, grid))
    % 0: white, 1: light blue, 5: medium blue
    value_map = [0, 1, 5];  % Your data values
    color_map = [1 1 1;           % white for 0
                0.7 0.85 1;      % light blue for 1
                0.3 0.6 0.9];    % medium blue for 5
else
    % 0: white, 1: light blue
    value_map = [0, 1];  % Your data values
    color_map = [1 1 1;           % white for 0
                0.7 0.85 1];      % light blue for 1

end



% Create an indexed grid where each unique value is mapped to an index
[~, ~, indexed_grid] = unique(grid);
indexed_grid = reshape(indexed_grid, size(grid));

% Map the values in 'value_map' to their indices in color_map
% This ensures that the colormap aligns with the values
[~, locs] = ismember(grid, value_map);
imagesc(locs);

% Set the colormap and remove axes
colormap(color_map);
colorbar('Ticks', 1:length(value_map), 'TickLabels', string(value_map));
% title('Our Model: S, E, I over time');
axis off;



