function [theta_Out, beta_Out, mach_Out] = thetaBetaMach(theta_In, beta_In, mach_In)
% THETABETAMACH  calculates the theta, beta, or mach number based on the
% two other values inputted
%
% [THETA_OUT, BETA_OUT, MACH_OUT] = THETABETAMACH(THETA_IN, BETA_IN, 0)
% calculates the mach number from the theta and beta values.
% 
% You can input any two values as long as the other value inputted is zero.
    
    % script to parse input
    myArgs = [theta_In, beta_In, mach_In];
    
    argGood = 0;
    if sum(myArgs == 0) == 1
        argGood = 1;
    end
    
    % if arguments are good run script
    if argGood
        % assumptions when dealing with air
        gamma = 1.4;
        
        % eq describing relationship between theta beta and mach
        syms myTheta myBeta mach
        eq = tand(myTheta) == 2*(cotd(myBeta))*(((mach^2)*((sind(myBeta))^2) - 1)/((mach^2)*(gamma + cosd(2*myBeta)) + 2));
        
        % find the mach number from inputs
        i = find(myArgs == 0);
        switch i
            case 1
                % theta wasn't inputted
                eq = subs(eq, [myBeta, mach], [beta_In, mach_In]);
                theta_Out = double(vpasolve(eq, myTheta, [0, 46]));
                
                beta_Out = beta_In;
                mach_Out = mach_In;
                
            case 2
                % beta wasn't inputted
                eq = subs(eq, [myTheta, mach], [theta_In, mach_In]);
                beta_Out = double(vpasolve(eq, myBeta, [0, 90]));
                
                theta_Out = theta_In;
                mach_Out = mach_In;
                
            case 3
                % mach wasn't inputted
                eq = subs(eq, [myBeta, myTheta], [beta_In, theta_In]);
                mach_Out = double(vpasolve(eq, mach, [0, inf]));
                
                beta_Out = beta_In;
                theta_Out = theta_In;
                
        end
        
    else
        fprintf("Incorrect inputs!!!\n")
    end
end