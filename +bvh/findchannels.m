function r = findchannels(x,bones)

r = [];
for I=1:length(bones)
    r = [r; x.tree(bones(I)).rotInd];
end
