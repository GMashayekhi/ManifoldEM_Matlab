function [phi, theta, psi] = q2Spider(q, isTLS)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (c) UWM ManifolEM Team 
% Developed by Peter Schwander Jan. 31, 2014, Mar. 19, 2014
% Modified by Ghoncheh Mashayekhi 2017
% function [phi, theta, psi] = q2Spider(q)
% Converts a quaternion to corresponding rotation sequence in Spider 3D convention
% Dee to the 3D convention for all angles there is no need to negate psi
% q: 4x1
% Implementation by optimization
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

version = 'q2Spider, V1.1';

% assert unit quaternion
q = q/sqrt(sum(q.^2));

lb = [];
ub = [];

%options = optimset('Display','iter','TolFun',1e-16);
options = optimset('TolFun',1e-16,'display','off');

exitflag = NaN;
resnorm = Inf;

a0 = zeros(1,3); % try zero first

nTry = 0;

%tic
while (exitflag ~= 1) | (resnorm > 1e-12)
    
    [a, resnorm, residual,exitflag] = lsqnonlin(@dev, a0, lb ,ub, options);
    
%     exitflag
%     resnorm
        
    nTry = nTry + 1;
    
    a0 = (pi/2)*(rand(1,3)-0.5); % use random guess for next try
       
end
%toc

phi   = mod(a(1),2*pi)*180/pi;
theta = mod(a(2),2*pi)*180/pi;
psi   = mod(a(3),2*pi)*180/pi;

%nTry

    function F = dev(a)
        
        q1 = [cos(a(1)/2),0,0,-sin(a(1)/2)]'; % see write-up
        q2 = [cos(a(2)/2),0,-sin(a(2)/2),0]';
        if isTLS==1
            q3 = [cos(a(3)/2),0,0,sin(a(3)/2)]';
        else
            q3 = [cos(a(3)/2),0,0,-sin(a(3)/2)]';
        end
        F = q - qMult_bsx(q3,qMult_bsx(q2,q1));      
    end

end