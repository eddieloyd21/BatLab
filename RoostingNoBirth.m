%% Function for Roosting without Birth Phase
function [popChange] = RoostingNoBirth(t, pops, params)
    
    S = pops(1);
    E = pops(2);
    P = pops(3);
    
    popChange = zeros(params.numClasses, 1);
    popChange(1) = params.a * E - params.mu*S;
    popChange(2) = -params.a*E - params.mu * E;
    popChange(3) = params.eta*P*(1-P/params.kPD) - params.pdMortality*P;
    
end
