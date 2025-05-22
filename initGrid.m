%% Function to initialize grid for 
function [grid_end] = initGrid(maxPop, S0, E0, I0, V0, P0)
    
    % Setting up initial empty array
    grid = zeros(1, maxPop);
    
    % Total current pop
    total = S0 + E0 + I0 + V0;
    
    % Randomize locations of initial populations
    % First values are susceptible, then exposed, then infectious, then
    % vaccinated
    locations = randperm(maxPop, total);
    
    %Initialize susceptible
    for x=locations(1:S0)
        grid(x) = 1;
    end
    
    %Initialize exposed
    for x=locations(S0+1:S0+E0)
        grid(x) = 5;
    end
    
    %Initialize infectious
    for x=locations(S0+E0+1:S0+E0+I0)
        grid(x) = 10;
    end
    
    %Initialize Vaccinated
    for x=locations(S0+E0+I0+1:S0+E0+I0+V0)
        grid(x) = 25;
    end
    
    grid_end = reshape(grid,[], 50); %the grid will be m x 50 (arbitrary choice)

end


