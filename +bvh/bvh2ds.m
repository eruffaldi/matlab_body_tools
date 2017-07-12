function ds = bvh2ds(skel,channels,frameLength,isession,rotmode)
%Base pose modification: 3dsMax requires an unusual skeleton BVH
%  "base pose" aka "zero pose".  For the 3dsMax-friendly release I've
%  adjusted the underlying dataset to put the zero pose into the
%  appropriate arms-down position.  Numerous adjustments to the
%  keyframes on the arms were then required to handle the change in
%  rotation axes that happens when you shift the underlying BVH zero
%  pose.
%
%
% BVH http://research.cs.wisc.edu/graphics/Courses/cs-838-1999/Jeff/BVH.html

if strcmp(rotmode,'quat')
    mode = 1;
elseif strcmp(rotmode,'mat')
    mode = 2;
else
    mode = 0;
end

%names = {};
%indices = {};
lasti = 0;
ds = dataset();
n = length(channels);

for I=1:length(skel.tree)
    sk = skel.tree(I);
    c = sk.channels;
    b = sk.name;
    if length(c) == 6 & I==1
        if mode ~= 2
            ds.([b '_pos']) = zeros(n,3);
        end
    end
    if mode == 1
         ds.([b '_q']) = zeros(n,4);
    elseif mode == 2
         ds.([b '_l2p']) = cell(n,1);
    else
        ds.([b '_rZYXdeg']) = zeros(n,3);
    end
end
D = [];

for I=1:length(skel.tree)
    sk = skel.tree(I);
    c = sk.channels;
    b = sk.name;
    if sk.parent > 0
        D = [D; I,sk.parent,1]; % we mark 1 as the root
    end    
    if length(c) == 6 & I==1
        %names{end+1} = [b '_pos'];
        %indices{end+1} = [1:3];        
        %names{end+1} = [b '_rrZYX'];
        %indices{end+1} = [4:6];
        ZYX = channels(:,[4:6]);
        if mode == 1
            ds.([b '_pos']) = channels(:,[1:3]);
            q = mattx.euler2quat(ZYX*pi/180,'rzyx');
            db.([b '_q']) = q;
        elseif mode == 2
            om = cell(length(ds),1);
            for K=1:size(channels,1)
                m = mattx.euler2mat(ZYX(K,:)*pi/180,'rzyx');
                m(1:3,4) = channels(K,1:3);
                om{K} = m;
            end
            ds.([b '_l2p']) = om;
        else
            ds.([b '_pos']) = channels(:,[1:3]);
            ds.([b '_rZYXdeg']) = ZYX;
        end
        lasti = 6;
    else
        if length(c) == 3
            ZYX = channels(:,[lasti+1:lasti+3]);
            if mode == 1
                q = mattx.euler2quat(ZYX*pi/180,'rzyx');
                db.([b '_q']) = q;
            elseif mode == 2
                om = cell(length(ds),1);
                for K=1:size(channels,1)
                    m = mattx.euler2mat(ZYX(K,:)*pi/180,'rzyx');
                    m(1:3,4) = sk.offset;
                    om{K} = m;
                end
                ds.([b '_l2p']) = om;
            else
                ds.([b '_rZYXdeg']) = ZYX;
            end
            %names{end+1} = [b '_rotZYX'];
            %indices{end+1} = [lasti+1:lasti+3];
            lasti = lasti + 3;
            
        elseif length(c) > 0
            error('size not supported');
        end
    end    
end
m = size(channels,1);
if nargin < 4
    isession = [];
end

%for J=1:length(names)
%    ds.(names{J}) = channels(:,indices{J});
%end
ds.frame = (1:m)';

if isempty(isession) == 0
    ds.session = repmat(isession,length(ds),1);
end


m = [];
m.dt = frameLength;
m.skel = skel;
m.parentsegs = spconvert(D);
m.topo = mattx.topologyorder(m.parentsegs);
ds = set(ds,'UserData',m);



% _Xposition => aggregated
% BVH transformation 
