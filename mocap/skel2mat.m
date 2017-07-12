function [mat,mat0] = skel2mat(skel, channels)

% SKEL2MAT Compute MAT values given skeleton structure and channels.
%
%	Description:
%
%	[MAT,MAT0] = SKEL2MAT(SKEL, CHANNELS) Computes X, Y, Z coordinates given a
%	BVH or acclaim skeleton structure and an associated set of channels.
%	 Returns:
%	  XYZ - the point cloud positions for the skeleton.
%	 Arguments:
%	  SKEL - a skeleton for the bvh file.
%	  CHANNELS - the channels for the bvh file.
%	
%
%	See also
%	ACCLAIM2XYZ, BVH2XYZ


%	Copyright (c) 2006 Neil D. Lawrence
% 	skel2xyz.m CVS version 1.2
% 	skel2xyz.m SVN version 42
% 	last update 2008-08-12T20:23:47.000000Z
%
%
% Modified by Emanuele Ruffaldi for mat
%
% NOTE: mat is left matrix (and not right matrix as rest of mocap lib)

fname = str2func([skel.type '2mat']);
[mat,mat0] = fname(skel, channels);