%% Simulation of Full Bat Cycle for Specified Years
% Note: This simulation does not keep track of class populations throughout
% the sim, only the populations at the end of each phase. Keeping track of
% the populations throughout the sim was not pertinent to our research
% questions because we were interested in the interactions during
% hibernation.
function [grid] = sim(params, S0, E0, I0, V0, P0)

% initial definitions
S = S0;
E = E0;
P = P0;
I = I0;
V = V0;


% the value of epsilon does not depend on time, so I compute it here
epsilon = 1 / (params.s * params.delta + 1);

for i = 1:params.years
    
    % calculate how many days have already elapsed in past years
    yearDays = (i - 1) * 365;

    % Run Swarming model
    params.numClasses = 3;
    initsSwarm = [S E P];
    options = odeset('NonNegative',1:params.numClasses);
    [t, pop] = ode45(@Swarmingf, [yearDays, yearDays + 61], initsSwarm, options, params);

    % End vectors of different classes from swarming
    S = floor(pop(end, 1));
    E = floor(pop(end, 2));
    P = floor(pop(end, 3));

    % Run hibernation model
    [grid, S_pop, E_pop, I_pop, V_pop, P] = hibernation(params.Kml, S, E, I, V, P, yearDays + 61,yearDays + 273, params);


    % Roosting reclassification
    S = S_pop(end);
    E = E_pop(end) + epsilon*I;
    I = 0;
    P = P;
    V = V_pop(end);

    % Run roosting model
    params.numClasses = 3;
    initsRoost = [S E P];
    options = odeset('NonNegative',1:params.numClasses);
    [t, pop] = ode45(@RoostingNoBirth,[yearDays + 273,yearDays + 309],initsRoost,options, params);

    % End vectors of different classes from Roosting No Birth
    S = floor(pop(end, 1));
    E = floor(pop(end, 2));
    P = floor(pop(end, 3));


    % Run roosting model
    params.numClasses = 3;
    initsBirth = [S E P];
    options = odeset('NonNegative',1:params.numClasses);
    [t, pop] = ode45(@Birth,[yearDays + 309,yearDays + 330],initsBirth,options, params);

    % End vectors of different classes from Birth
    S = floor(pop(end, 1));
    E = floor(pop(end, 2));
    P = floor(pop(end, 3));
    

    % Compute Vaccination reclassification after Birth
    S = ceil(S*(1-params.vaccRate));
    E = E;
    I = I;
    P = P;
    V = floor(V + S*params.vaccRate);


    % Run roosting model
    params.numClasses = 3;
    initsRoost = [S E P];
    options = odeset('NonNegative',1:params.numClasses);
    [t, pop] = ode45(@RoostingNoBirth,[yearDays + 330,yearDays + 365],initsRoost,options, params);

    % End vectors of different classes from Roosting No Birth
    S = floor(pop(end, 1));
    E = floor(pop(end, 2));
    P = floor(pop(end, 3));
    

end

