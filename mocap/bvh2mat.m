function [mat,mat0] = bvh2mat(skel, channels)

% BVH2MAT Compute MAT values given structure and channels.
%
%	Description:
%
%	[MAT,MAT0] = BVH2MAT(SKEL, CHANNELS) Computes X, Y, Z coordinates given a
%	BVH skeleton structure and an associated set of channels.
%	 Returns:
%	  XYZ - the point cloud positions for the skeleton.
%	 Arguments:
%	  SKEL - a skeleton for the bvh file.
%	  CHANNELS - the channels for the bvh file.
%	
%
%	See also
%	ACCLAIM2XYZ, SKEL2XYZ


%	Copyright (c) 2005, 2008 Neil D. Lawrence
% 	bvh2xyz.m CVS version 1.3
% 	bvh2xyz.m SVN version 42
% 	last update 2008-08-12T20:23:47.000000Z
usequat = strcmp(skel.angle,'quat');

mat = cell(length(skel.tree),1);
mat0 = mat;

for i = 1:length(skel.tree)  
  if ~isempty(skel.tree(i).posInd)
    xpos = channels(skel.tree(i).posInd(1));
    ypos = channels(skel.tree(i).posInd(2));
    zpos = channels(skel.tree(i).posInd(3));
  else
    xpos = 0;
    ypos = 0;
    zpos = 0;
  end
  xyzStruct(i) = struct('rotation', [], 'xyz', []); 
  if nargin < 2 | isempty(skel.tree(i).rotInd)
      if usequat == 1
          q = [1,0,0,0];
      else
            xangle = 0;
            yangle = 0;
            zangle = 0;
      end
  else   
      if usequat == 1
          q = channels(skel.tree(i).rotInd);
      else
        xangle = deg2rad(channels(skel.tree(i).rotInd(1)));
        yangle = deg2rad(channels(skel.tree(i).rotInd(2)));
        zangle = deg2rad(channels(skel.tree(i).rotInd(3)));
      end
  end
  if usequat == 1
      thisRotation = mattx.quat2mat(q,1); % right matrix
  else
      thisRotation = rotationMatrix(xangle, yangle, zangle, skel.tree(i).order)'; % left
  end
  p = [xpos ypos zpos]';
  off = skel.tree(i).offset'; % column
  if ~skel.tree(i).parent
        xyzStruct(i).rotation = thisRotation;
        xyzStruct(i).xyz = off + p;
        
        m = eye(4);
        m(1:3,4) =  off;     
        mat0{i} = m;
       
        m = thisRotation;
        m(1:3,4) =  xyzStruct(i).xyz;
        mat{i} = m;
  else
      pp = xyzStruct(skel.tree(i).parent).xyz;
      pR = xyzStruct(skel.tree(i).parent).rotation;
      
      % zero matrix is just offset
      m = pR;
      m(1:3,4) = pR(1:3,1:3)*off + pp;
      mat0{i} = m;
      
      % decomposed matrix
      xyzStruct(i).xyz = pR(1:3,1:3)*(off+p)+pp;
      xyzStruct(i).rotation = pR*thisRotation;
      
      % assemble output matrix
      m  = xyzStruct(i).rotation;
      m(1:3,4) = xyzStruct(i).xyz;
      mat{i} = m;
  end
  
end
%xyz = reshape([xyzStruct(:).xyz], 3, length(skel.tree))';



