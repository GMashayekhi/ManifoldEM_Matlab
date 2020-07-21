function [a, logSumWij,resnorm] = fergusonE(D, logEps, a0)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (c) 2020 UWM ManifoldEM team 
% Original Author Chuck Yoon
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function ferguson(D,s)
% D: Distance matrix
% logEps: Range of values to try
% Adapted from Chuck, 2011
%-------------------------
% example: 
% logEps = [-10:0.2:10];
% ferguson(sqrt(yVal),logEps,1*(rand(4,1)-.5))
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%
% Range of values to try
logSumWij = zeros(1,length(logEps)); % Initialize
options = optimset('display','off');
for k = 1:length(logEps)
    eps = exp(logEps(k));
    Wij = exp(-(D.^2)/(2*eps));    % See Coifman 2008
    %A_ij = sparse(A_ij);
    logSumWij(k) = log(sum(Wij(:)));
end
% curve fitting of a tanh()
resnorm = inf;
while (resnorm>100)

    [a, resnorm] = lsqcurvefit(@fun, a0, logEps, logSumWij,[],[],options);
    resnorm;
    a0 = 1*(rand(4,1)-.5);
end
% if (resnorm<10)
%     figure
%     plot(logEps, logSumWij,'bo-'), hold on, axis tight
%     xlabel('ln \epsilon','fontsize',24)
%     ylabel('ln \Sigma W_{ij}','fontsize',24)
% 
% % 
%      x = logEps;
%     plot(x,a(4)+a(3)*tanh(a(1)*x+a(2)),'green');
% 
%     text(-a(2)/a(1),a(4), sprintf('\\leftarrow ln \\epsilon = %7.4f',-a(2)/a(1)),...
%                                  'HorizontalAlignment','left','fontsize',18);
%     plot(x,a(4)+a(1)*a(3)*(x+a(2)/a(1)),'red');
%     hold off;
% % 
% %     %**************************************************************************
%     title(['\fontsize{16} Ferguson plot          ', '\fontsize{10}',date]);
%      xx=min(logEps)+2;
%      yy=max(logSumWij);
% % 
%     text(xx,yy-1, sprintf('\\sigma = %3.2e',sqrt(2*exp(-a(2)/a(1)))),'fontsize',14);
%    % text(xx,yy-1.5, sprintf('nS = 182'),'fontsize',14);
%     text(xx,yy-2, sprintf('nN = nS'),'fontsize',14);
%     text(xx,yy-2.5, sprintf('Dim. = %3.2f',2*a(1)*a(3)),'fontsize',14);
%    % **************************************************************************
% 
%     display(sprintf('Dimension = %f', 2*a(1)*a(3)));
%     display(sprintf('logEps_opt = %f', -a(2)/a(1)));
%     display(sprintf('sigma_opt = %f', sqrt(2*exp(-a(2)/a(1)))));
% end

end
  function F = fun(aa, xx)
        F = aa(4) + aa(3)*tanh(aa(1)*xx+aa(2));
  end