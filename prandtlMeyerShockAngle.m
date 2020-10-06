function [mach, PrandtlMeyer, machAngle] = prandtlMeyerShockAngle(mach_In, PrandtlMeyer_In, machAngle_In)
% PRANDTLMEYERSHOCKANGLE  Calculates the values from the Prandtl-Meyer and
% Shock angle table. These values are: mach number, Prandtl-Meyer function,
% and mach angle.
%
% [MACH, PRANDTLMEYER, MACHANGLE] = PRANDTLMEYERSHOCKANGLE(MACH_IN, 0, 0)
% calculates the other values from the Prandtl-Meyer and Shock angle table
% based on the mach number.
% 
% You can input any one value as long as the other values inputted are
% zero.


    % script to parse input
    myArgs = [mach_In, PrandtlMeyer_In, machAngle_In];
    
    argGood = 0;
    if sum(myArgs == 0) == 2
        argGood = 1;
    end
    
    % if arguments are good run script
    if argGood
        % assumptions when dealing with air
        gamma = 1.4;
        
        % find the mach number from inputs
        i = find(myArgs ~= 0);
        switch i
            case 1
                % if mach was inputted
                
                mach = mach_In;
                
                % Find Mach Angle
                machAngle = asind(1/mach);
                
                % Find Pradtl-Mayer Function
                PrandtlMeyer = (((gamma + 1)/(gamma - 1))^(1/2))...
                    *(atand((((gamma - 1)/(gamma + 1))*((mach^2) - 1))^(1/2)))...
                    - atand(((mach^2) - 1)^(1/2));
                
            case 2
                % if Prandtl-Meyer function was inputted
                
                PrandtlMeyer = PrandtlMeyer_In;
                
                % Find Mach
                syms mach;
                eq = PrandtlMeyer_In == (180*atan((((mach^2 - 1)*(gamma - 1))/(gamma + 1))^(1/2))*((gamma + 1)/(gamma - 1))^(1/2))/pi - (180*atan((mach^2 - 1)^(1/2)))/pi;
                mach = double(vpasolve(eq, mach));
                
                % Find Mach Angle
                machAngle = asind(1/mach);
                
            case 3
                % if Mach Angle was inputted
                
                machAngle = machAngle_In;
                
                % Find Mach
                mach = 1/sind(machAngle_In);
                
                % Find Pradtl-Mayer Function
                PrandtlMeyer = (((gamma + 1)/(gamma - 1))^(1/2))...
                    *(atand((((gamma - 1)/(gamma + 1))*((mach^2) - 1))^(1/2)))...
                    - atand(((mach^2) - 1)^(1/2));
                
        end
        
    else
        fprintf("Incorrect inputs!!!\n")
    end
end
