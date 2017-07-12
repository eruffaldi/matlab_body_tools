function r = axis2tuple(x)

A2T = [];
A2T.rzxy = [1 1 0 1];
A2T.rzxz = [2 0 1 1];
A2T.szxz = [2 0 1 0];
A2T.szxy = [2 0 0 0];
A2T.ryzy = [1 0 1 1];
A2T.ryzx = [0 1 0 1];
A2T.ryxz = [2 0 0 1];
A2T.ryxy = [1 1 1 1];
A2T.rxzx = [0 1 1 1];
A2T.rxzy = [1 0 0 1];
A2T.sxyz = [0 0 0 0];
A2T.sxyx = [0 0 1 0];
A2T.sxzy = [0 1 0 0];
A2T.rzyz = [2 1 1 1];
A2T.rzyx = [0 0 0 1];
A2T.szyx = [2 1 0 0];
A2T.szyz = [2 1 1 0];
A2T.rxyx = [0 0 1 1];
A2T.rxyz = [2 1 0 1];
A2T.syzx = [1 0 0 0];
A2T.syzy = [1 0 1 0];
A2T.syxy = [1 1 1 0];
A2T.syxz = [1 1 0 0];
A2T.sxzx = [0 1 1 0];

if isempty(x)
    r = A2T;
else
    assert(isfield(A2T,x),'argument should be field');
    r = A2T.(x);
end
