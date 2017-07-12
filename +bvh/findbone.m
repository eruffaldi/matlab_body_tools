function [r,ri] = findbone(s,n)

for I=1:length(s.tree)
    if strcmp(s.tree(I).name,n)
        r = s.tree(I);
        ri = I;
        return
    end
end
r = [];
ri = [];

