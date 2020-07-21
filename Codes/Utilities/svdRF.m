function [U,S,V]=svdRF(A)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (c) 2020 UWM ManifoldEM team 
% Developed by Russell Fung 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[D1,D2] = size(A);
if (D1>D2)
  [V,D] = eig(A'*A);
  [D,V,S,invS] = tidyUp(D,V);
  U = A*V*invS;
else
  [U,D] = eig(A*A');
  [D,U,S,invS] = tidyUp(D,U);
  V = A'*U*invS;
end
% end function svdRF

function [D,EV,S,invS]=tidyUp(D,EV)
  [D,order] = sort(diag(D),'descend');
  EV = EV(:,order);
  sqrtD = sqrt(D);
  S = diag(sqrtD);
  invS = diag(1./sqrtD);
% end function tidyUp