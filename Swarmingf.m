%% Function for Swarming Phase
function [popChange] = Swarmingf(t, pops, params)
    S = pops(1);
    E = pops(2);
    P = pops(3);
    
    popChange = zeros(params.numClasses, 1);
    popChange(1) = -params.phi * P* S - params.mu * S;
    popChange(2) = params.phi * P* S - params.mu * E;
    popChange(3) = params.eta*P*(1-P/params.kPD) - params.pdMortality*P;

end
