function mat = euler2mat(xyz,mode)


ai = xyz(1);
aj = xyz(2);
ak = xyz(3);

NEXT_AXIS = [1, 2, 0, 1]+1; % in matlab axis

w = mattx.axis2tuple(mode);
firstaxis = w(1)+1;
parity = w(2);
repetition = w(3);
frame = w(4);

i = firstaxis;
j = NEXT_AXIS(i+parity);
k = NEXT_AXIS(i-parity+1);

if frame == 1
    %swap ai ak 
    a = ak;
    ak = ai;
    ai = a;
end

if parity == 1
    ai = -ai;
    aj = -aj;
    ak = -ak;
end


si = sin(ai); sj = sin(aj); sk = sin(ak);
ci = cos(ai); cj = cos(aj); ck = cos(ak);


cc = ci*ck;
cs = ci*sk;
sc = si*ck;
ss = si*sk;

M = eye(4);
if isa(xyz,'sym')
    M = sym(M);
end

if repetition == 1
    M(i, i) = cj;
    M(i, j) = sj*si;
    M(i, k) = sj*ci;
    M(j, i) = sj*sk;
    M(j, j) = -cj*ss+cc;
    M(j, k) = -cj*cs-sc;
    M(k, i) = -sj*ck;
    M(k, j) = cj*sc+cs;
    M(k, k) = cj*cc-ss;
else
    M(i, i) = cj*ck;
    M(i, j) = sj*sc-cs;
    M(i, k) = sj*cc+ss;
    M(j, i) = cj*sk;
    M(j, j) = sj*ss+cc;
    M(j, k) = sj*cs-sc;
    M(k, i) = -sj;
    M(k, j) = cj*si;
    M(k, k) = cj*ci;
end
    mat = M;


