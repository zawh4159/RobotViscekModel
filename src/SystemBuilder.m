function [lattice_coords,robot_coords,robot_sectorangle,robot_latticeindex,DomainBoundaries,PairlistMethod,ellipseaxes]  = SystemBuilder(experimentType,L0,Nrobots,sigma,e,N)

% create the boundary
% 0. Define the domain
     %Define the domain boundaries
     DomainBoundaries = [-L0*sigma L0*sigma -L0*sigma L0*sigma]; % Size of domain

% 1. Create the lattice coordinates
switch experimentType
    case 'flat'
        %create a line
        xcoord = -L0*sigma:sigma:L0*sigma;
        ycoord = 0*xcoord;
        ellipseaxes = NaN;

        lattice_coords = [xcoord; ycoord];

        PairlistMethod = 2;
    case 'convex'
        %create an ellipse with points evenly spaced
        [lattice_coords,ellipseaxes] = constructEllipse(N,e,sigma);

        PairlistMethod = 2;
    case 'concave'
        PairlistMethod = 2;
        [lattice_coords,ellipseaxes] = constructEllipse(N,e,sigma);
    otherwise
        error('Please select a correct experimentType: ("flat","convex","concave")')
end

% 2. Add robots to lattice
switch experimentType
    case 'flat'
        robot_coords = [0; 0.01];%lattice_coords(:,ilattice);
        robot_latticeindex = 1;
    case 'convex'
       robot_coords = [lattice_coords(1,1); 1.01*lattice_coords(2,1)];
       robot_latticeindex = 1;
    case 'concave'
       robot_coords = [lattice_coords(1,1); 0.99*lattice_coords(2,1)];
       robot_latticeindex = 1;
    otherwise
        error('Please select a correct experimentType: ("flat","convex","concave")')
end


    %ilattice = randi(length(lattice_coords),[1 Nrobots]);
    ilattice = 1;
    %robot_coords = [0; 0.01];%lattice_coords(:,ilattice);
    %robot_coords(2,:) = robot_coords(2,:) + 0.01;

% 3. Determine robots intital angle
    v1 = [1 0]; %Fixed coordinate frame
    v2 = robot_coords'-lattice_coords(:,ilattice)'; %Normal vector from sit to robot
    robot_sectorangle = vecangle360(v1,v2);

% 4. Determine search sector
    %SearchSectorAngle = 170;

    %search_sector = randi(NumSearchSectors,[1 Nrobots]);
    %searchSectorBoundaries = 0:SearchSectorAngle:360;
    %searchSectorBoundaries(2,:) = circshift(searchSectorBoundaries(1,:),-1);
    %searchSectorBoundaries(:,end) = [];
    %SearchAngle = mean(searchSectorBoundaries);

end
