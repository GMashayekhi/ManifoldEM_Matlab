%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (c) 2020 UWM ManifoldEM team  
% Developed by Russell Fung 2014
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  maxIter = 100;        % maximum number of iterations, each iteration determines
                        %   optimum sets of {a,b} and {\tau} in turns
  delta_a_max = 1;      % maximum percentage change in amplitudes
  delta_b_max = 1;      % maximum percentage change in offsets
  delta_tau_max = 0.01; % maximum change in values of tau
  a_b_tau_result = 'a_b_tau_result.mat'; % save final results here
  
  nS = size(psi,1);
  x = psi(:,1:3);
  
% (1) initial guesses for {a,b} obtained by fitting data in 2D
% (2) initial guesses for {tau} obtained by setting d(R)/d(tau) to zero
  
  X = psi(:,1);
  Z = psi(:,3);
  X2 = X.*X;
  X3 = X2.*X;
  X4 = X2.*X2;
  X5 = X3.*X2;
  X6 = X3.*X3;
  sumX = sum(X);
  sumX2 = sum(X2);
  sumX3 = sum(X3);
  sumX4 = sum(X4);
  sumX5 = sum(X5);
  sumX6 = sum(X6);
  sumZ = sum(Z);
  sumXZ = X'*Z;
  sumX2Z = X2'*Z;
  sumX3Z = X3'*Z;
  coeff = [sumX6 sumX5 sumX4 sumX3
           sumX5 sumX4 sumX3 sumX2
           sumX4 sumX3 sumX2 sumX
           sumX3 sumX2 sumX  nS   ]\[sumX3Z; sumX2Z; sumXZ; sumZ];
  D = coeff(1);
  E = coeff(2);
  F = coeff(3);
  G = coeff(4);
  disc = E*E-3*D*F;
  a1 = (2*sqrt(disc))/(3*D);
  a3 = (2*disc^(3/2))/(27*D*D);
  b1 = -E/(3*D);
  b3 = (2*E*E*E)/(27*D*D)-(E*F)/(3*D)+G;
  
  Xb = X-2*b1;
  Y = psi(:,2);
  XXb = X.*Xb;
  X2Xb2 = XXb.*XXb;
  sumXXb = sum(XXb);
  sumX2Xb2 = sum(X2Xb2);
  sumY = sum(Y);
  sumXXbY = XXb'*Y;
  coeff = [sumX2Xb2 sumXXb; sumXXb nS]\[sumXXbY; sumY];
  A = coeff(1);
  C = coeff(2);
  a2 = 2*A*disc/(9*D*D);
  b2 = C+(A*E*E)/(9*D*D)-(2*A*F)/(3*D);
  a = [a1 a2 a3];
  b = [b1 b2 b3];
  
  tau = zeros(nS,1);
  for p=1:nS
    tau(p) = solve_d_R_d_tau_p_3D();
  end
