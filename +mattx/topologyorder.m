function to = topologyorder(D)


to = zeros(length(D),1);
k = 1;
left = (1:length(D));
while isempty(left) == 0
    roots = intersect(find(sum(D,2) == 0),left); 
    if isempty(roots) 
        warning('problem');
        break;
    else
        i = roots(1);
        left = setdiff(left,i);
        to(k) = i;
        k = k + 1;
        D(i,:) = 0;
        D(:,i) = 0;
    end
end

