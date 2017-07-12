function xyz = bvh2xyz(skel, channels)

% BVH2XYZ Compute XYZ values given structure and channels.
%
%	Description:
%
%	XYZ = BVH2XYZ(SKEL, CHANNELS) Computes X, Y, Z coordinates given a
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

if usequat == 0
    
    for i = 1:length(skel.tree)  
          if ~isempty(skel.tree(i).posInd)
            p = channels(skel.tree(i).posInd);
            p = p(:)';
          else
              p = [0,0,0];
          end
          xyzStruct(i) = struct('rotation', [], 'xyz', []); 
          if nargin < 2 | isempty(skel.tree(i).rotInd)
                    xyzangles = [0,0,0];
          else   
                xyzangles = deg2rad(channels(skel.tree(i).rotInd));
                %yangle = deg2rad(channels(skel.tree(i).rotInd(2)));
                %zangle = deg2rad(channels(skel.tree(i).rotInd(3)));
          end
          thisRotation = rotationMatrix(xyzangles(1), xyzangles(2), xyzangles(3), skel.tree(i).order);
            off = skel.tree(i).offset;

          if ~skel.tree(i).parent
                xyzStruct(i).rotation = thisRotation;
                xyzStruct(i).xyz = off + p;
          else
              pR = xyzStruct(skel.tree(i).parent).rotation;
              pp = xyzStruct(skel.tree(i).parent).xyz;
                xyzStruct(i).xyz = (off + p)*pR    + pp;
                xyzStruct(i).rotation = thisRotation*pR;
          end
    end

    
else
    
    for i = 1:length(skel.tree)  
      if ~isempty(skel.tree(i).posInd)
        p = channels(skel.tree(i).posInd(:));
      else
        p = [0,0,0];
      end
      xyzStruct(i) = struct('quat', [], 'xyz', []); 
      if nargin < 2 | isempty(skel.tree(i).rotInd)
              q = [1,0,0,0];
      else   
              q = channels(skel.tree(i).rotInd); 
      end
      off = skel.tree(i).offset;
      p = p(:)'; % hor
      if ~skel.tree(i).parent
            xyzStruct(i).quat = q;
            xyzStruct(i).xyz = off + p;
      else
              pq = xyzStruct(skel.tree(i).parent).quat;
              pp = xyzStruct(skel.tree(i).parent).xyz;
              
              xyzStruct(i).xyz = qRotatePoint(off + p, pq)' + pp;
              xyzStruct(i).quat = qMul(pq,q);
      end
    end
end

xyz = reshape([xyzStruct(:).xyz], 3, length(skel.tree))';



