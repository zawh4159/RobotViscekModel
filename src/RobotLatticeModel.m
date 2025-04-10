clear all
close all

%% 0. Preamble

%% I. Inputs

%%% Robot Properties
% Real units (DO NOT ADJUST)
    sigma = 1;               % average robot length (mm)
    
% Model Parameters
    NumSearchSectors = 24;   
    tauR = 0.001;            % Timescale for rotational diffusion
    Rcut = 1.2*sigma;        % Cutoff radius

%%% System Parameters
    L0 = 100;                  % domain size (in robot lengths sigma)
    dt = 0.01;               % timestep (sec)

%%% Desired simulation
    Nrobots = 1;             %intial number of robots
    experimentType = 'flat'; % choose from {'viscek','viscek','viscek','viscek','viscek'}

%% II. Simulation Options

%%% Dump properties
    nout = 5;
    ExpTime = 0.1e3;

    % video options
    %v = VideoWriter("RobotLattice");
    %open(v)

%% III. System Initialization
% 1. Build the system
    [lattice_coords,robot_coords,robot_sectorangle,SearchSectorAngle,DomainBoundaries,PairlistMethod]  = SystemBuilder(experimentType,L0,Nrobots,sigma,NumSearchSectors);

%% IV. Run Experiment
iter = 0; TotalTime = 0; dumpstep = 0;
while TotalTime < ExpTime
    TotalTime/ExpTime
    TotalTime = TotalTime + dt;
    iter = iter + 1;
    
    %% a. Simulation
    % 1. Construct the pairlist
    [Idx] = buildPairlist(lattice_coords,robot_coords,Rcut,DomainBoundaries,PairlistMethod);

    % 2. Find sites within range
    [PotentialSites] = findSites(lattice_coords,robot_coords,Idx);
    
    % 3. Integrate sector angle
    [robot_sectorangle] = fixIntegrate(robot_sectorangle,dt,tauR);

    % 4. Determine if search sector lands on site
    [ijump,JumpIndex] = checkSearchField(lattice_coords,robot_coords,robot_sectorangle,PotentialSites,SearchSectorAngle);
   
    % 5. Update robots lattice positions
    [robot_coords,robot_sectorangle] = moveRobots(lattice_coords,robot_coords,robot_sectorangle,ijump,JumpIndex);

    %% b. Outputs % Plotting
    if rem(iter/nout,1) == 0
            
            % figure(1); clf
            % hold on
            % plot([-L0 L0],[0 0],'k','LineWidth',2)
            % scatter(lattice_coords(1,:),lattice_coords(2,:),'filled')
            % scatter(robot_coords(1,:),robot_coords(2,:),'filled')
            % axis([-L0 L0 -L0 L0])
            % set(gca,"FontName",'Helvetica','LineWidth',1.75,'FontSize',14)
            % box on
            % axis square
            % 
            % plot([robot_coords(1,:),1*cosd(robot_sectorangle)+robot_coords(1,:)],[robot_coords(2,:),1*sind(robot_sectorangle)+robot_coords(2,:)],'LineWidth',2,'Color','k')
            % plot([robot_coords(1,:),1*cosd(robot_sectorangle-7.5)+robot_coords(1,:)],[robot_coords(2,:),1*sind(robot_sectorangle-7.5)+robot_coords(2,:)],'LineWidth',1,'LineStyle','-.','Color',[0.5 0.5 0.5])
            % plot([robot_coords(1,:),1*cosd(robot_sectorangle+7.5)+robot_coords(1,:)],[robot_coords(2,:),1*sind(robot_sectorangle+7.5)+robot_coords(2,:)],'LineWidth',1,'LineStyle','-.','Color',[0.5 0.5 0.5])

            %Frame = getframe(gcf);
            %writeVideo(v,Frame)
            
    end

    %% c. Computes
    T(iter) = robot_sectorangle;
    X(iter) = robot_coords(1);

    % Want how long the robot spends at each node

    % robots traveled distance from start point




end

%close(v)

%mean([32 15 23 59 25]) t=1e3
%mean([8 21 41 9 19 17])t=0.5e3
%mean([15 3 7 3 17 10])t=0.1e3

% meanx = [30.8 19.1667 9.166];
% time = [1e3 0.5e3 0.1e3];
% 
% t = linspace(0.1e3,1e3,100);
% figure(1); hold on
% scatter(time,meanx)
% loglog(t,sqrt(2*0.4*t))
% 
% Dr = 3*0.4
% 
% 1/(24*tauR)