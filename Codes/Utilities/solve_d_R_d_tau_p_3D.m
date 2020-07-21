function tau=solve_d_R_d_tau_p_3D()
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (c) 2020 UWM ManifoldEM team 
% Developed by Russell Fung 2014
%
% tau = solve_d_R_d_tau_p_3D()
% 
% returns the value of tau for data point p that minimizes the residual
% R to the model x_ij = a_j cos(j*pi*tau_i) + b_j for i = p.
% 
% j goes from 1 to 3 (this is only for 3D systems).
% 
% i goes from 1 to nS where nS is the number of data points to be fitted.
% 
% For a fixed set of a_j and b_j, j=1:3, tau_i for i=1:nS are
% obtained by putting dR/d(tau_i) to zero.
% 
% For a fixed set of tau_i, i=1:nS, a_j and b_j for j=1:3 are
% obtained by solving 3 sets of 2x2 linear equations.
% 
% Global input:
%   p: index of the data point of interest.
%   a, b: dimensions 1 x 3, the current set of model coefficients.
%   x: dimensions nS x 3, the data points to be fitted.
% Output:
%   tau: tau value for data point p that best fits the model.
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  global p a b x
  d_R_d_beta_3D = [48*a(3)^2
                   0
                   8*a(2)^2-48*a(3)^2
                   -12*a(3)*(x(p,3)-b(3))
                   a(1)^2-4*a(2)^2+9*a(3)^2-4*a(2)*(x(p,2)-b(2))
                   -a(1)*(x(p,1)-b(1))+3*a(3)*(x(p,3)-b(3))]';
  beta = roots(d_R_d_beta_3D);
  beta(abs(imag(beta))>0) = [];
  beta(abs(beta)>1) = [];
  tau_candidate = [acos(beta)/pi;0;1];
  [dummy,id] = min(R_p(tau_candidate));
  tau = tau_candidate(id);
