function r = cmufind(idir,i1,i2)

if nargin < 3
    a = idir;
    b = i1;
    idir = a;
    i1 = a;
    i2 = b;
end


r = sprintf('%s/%02d/%02d_%02d.bvh',evalin('base','cmubase'),idir,i1,i2);