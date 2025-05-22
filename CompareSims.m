%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Compare Simulations %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%

function popsOut = CompareSims(S0, E0, I0, V0, P0, params)
    % Outputs are S, E, I, V, P after running the diff eqs. Should also get
    % separate S, E, I, V, P output from calling hibernation function.
    % Inputs are S0, E0, I0, V0, P0, params

    initialPops = [S0; E0; I0; V0; P0]; % set initial populations
    time = [0, 212]; % number of days spent in hibernation

    % Run ode solver
    [~, populationTracker] = ode45(@(t, pops) paperHibernation(t, pops, params), time, initialPops);

    % set post-hibernation pops as outputs
    popsOut = populationTracker;
end

% Hibernation equations from Referenced Paper
function hibernationODE = paperHibernation(~, pops, params)
    hibernationODE = zeros(5, 1); % initialize an empty vector for the 5 pops

    % hibernation ODE equations for S, E, I, V, P
    hibernationODE(1) = - (params.beta * pops(3) + params.phi * pops(5) + params.mu) * pops(1);
    hibernationODE(2) = (params.beta * pops(3) + params.phi * pops(5)) * pops(1) - (params.tau + params.mu) * pops(2);
    hibernationODE(3) = params.tau * pops(2) - (params.delta + params.mu) * pops(3);
    hibernationODE(4) = - params.mu * pops(4);
    hibernationODE(5) = (params.omega * pops(3) + params.eta * pops(5)) * (1 - pops(5) / params.kPD);
end

