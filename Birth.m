%% Function for Roosting with Birth Phase
function [popChange] = Birth(t, pops, params)
    
    S = pops(1);
    E = pops(2);
    P = pops(3);
    N = S + E; 

    popChange = zeros(params.numClasses, 1);
    popChange(1) = params.gamma*N *(1-N/params.Kml) + params.a * E - params.mu*S;
    popChange(2) = -params.a*E - params.mu * E;
    popChange(3) = params.eta*P*(1-P/params.kPD) - params.pdMortality*P;
    
end
