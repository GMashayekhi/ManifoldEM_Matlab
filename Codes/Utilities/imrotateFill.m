function [out] = imrotateFill(inp, angle)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (c) 2020 UWM ManifoldEM team 
% Developed by  Peter Schwander Mar. 20, 2014
% function  [out] = imrotateFill(inp)
% Rotates an 2D image couterclockwise by angle in degrees
% Output image has the same dimension as input.
% Undefined regions are filled in by repeating the original image
% Note: input images must be square
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

version = 'imrotateFill, V0.9';

visual = 0; % for testing purposes

nPix = size(inp,1);

inpRep = repmat(inp,3,3);%
% Copyright (c) UWM,

outRep = imrotate(inpRep,angle,'bilinear','crop');

out = outRep(nPix+1:2*nPix,nPix+1:2*nPix);

    if visual
    
    colormap(gray);

    subplot(2,2,1);
    imagesc(inp), axis image
    title('Input');
    subplot(2,2,2);
    imagesc(out), axis image
    title('Output');
    subplot(2,2,3);
    imagesc(inpRep), axis image
    title('Input 3x3');
    subplot(2,2,4);
    imagesc(outRep), axis image
    title('Output 3x3');
    
    end

end
