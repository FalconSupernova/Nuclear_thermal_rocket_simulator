
function [Msub, Msup] = area_mach_relation_test(ARatio, specific_heat_ratio)


% INPUTS

% Define some paramters
g   = specific_heat_ratio;
gm1 = g-1;
gp1 = g+1;


% Define anonymous function with two inputs (M and ARatio)
% - Will be used in the methods below
% - Pass M and ARatio as arguments to AM_EQN to get function value
% - funVal = AM_EQN(M,ARatio)
AM_EQN = @(M,ARatio) sqrt((1/M^2)*(((2+gm1*M^2)/gp1)^...
                            (gp1/gm1)))-ARatio;

% Solve for Msub and Msup using this area ratio (A/A*)

% Error tolerance
errTol = 1e-4;

% Flags for printing iterations to screen
%verboseBisection   = 0;
verboseIncremental = 0;


% SUBSONIC INCREMENTAL SEARCH

% Initial values
dM       = 0.1;                                                             % Initial M step size
M        = 1e-6;                                                            % Initial M value
iConvSub = 0;                                                               % Initial converge index

if (verboseIncremental == 1)
    fprintf('Incremental Search Method: Subsonic\n');
    fprintf('-----------------------------------\n');
end

% Iterate to solve for root
iterMax = 100;                                                              % Maximum iterations
stepMax = 100;                                                              % Maximum step iterations
for i = 1:1:iterMax
    for j = 1:1:stepMax
        
        % Evaluate function at j and j+1
        fj   = AM_EQN(M,ARatio);
        fjp1 = AM_EQN(M+dM,ARatio);
        
        % Print iterations to command window
        if (verboseIncremental == 1)
            fprintf('fj | fjp1: %3.4f\t%3.4f\n',fj,fjp1);
        end
        
        % Update M depending on sign change or not
        % - If no sign change, then we are not bounding root yet
        % - If sign change, then we are bounding the root, update dM
        if (fj*fjp1 > 0)
            M = M + dM;                                                     % Update M
        elseif (fj*fjp1 < 0)
            dM = dM*0.1;                                                    % Refine the M increment
            break;                                                          % Break out of j loop
        end
        
    end % END: j Loop
    
    % Check for convergence
    if (abs(fj-fjp1) <= errTol)                                             % If converged
        iConvSub = i;                                                       % Set converged index
        break;                                                              % Exit loop
    end
    
end % END: i Loop

% Set subsonic Mach number to final M from iterations
Msub = M;

% SUPERSONIC INCREMENTAL SEARCH

% Initial values
dM       = 1;                                                               % Initial M step size
M        = 1+1e-6;                                                          % Initial M value
iConvSup = 0;                                                               % Initial converge index

if (verboseIncremental == 1)
    fprintf('\nIncremental Search Method: Supersonic\n');
    fprintf('-------------------------------------\n');
end

% Iterate to solve for root
iterMax = 100;                                                              % Maximum iterations
stepMax = 100;                                                              % Maximum step iterations
for i = 1:1:iterMax
    for j = 1:1:stepMax
        
        % Evaluate function at j and j+1
        fj   = AM_EQN(M,ARatio);
        fjp1 = AM_EQN(M+dM,ARatio);
        
        % Print iterations to command window
        if (verboseIncremental == 1)
            fprintf('fj | fjp1: %3.4f\t%3.4f\n',fj,fjp1);
        end
        
        % Update M depending on sign change or not
        % - If no sign change, then we are not bounding root yet
        % - If sign change, then we are bounding the root, update dM
        if (fj*fjp1 > 0)
            M = M + dM;                                                     % Update M
        elseif (fj*fjp1 < 0)
            dM = dM*0.1;                                                    % Refine the M increment
            break;                                                          % Break out of j loop
        end
        
    end % END: j Loop
    
    % Check for convergence
    if (abs(fj-fjp1) <= errTol)                                             % If converged
        iConvSup = i;                                                       % Set converged index
        break;                                                              % Exit loop
    end
    
end % END: i Loop

% Set supersonic Mach number to final M from iterations
Msup = M;


% Print solutions to command window
fprintf('==== INCREMENTAL SEARCH SOLVER ====\n');
fprintf('Msub: %3.4f after %i iterations\n',Msub,iConvSub);
fprintf('Msup: %3.4f after %i iterations\n',Msup,iConvSup);
fprintf('===================================\n\n');