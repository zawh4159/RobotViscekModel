function [Coords,Polarity,Type] = addRobots(DomainBoundaries,RaftRadi,sigma,Nrobots)
%% a. Setup
% 0. Dubug Options
    iplot = 1;        %plot the output

% 1. Compute packing quantities
    xi = (sigma/2);   % mesh size 

% 2. Get the domain limits
    ax = (DomainBoundaries(2)-DomainBoundaries(1))/2;
    ay = (DomainBoundaries(4)-DomainBoundaries(3))/2;
    bx = -ax;
    by = -ay;

% 3. Place the fixed robot
    cp = [0 0];
    coords = cp;
    ty = [1];

% 4. Initialize Vectors
    Coords = [];
    Type = [];
%% b. Run packing algorithm
itry = 1;
while 1 == 1 && length(coords) <= Nrobots-1

    if itry > 1000
        break
    end

    cp = [ax + (bx-ax)*rand(1) ay + (by-ay)*rand(1)];
    
    % See if outside the boundary
    %if (cp(1)^2 + cp(2)^2) > 0.95*(RaftRadi^2)
    %    continue
    %end

    % Get the distance btw randomly chosen cp and rest of cps
    data = repmat(cp',[1,size(coords,1)])'-coords;
    dist2 = data(:,1).^2+data(:,2).^2;

    % Get the indicies of any cps within one particle diameter
    iclose = find(dist2 < xi^2,1);

    % If there are no potential intersections - successful placement
    if  isempty(iclose)
        coords = [coords; cp];
        ty = [ty 2]; % add type 2 robots
        itry = 1;
        continue
    end

    itry = itry + 1;
end

% Store data
Polarity = [zeros(length(Coords),1); 2*pi()*(rand(length(coords),1) - 0.5)];
Coords = [Coords; coords];
Type = [Type ty];

if iplot
    figure(2); clf
    hold on
    isurf = type == 1;
    iraft = type == 2;
    iwater = type == 4;
    scatter(Coords(iwater,1),Coords(iwater,2),36,'filled')
    viscircles([0 0],RaftRadi,'color',[0.8500 0.3250 0.0980])
    %scatter(Coords(iraft,1),Coords(iraft,2),36,'filled')
    scatter(Coords(isurf,1),Coords(isurf,2),36,'filled')
    axis equal
end
end