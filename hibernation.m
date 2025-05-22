%% Function for Network Simulation of Hiibernation Phase
function [grid, S_pop, E_pop, I_pop, V_pop, P] = hibernation(maxPop, S0, E0, I0, V0, P0, start, end_time, params)

    % Waking up probabilities
    prob_non_infect_wake = 12/212; % Based on bats waking up every 2 to 3 weeks in hibernation
    prob_infect_wake = 2*prob_non_infect_wake; % Based on https://pmc.ncbi.nlm.nih.gov/articles/PMC10846716/

    % Known parameters
    prob_death = params.delta;
    prob_exp_to_inf = params.tau;
    prob_natural_death = params.mu;

    % Intialize grid
    grid = initGrid(maxPop, S0, E0, I0, V0, P0);
    
    % Pre-allocate arrays to keep track of populations
    S_Pop = zeros(1,(end_time-start));
    E_Pop = zeros(1,(end_time-start));
    I_Pop = zeros(1,(end_time-start));
    V_Pop = zeros(1,(end_time-start));


    % Initialize for Pd equation
    S = S0;
    E = E0;
    P = P0;
    I = I0;
    V = V0;


    %Find prior to loop
    shape = size(grid);
    rows = shape(1);
    columns = shape(2);

    % For each day of simulation, run simulation
    for a = start:end_time

        % Calculate bat transmission and environment transmission probs
        deltaT = (a-start) +1;
        prob_transmit = (1-exp(-params.beta*deltaT))*I;
        prob_environment = (1-exp(-params.phi*P*deltaT))*S;

        % Initialize changes in populations each time step
        new_infections = 0;
        new_exp_from_inf = 0;
        new_death = 0;
        nat_s_death = 0;
        nat_e_death = 0;
        nat_i_death = 0;
        nat_v_death = 0;

        % Looking over every space in grid
        for i=1:rows
            for j=1:columns

                % Probability for exposed bat to become infectious
                infect = binornd(1, prob_exp_to_inf);
                if(infect == 1 && grid(i,j) ==5)
                    new_exp_from_inf = new_exp_from_inf + 1;
                    grid(i,j) = 10;
                end


                % Infection while bat is asleep and grid has pd
                pdInf = binornd(1, prob_environment);
                if (pdInf == 1 && grid(i,j) == 1)
                    new_infections = new_infections +1;
                    grid(i,j) = 5;
                end


                % We want to use different wake up probabilities
                % based on whether or not bat is infected
                if (grid(i,j) == 10)
                    prob_wake = prob_infect_wake;
                elseif (grid(i,j) == 1 || grid(i,j) == 5) 
                    % Bat case
                    prob_wake = prob_non_infect_wake;
                else
                    % Nothing in grid or vaccinated (no point of waking
                    % up -saves computational time) 
                    prob_wake = 0;
                end

                % Probability for infected bat to wake up
                wake = binornd(1, prob_wake);
                % If awake and not vaccinated
                if(wake == 1 && grid(i,j) ~= 25)

                    % Indices for checks within distance (five by five grid)
                    if(i == rows || i+1 == rows || i+2 == rows)
                        startn = rows-4;
                        finishn = rows;
                    elseif(i == 1 || i ==2)
                        startn = 1;
                        finishn = 5;
                    else
                        startn = i-2;
                        finishn = i+2;
                    end
            
                    if(j == columns || j+1 == columns || j+2 == columns)
                        startm = columns-4;
                        finishm = columns;
                    elseif(j == 1 || j ==2)
                        startm = 1;
                        finishm = 5;
                    else
                        startm = j-2;
                        finishm = j+2;
                    end
            

                    %Now using bounds, use distance to check for transmission
                    for u = startn:finishn
                        for v = startm:finishm
                            euclid = sqrt((i-u)^2 + (j-v)^2);
                            prob_contact = 1/euclid;
                            prob_infect = prob_transmit*prob_contact;
                            infect = binornd(1, prob_infect);
                            if(infect == 1)
                                % Move infected bats into the exposed class
                                if(grid(i,j) == 1 && grid(u,v) == 10)
                                    new_infections = new_infections +1;
                                    grid(i,j) = 5;
                                elseif(grid(i,j) == 10 && grid(u,v) == 1)
                                    new_infections = new_infections +1;
                                    grid(u,v) = 5;
                                end
                            
                            end


                            % Environmental infections
                            if (grid(i,j) == 1)
                                prob_envir_infect = prob_environment*prob_contact;
                                environment = binornd(1, prob_envir_infect);
                                if(environment == 1)
                                    % Move infected bats into the exposed class
                                    new_infections = new_infections +1;
                                    grid(i,j) = 5;
                                end 
                            end

                        end
                    end 
                    
                end
                % Fungal death (infected only)
                if grid(i,j) == 10
                   inf_death = binornd(1, prob_death);
                   if(inf_death) == 1
                      new_death = new_death + 1;
                      grid(i,j) = 0;
                   end
                end

                % Natural death
                nat_death = binornd(1, prob_natural_death);
                if nat_death == 1 && grid(i,j) == 1
                    nat_s_death = nat_s_death + 1;
                    grid(i,j) = 0;
                elseif nat_death == 1 && grid(i,j) == 5
                    nat_e_death = nat_e_death + 1;
                    grid(i,j) = 0;
                elseif nat_death == 1 && grid(i,j) == 10
                    nat_i_death = nat_i_death + 1;
                    grid(i,j) = 0;
                elseif nat_death == 1 && grid(i,j) == 25
                    nat_v_death = nat_v_death + 1;
                    grid(i,j) = 0;
                end
                

            end
        end


        % Update changes from the course of the simulation
        S = S - new_infections - nat_s_death;
        E = E + new_infections- new_exp_from_inf - nat_e_death;
        I = I + new_exp_from_inf - new_death - nat_i_death;
        P = P + (params.omega * I) - params.pdMortality*P; % Includes shedding here
        V = V - nat_v_death; 

        S_pop(a+1) = S;
        E_pop(a+1) = E;
        I_pop(a+1) = I;
        V_pop(a+1) = V;
    end

        


    