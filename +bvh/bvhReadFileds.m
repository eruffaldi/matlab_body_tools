function [ds,skel] = bvhReadFileds(filename,mode)
%
% by Emanuele Ruffaldi
%
% builds a dataset out of...
%
[skel,channels,frameLength] = bvhReadFile(filename);
ds = bvh.bvh2ds(skel,channels,frameLength,1,mode);
