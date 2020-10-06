function [mach1, presRatio, densRatio, tempRatio, presStagRatio, PitotRatio, mach2] = normalShock(mach1_In, presRatio_In, densRatio_In, tempRatio_In, presStagRatio_In, PitotRatio_In, mach2_In)
% NORMALSHOCK  Calculates the values from a normal shock table: mach number 
% before, P2/P1, rho2/rho1, T2/T1, Po2/Po1, Po2/P1, mach value after the
% shock.
% 
% [MACH1, PRESRATIO, DENSRATIO, TEMPRATIO, PRESSTAGRATIO, PITOTRATIO,
% MACH2] = NORMALSHOCK(MACH1_IN, 0, 0, 0, 0, 0, 0) calculates the other
% values from a normal shock table based on the mach number before the
% shock.
% 
% You can input any one value as long as the other values inputted are
% zero.

    % parse inputs
    myArgs = [mach1_In, presRatio_In, densRatio_In, tempRatio_In, presStagRatio_In, PitotRatio_In, mach2_In];
    
    argGood = 0;
    if sum(myArgs == 0) == 6
        argGood = 1;
    end
    
    % if arguments are good run script
    if argGood
        % assumptions when dealing with air
        gamma = 1.4;
        R = 287;
        cV = R/(gamma - 1);
        cP = cV*gamma;
        
        % find the mach number from inputs
        i = find(myArgs ~= 0);
        switch i
            case 1
                % if mach was inputted
                mach1 = mach1_In;
            case 2
                % if pressure ratio was inputted
                mach1 = (2^(1/2)*(gamma*(gamma + presRatio_In + gamma*presRatio_In - 1))^(1/2))/(2*gamma);
            case 3
                % if density ratio was inputted
                mach1 = 2^(1/2)*(densRatio_In/(densRatio_In + gamma - densRatio_In*gamma + 1))^(1/2);
            case 4
                % if temperature ratio was inputted
                mach1 = 2*(-(gamma - 1)/(tempRatio_In - 6*gamma - gamma*(gamma^2*tempRatio_In^2 + 2*gamma^2*tempRatio_In + gamma^2 + 2*gamma*tempRatio_In^2 - 12*gamma*tempRatio_In + 2*gamma + tempRatio_In^2 + 2*tempRatio_In + 1)^(1/2) + 2*gamma*tempRatio_In - (gamma^2*tempRatio_In^2 + 2*gamma^2*tempRatio_In + gamma^2 + 2*gamma*tempRatio_In^2 - 12*gamma*tempRatio_In + 2*gamma + tempRatio_In^2 + 2*tempRatio_In + 1)^(1/2) + gamma^2*tempRatio_In + gamma^2 + 1))^(1/2);
            case 5
                % if pressure stagnation ratio was inputted
                syms mach1Sym;
                eq = presStagRatio_In == exp(-(cP*log(((1+(2*gamma)*((mach1Sym^2)-1)/(gamma+1))*(2+(gamma-1)*(mach1Sym^2))/((gamma+1)*(mach1Sym^2))))-R*log(1+(2*gamma)*((mach1Sym^2)-1)/(gamma+1)))/R);
                mach1 = double(vpasolve(eq, mach1Sym, [0, Inf]));
            case 6
                % if Pitot ratio was inputted
                syms mach1Sym;
                eq = PitotRatio_In == (((((gamma + 1)^2)*(mach1Sym^2))/(4*gamma*(mach1Sym^2) - 2*(gamma - 1)))^(gamma/(gamma - 1)))*((1 - gamma + 2*gamma*(mach1Sym^2))/(gamma + 1));
                mach1 = double(vpasolve(eq, mach1Sym, [0, Inf]));
            case 7
                % if mach 2 was inputted
                mach1 = ((gamma*mach2_In^2 - mach2_In^2 + 2)/(2*gamma*mach2_In^2 - gamma + 1))^(1/2); 
        end

        % Pressure Ratio: P2/P1
        presRatio = 1 + (2*gamma)*((mach1^2) - 1)/(gamma + 1);
        
        % Density Ratio: rho2/rho1
        densRatio = (gamma + 1)*(mach1^2)/(2 + (gamma - 1)*(mach1^2));

        % Temperature Ratio: T2/T1
        tempRatio = (1 + (2*gamma)*((mach1^2) - 1)/(gamma + 1))*(2 + (gamma - 1)*(mach1^2))/((gamma + 1)*(mach1^2));

        % Entropy Change
        sChange = cP*log(tempRatio) - R*log(presRatio);

        % Total Pressure Ratio: Po2/Po1
        presStagRatio = exp(-sChange/R);

        % Pitot Tube Ratio: Po2/P1
        PitotRatio = (((((gamma + 1)^2)*(mach1^2))/(4*gamma*(mach1^2) - 2*(gamma - 1)))^(gamma/(gamma - 1)))*((1 - gamma + 2*gamma*(mach1^2))/(gamma + 1));
        
        % Mach2: Mach number after normal shock
        mach2 = ((1 + (gamma - 1)*(mach1^2)/2)/(gamma*(mach1^2) - (gamma - 1)/2))^(1/2);
    else
        fprintf("Incorrect inputs!!!\n")
    end
    
end