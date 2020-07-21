function [IND NC] = classS2(S2, S20)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (C) 2020 UWM ManifoldEM team
%
% Developed by Peter Schwander 2013
% 
% Delaunay Triangulation method
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%tic

dt = DelaunayTri(S20);
IND = nearestNeighbor(dt, S2);

% this is the number of snapshots contained in each class
NC = histc(IND,1:size(S20,1));

%toc

end