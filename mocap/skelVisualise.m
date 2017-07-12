function handle = skelVisualise(channels, skel, padding,colorme,withtext)
% SKELVISUALISE For drawing a skel representation of 3-D data.
%
%	Description:
%
%	HANDLE = SKELVISUALISE(CHANNELS, SKEL) draws a skeleton
%	representation in a 3-D plot.
%	 Returns:
%	  HANDLE - a vector of handles to the plotted structure.
%	 Arguments:
%	  CHANNELS - the channels to update the skeleton with.
%	  SKEL - the skeleton structure.
%	
%
%	See also
%	SKELMODIFY


%	Copyright (c) 2005, 2006 Neil D. Lawrence
% 	skelVisualise.m CVS version 1.4
% 	skelVisualise.m SVN version 30
% 	last update 2008-01-12T11:32:50.000000Z
%
% Modified by Emanuele Ruffaldiw with color, text and matrix support

if isstruct(channels)
    a = skel;
    skel = channels;
    channels = a;
end

if nargin < 4
    colorme = 'b';
end
if nargin < 5
    withtext = 0;
end

if nargin<3
    padding = 0;
end

% if cell is set of matrices
if iscell(channels)
    vals = zeros(length(channels),3);
    for I=1:length(channels)
        m = channels{I};
        vals(I,:) = m(1:3,4);
    end
    
    connect = skelConnectionMatrix(skel);
    indices = find(connect);
    [I, J] = ind2sub(size(connect), indices);
    handle(1) = plot3(vals(:, 1), vals(:, 3), vals(:, 2), ['.' colorme]);
    axis ij % make sure the left is on the left.
    set(handle(1), 'markersize', 20);
    hold on
    grid on
    if withtext == 1
        for i = 1:length(vals)
            text(vals(i,1),vals(i,3),vals(i,2),[skel.tree(i).name]);
        end
    end

    for i = 1:length(indices)
      handle(i+1) = line([vals(I(i), 1) vals(J(i), 1)], ...
                  [vals(I(i), 3) vals(J(i), 3)], ...
                  [vals(I(i), 2) vals(J(i), 2)],'Color',colorme);
      set(handle(i+1), 'linewidth', 2);
    end
    for I=1:length(channels)
        m = channels{I};
        p = vals(I,:)';
        px = p + m(1:3,1)*0.05;
        py = p + m(1:3,2)*0.05;
        pz  = p + m(1:3,3)*0.05;
        line([p(1),px(1)],[p(3),px(3)],[p(2),px(2)],'Color','r');
        line([p(1),py(1)],[p(3),py(3)],[p(2),py(2)],'Color','g');
        line([p(1),pz(1)],[p(3),pz(3)],[p(2),pz(2)],'Color','b');
    end
    
    axis equal
    xlabel('x')
    ylabel('z')
    zlabel('y')
    axis on
    

else
    channels = [channels zeros(1, padding)];
    vals = skel2xyz(skel, channels);
    connect = skelConnectionMatrix(skel);
    indices = find(connect);
    [I, J] = ind2sub(size(connect), indices);
    handle(1) = plot3(vals(:, 1), vals(:, 3), vals(:, 2), ['.' colorme]);
    axis ij % make sure the left is on the left.
    set(handle(1), 'markersize', 20);
    hold on
    grid on
    if withtext == 1
    for i = 1:length(vals)
        text(vals(i,1),vals(i,3),vals(i,2),[skel.tree(i).name]);
    end
    end

    for i = 1:length(indices)
      handle(i+1) = line([vals(I(i), 1) vals(J(i), 1)], ...
                  [vals(I(i), 3) vals(J(i), 3)], ...
                  [vals(I(i), 2) vals(J(i), 2)],'Color',colorme);
      set(handle(i+1), 'linewidth', 2);
    end
    axis equal
    xlabel('x')
    ylabel('z')
    zlabel('y')
    axis on
end
