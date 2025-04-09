clear all
close all

%% 0. Preamble

%% I. Inputs

%%% Robot Properties
% Real units (DO NOT ADJUST)
    sigma = 2;       % average robot length (mm)
    
% Model Parameters
    NumSearchSectors = 24;
    tauR = 1;
    Rcut = 1.2*sigma;

%%% System Parameters
    L0 = 20;            % domain size (in robot lengths sigma)
    dt = 1;          % timestep (sec)

%%% Desired simulation
    Nrobots = 1;    %intial number of robots
    experimentType = 'flat'; % choose from {'viscek','viscek','viscek','viscek','viscek'}

%% II. Simulation Options

%%% Dump properties
    nout = 1;
    ExpTime = 1e3;

    % video options
    v = VideoWriter("RobotLattice");
    open(v)

%% III. System Initialization
% 1. Build the system
    [lattice_coords,robot_coords,search_sector,SearchAngle,SearchSectorAngle,DomainBoundaries,PairlistMethod]  = SystemBuilder(experimentType,L0,Nrobots,sigma,NumSearchSectors);

%% IV. Run Experiment
iter = 0; TotalTime = 0; dumpstep = 0;
while TotalTime < ExpTime
    TotalTime/ExpTime
    TotalTime = TotalTime + dt;
    iter = iter + 1;
    
    %% a. Simulation
    % 1. Construct the pairlist
    [Idx] = buildPairlist(lattice_coords,robot_coords,Rcut,DomainBoundaries,PairlistMethod);

    % 2. Determine if site is within range
    [ihop,HopIndex] = findSites(lattice_coords,robot_coords,search_sector,SearchAngle,SearchSectorAngle,Rcut,Idx);

    % 3. Update robots lattice positions
    [robot_coords] = moveRobots(lattice_coords,robot_coords,ihop,HopIndex);

    % 4. Deterermine new sector angle (randomly-instant)
    [search_sector] = updateSearchSector(search_sector,NumSearchSectors);

    %% b. Outputs % Plotting
    if rem(iter/nout,1) == 0

            figure(1); clf
            hold on
            plot([-40 40],[0 0],'k','LineWidth',2)
            scatter(lattice_coords(1,:),lattice_coords(2,:),'filled')
            scatter(robot_coords(1,:),robot_coords(2,:)+0.02,'filled')
            axis([-40 40 -1 1])
            set(gca,"FontName",'Helvetica','LineWidth',1.75,'FontSize',14)
            box on
            axis square

            Frame = getframe(gcf);
            writeVideo(v,Frame)

    end
end
close(v)