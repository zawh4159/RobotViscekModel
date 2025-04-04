clear all
close all

%% 0. Preamble

%% I. Inputs

%%% Robot Properties
% Real units (DO NOT ADJUST)
    robotmass = 100;    % robot mass (g)
    sigma = 2.93;       % average robot length (mm)
    nu_0 = 2.8128;      % robot speed (mm/s)

%%% System Parameters
    L0 = 20;            % domain size (in robot lengths sigma)
    dt = 1e-1;          % timestep (sec)
   
%%% Viscek parameters
    Rc = 2.0*sigma;     % cutoff radius (this should be weak maybe 2 ant lengths)
    lambda = 1/12;      % velocity decay length (units of inverse number of ants) assume 2 ants as decay strength
    tauR = 2;           % interaction timescale (sec)
    mu = 0.1;           % mobility (for repulsion)
    kappa = 1/(sigma);  % screening length (1/mm) (for repulsion)

%%% Desired simulation
    Nrobots = 6;    %intial number of robots
    experimentType = 'viscek'; % choose from {'viscek','viscek','viscek','viscek','viscek'}

%% II. Simulation Options

%%% Dump properties
    nout = 1;

%% III. System Initialization
    
    % 1. Build the system
    [Coords,Polarity,Type,DomainBoundaries,SimulationParameters,RaftArea,RaftRadi] = SystemBuilder(experimentType,L0,Nrobots,sigma);

    % 2. Split coords by ant types
    surf_coords = Coords(type==1,:);
    
    surf_polari = Polarity(type==1,:);
    
    surf_type = type(type==1);
    stru_type = type(type~=1);

    %Get simulation parameters
    ExpTime = SimulationParameters(1);
    
%% IV. Run Experiment
iter = 0; TotalTime = 0; dumpstep = 0;
while TotalTime < ExpTime
    TotalTime/ExpTime
    TotalTime = TotalTime + dt;
    iter = iter + 1;
    
    %% a. Apply Raft Contraction (Ejection)
    %1. Get ejection events
    [Ns,RaftArea,RaftRadi,Nejected,surf_coords,surf_polari,surf_type] = fixEject(Ns,RaftArea,RaftRadi,raftDens,delta,dt,surf_coords,surf_polari,surf_type);

    %% b. Initiate Deposition Events
    % 1. Find the neighbors between surface ants and other surface ants
        [Idx_surf] = buildPairlist(surf_coords,surf_coords,Rc,DomainBoundaries,1);

    % 1. Find the neighbors between surface ants and water nodes
        [Idx_surfwater] = buildPairlist(stru_coords,surf_coords,Rc/3,DomainBoundaries,1);
        
    % 2. Get deposition events
        [stru_coords,stru_polari,stru_type,surf_coords,surf_polari,surf_type,Fij_W,Tij,Ndeposited,RaftArea,RaftRadi,Ns] = fixDeposit(stru_coords,stru_polari,stru_type,surf_coords,surf_polari,surf_type,Idx_surfwater,Idx_surf,kappa,sigma,Ns,raftDens);
    
    % 1. Find the neighbors between structural/water nodes and other structural/water nodes
        [Idx_stru] = buildPairlist(stru_coords,stru_coords,Rr,DomainBoundaries,1);

    % 3. Update water nodes
        [stru_coords] = updateWater(stru_coords,Idx_stru,stru_type,dt,3*kappa,DomainBoundaries,RaftRadi,sigma);
    %% c. Update Raft Surface
    % 1. Rebuild surface pairlist
        [Idx_surf] = buildPairlist(surf_coords,surf_coords,Rc,DomainBoundaries,1);

    % 1. Compute local density
        [ni] = getLocalDensity(Idx_surf);

    % 2. Compute surface inter-agent interactions
        [Fij,etaT,etaR,nubar] = getAgentInteractions(Idx_surf,ni,lambda,kappa,surf_coords); %(repulsion,noise)
        
    % 3. Integrate
        [surf_coords,surf_polari] = fixIntegrate(surf_coords,surf_polari,dt,Fij,Fij_W,Tij,etaT,etaR,nubar,tauR,mu,sigma,nu_0);
   
    %% e. Apply Boundary Conditions (shouldn't need but always apply)
        [surf_coords] = fixBC(surf_coords,DomainBoundaries);

    %% f. Repair water nodes
        [stru_coords,stru_type,stru_polari] = repairWater(Nejected,Ndeposited,stru_coords,stru_type,stru_polari,RaftRadi,DomainBoundaries);

        Area(iter) = RaftArea;
        Time(iter) = TotalTime/60; %min
    %% g. Store data for dumps
    if rem(iter/nout,1) == 0

        %recombine data sets
        Coords = [surf_coords; stru_coords];
        type = [surf_type stru_type];

        dumpstep = dumpstep + 1;
        x{dumpstep} = Coords(:,1);
        y{dumpstep} =  Coords(:,2);
        ty{dumpstep} = type;
        xlo(dumpstep) = DomainBoundaries(1);
        xhi(dumpstep) = DomainBoundaries(2);
        ylo(dumpstep) = DomainBoundaries(3);
        yhi(dumpstep) = DomainBoundaries(4);

            figure(2); clf
            hold on
            isurf = type == 1;
            iraft = type == 2;
            iwater = type == 4;
            scatter(Coords(iwater,1),Coords(iwater,2),36,'filled')
            viscircles([0 0],RaftRadi,'color',[0.8500 0.3250 0.0980]);
            %scatter(Coords(iraft,1),Coords(iraft,2),36,'filled')
            scatter(Coords(isurf,1),Coords(isurf,2),36,'filled')
            set(gcf,'Position',[100 100 900 900])
            axis equal
            axis([-70 70 -70 70])
    end

    %% h. Computes 
    % raft area

    % phase fractions

    % 

end

%% V. Dump Data
%writetoDUMP(x,y,ty,xlo,xhi,ylo,yhi); %need to add naming variable

figure(3)
plot(Time,Area,'LineWidth',2,'Color','k')
xlabel('Time (sec)')
ylabel('Area (mm^2)')
