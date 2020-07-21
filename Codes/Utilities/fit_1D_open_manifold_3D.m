function [a,b,tau] = fit_1D_open_manifold_3D(psi)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (c) 2020 UWM ManifoldEM team
%
% fit_1D_open_manifold_3D
% 
% fit the eigenvectors for a 1D open manifold to the model
% x_ij = a_j cos(j*pi*tau_i) + b_j.
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
% Fit parameters and initial set of {\tau} are specified in
% 
%   get_fit_1D_open_manifold_3D_param.m
% 
% Developed by Russell Fung 2014
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  global p nDim a b x x_fit
  
  nDim = 3;
  
  
  
  get_fit_1D_open_manifold_3D_param
  
  nS = size(x,1);
  
  for iter=1:maxIter
    disp(['iteration ' num2str(iter)])
%%%%%%%%%%%%%%%%%%%%%
% solve for a and b %
%%%%%%%%%%%%%%%%%%%%%
    a_old = a;
    b_old = b;
    j_pi_tau = tau*[1:3]*pi;
    cos_j_pi_tau = cos(j_pi_tau);
    A11 = sum(cos_j_pi_tau.^2);
    A12 = sum(cos_j_pi_tau);
    A21 = A12;
    A22 = nS;
    x_cos_j_pi_tau = bsxfun(@times,x,cos_j_pi_tau);
    b1 = sum(x_cos_j_pi_tau);
    b2 = sum(x);
    coeff = zeros(2,3);
    for qq=1:3
      coeff(:,qq) = [A11(qq) A12(qq); A21(qq) A22]\[b1(qq); b2(qq)];
    end
    a = coeff(1,:);
    b = coeff(2,:);
%%%%%%%%%%%%%%%%%%%%%%%%%
% plot the fitted curve %
%%%%%%%%%%%%%%%%%%%%%%%%%
    j_pi_tau = linspace(0,1,1000)'*[1:3]*pi;
    cos_j_pi_tau = cos(j_pi_tau);
    x_fit = bsxfun(@plus,bsxfun(@times,a,cos_j_pi_tau),b);
    %plot_fitted_curve(iter)
%%%%%%%%%%%%%%%%%
% solve for tau %
%%%%%%%%%%%%%%%%%
    tau_old = tau;
    for p=1:nS
      tau(p) = solve_d_R_d_tau_p_3D();
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% calculate the changes in fitting parameters %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    delta_a = abs(a-a_old)./(abs(a)+eps);
    delta_b = abs(b-b_old)./(abs(b)+eps);
    delta_tau = abs(tau-tau_old);
    delta_a = max(delta_a)*100;
    delta_b = max(delta_b)*100;
    delta_tau = max(delta_tau);
    disp('  changes in fitting parameters:')
    disp(['  amplitudes: ' num2str(delta_a,'%.2f%%,') ...
          '  offsets: ' num2str(delta_b,'%.2f%%,') ...
          '  values of tau: ' num2str(delta_tau,'%.2g.')])
    if (delta_a<delta_a_max)&(delta_b<delta_b_max)&(delta_tau<delta_tau_max)
      break
    end
  end
  
function plot_fitted_curve(hFig)
  global x x_fit
  h = figure(hFig);
  hsp = subplot(2,2,1);
  plot3(x(:,1),x(:,2),x(:,3),'b.','lineWidth',1);
  hold on
  plot3(x_fit(:,1),x_fit(:,2),x_fit(:,3),'g.','lineWidth',1);
  hold off
  set(hsp,'lineWidth',2,'fontSize',15);
  hsp = subplot(2,2,2);
  plotRF(hsp,x(:,1),x(:,2),'','','','b.');
  addplotRF(hsp,x_fit(:,1),x_fit(:,2),'g.');
  hsp = subplot(2,2,3);
  plotRF(hsp,x(:,1),x(:,3),'','','','b.');
  addplotRF(hsp,x_fit(:,1),x_fit(:,3),'g.');
  hsp = subplot(2,2,4);
  plotRF(hsp,x(:,2),x(:,3),'','','','b.');
  addplotRF(hsp,x_fit(:,2),x_fit(:,3),'g.');
  drawnow
%end
