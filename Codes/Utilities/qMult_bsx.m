function p = qMult_bsx(q,s)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (c) 2020 UWM ManifoldEM team 
% Developed  by Peter Schwander
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% for any number of quaternions N
% q is 4xN or 4x1
% s is 4xN or 4x1

q0 = q(1,:);
qv = q(2:4,:);
s0 = s(1,:);
sv = s(2:4,:);

c = [bsxfun(@times,qv(2,:),sv(3,:))-bsxfun(@times,qv(3,:),sv(2,:));
     bsxfun(@times,qv(3,:),sv(1,:))-bsxfun(@times,qv(1,:),sv(3,:));
     bsxfun(@times,qv(1,:),sv(2,:))-bsxfun(@times,qv(2,:),sv(1,:))];
p = [bsxfun(@times,q0,s0)-sum(bsxfun(@times,qv,sv));bsxfun(@times,q0,sv)+bsxfun(@times,s0,qv)+c];

end