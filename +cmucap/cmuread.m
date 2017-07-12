function [s1,c1] = cmuread(p)

if ischar(p) == 0
    p = cmucap.cmufind(p(1),p(2));
end

sc = 0.1*0.6633;
voff = 0.2606; % vertical offset (not needed)

[s1, c1] = bvhReadFile(p,sc);
s1.tpose = bvh.maketpose(s1);
