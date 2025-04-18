clear all
close all

%% 0. Preamble
    
%% I. Inputs

%%% Robot Properties
% Real units (DO NOT ADJUST)
    sigma = 1;               % average robot length (mm)
    
% Model Parameters
    SearchSectorAngle = 25;   
    tauR = 0.0001;            % Timescale for rotational diffusion
    Rcut = 1.3*sigma;        % Cutoff radius

%%% System Parameters
    L0 = 1000;               % domain size (in robot lengths sigma)
    dt = 0.01;               % timestep (sec)

%%% Desired simulation
    Nrobots = 1;             % intial number of robots
    N = 20;                  % number of ellipse points
    e = 0.95;                 % eccentricity (circle: e = 0,ellipse: 0 < e < 1)
    experimentType = 'convex'; % choose from {'flat','convex','concave'}

%% II. Simulation Options

%%% Dump properties
    nout = 5;
    ExpTime = 10e3; %[1e3 0.5e3 0.1e3 0.05e3 0.01e3]
    iplot = 0;
    % video options
    % v = VideoWriter("RobotLattice");
    % open(v)

%% III. System Initialization
% 1. Build the system
    [lattice_coords,robot_coords,robot_sectorangle,robot_latticeindex,DomainBoundaries,PairlistMethod,ellipseaxes]  = SystemBuilder(experimentType,L0,Nrobots,sigma,e,N);

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
    [robot_coords,robot_sectorangle,robot_latticeindex] = moveRobots(lattice_coords,robot_coords,robot_sectorangle,robot_latticeindex ,ijump,JumpIndex);
    %% b. Outputs % Plotting
    if rem(iter/nout,1) == 0
            
            if iplot
            figure(1); clf
            hold on

            % Draw boundary
            %plot([-L0 L0],[0 0],'k','LineWidth',2) %for flat
            phi = linspace(0,2*pi,1000);
            plot(ellipseaxes.a*sin(phi),ellipseaxes.b*cos(phi),'k','LineWidth',2)%for ellipse
           
            % Draw sites
            scatter(lattice_coords(1,:),lattice_coords(2,:),'filled')

            % Draw robot
            scatter(robot_coords(1,:),robot_coords(2,:),'filled')
            
            % Draw robots field of vision
            plot([robot_coords(1,:),1*cosd(robot_sectorangle)+robot_coords(1,:)],[robot_coords(2,:),1*sind(robot_sectorangle)+robot_coords(2,:)],'LineWidth',2,'Color','k')
            plot([robot_coords(1,:),1*cosd(robot_sectorangle-SearchSectorAngle/2)+robot_coords(1,:)],[robot_coords(2,:),1*sind(robot_sectorangle-SearchSectorAngle/2)+robot_coords(2,:)],'LineWidth',1,'LineStyle','-.','Color',[0.5 0.5 0.5])
            plot([robot_coords(1,:),1*cosd(robot_sectorangle+SearchSectorAngle/2)+robot_coords(1,:)],[robot_coords(2,:),1*sind(robot_sectorangle+SearchSectorAngle/2)+robot_coords(2,:)],'LineWidth',1,'LineStyle','-.','Color',[0.5 0.5 0.5])

            %axis([-L0 L0 -L0 L0])
            axis([-5 5 -5 5])
            set(gca,"FontName",'Helvetica','LineWidth',1.75,'FontSize',14)
            box on
            axis square
            
            
            % Frame = getframe(gcf);
            % writeVideo(v,Frame)
            end
    end

    %% c. Computes
    T(iter) = robot_sectorangle;
    X(iter) = robot_coords(1);
    Time(iter) = TotalTime;
    % Want how long the robot spends at each node

    % robots traveled distance from start point

end

histogram(robot_latticeindex,20)

% close(v)
%%
X(end)





% Xthe_2_mean = mean(Xthe_2,2);
% Xthe_2_SE = std(Xthe_2,0,2)/sqrt(6);
% 
% Xthe_3_mean = mean(Xthe_3,2);
% Xthe_3_SE = std(Xthe_3,0,2)/sqrt(6);
% 
% Xthe_4_mean = mean(Xthe_4,2);
% Xthe_4_SE = std(Xthe_4,0,2)/sqrt(6);
% 
% Xthe_5_mean = mean(Xthe_5,2);
% Xthe_5_SE = std(Xthe_5,0,2)/sqrt(6);
% 
% Xthe_6_mean = mean(Xthe_6,2);
% Xthe_6_SE = std(Xthe_6,0,2)/sqrt(6);

%%% Figure 1 %%% 
time = [1e3 0.5e3 0.1e3 0.05e3 0.01e3];
tvec = linspace(0.01e3,1e3,100);

% tauR = 0.001;
Xfin_1 = [32 15 23 59 25 18;8 21 41 9 19 17;15 3 7 3 17 10;5 4 11 4 8 4;1 3 3 1 1 4];
Xfin_1_mean = mean(Xfin_1,2);
Xfin_1_SE = std(Xfin_1,0,2)/sqrt(6);

% tauR = 0.0025;
Xfin_2 = [26 25 21 6 25 1;9 24 13 2 13 8;6 1 5 0 4 3;5 7 1 3 4 0;2 1 1 0 0 2];
Xfin_2_mean = mean(Xfin_2,2);
Xfin_2_SE = std(Xfin_2,0,2)/sqrt(6);

% tauR = 0.0001
Xfin_3 = [100 59 117 18 129 130;20 2 70 84 126 36;73 7 71 58 29 47;20 30 24 26 12 26; 18 4 17 14 14 22];
Xfin_3_mean = mean(Xfin_3,2);
Xfin_3_SE = std(Xfin_3,0,2)/sqrt(6);

figure(1); hold on
errorbar(time,Xfin_2_mean,Xfin_2_SE,'LineWidth',2,'Marker','v','Color',[253 163 27]/255,'MarkerFaceColor',[253 163 27]/255)
errorbar(time,Xfin_1_mean,Xfin_1_SE,'LineWidth',2,'Marker','square','Color',[189 54 64]/255,'MarkerFaceColor',[189 54 64]/255)
errorbar(time,Xfin_3_mean,Xfin_3_SE,'LineWidth',2,'Marker','o','Color',[85 27 118]/255,'MarkerFaceColor',[85 27 118]/255)

Dt = [0.3953 0.1353 4.1884];
plot(tvec,sqrt(2.*Dt(1).*tvec),'LineWidth',2,'LineStyle','-.','Color',[189 54 64]/255)
plot(tvec,sqrt(2.*Dt(2).*tvec),'LineWidth',2,'LineStyle','-.','Color',[253 163 27]/255)
plot(tvec,sqrt(2.*Dt(3).*tvec),'LineWidth',2,'LineStyle','-.','Color',[85 27 118]/255)

xlabel('Time (sec)')
ylabel('Distance (\sigma)')
title('Translational Diffusion')
set(gca,'XScale', 'log','YScale', 'log','LineWidth',1.75,'FontSize',14)
box on
axis square
grid on

legend('\tau_R = 0.0025','\tau_R = 0.001',' \tau_R = 0.0001')

%%% Figure 2 %%% 
figure(2)
plot(Time,X,'LineWidth',2)
xlabel('Time (sec)')
ylabel('Distance (\sigma)')
title('Robot Trajectory')
set(gca,'LineWidth',1.75,'FontSize',14)
box on
axis square
yline(X(end),'LineWidth',1.75,'Color',[125 125 125]/255,'LineStyle','-.')
yline(0,'LineWidth',1.75,'Color',[125 125 125]/255,'LineStyle','-.')


%%%
% figure(3); hold on
% theta = [15 45 90 140 150 170];
% Dt_the = [];
% thetavec = linspace(0,175,100);
% Dr = 0.001^-1;
% alpha = 1e-4;
% 
% Dt = alpha*(thetavec./(180-thetavec)).*Dr;
% 
% plot(thetavec,Dt)
% 
% errorbar(time,Xfin_2_mean,Xfin_2_SE,'LineWidth',2,'Marker','v','Color',[253 163 27]/255,'MarkerFaceColor',[253 163 27]/255)
% errorbar(time,Xfin_1_mean,Xfin_1_SE,'LineWidth',2,'Marker','square','Color',[189 54 64]/255,'MarkerFaceColor',[189 54 64]/255)
% errorbar(time,Xfin_3_mean,Xfin_3_SE,'LineWidth',2,'Marker','o','Color',[85 27 118]/255,'MarkerFaceColor',[85 27 118]/255)
%%%%%%%%%%%

figure(4); hold on
time = [1e3 0.5e3 0.1e3 0.05e3 0.01e3];
load("Xend3.mat")

Marker = {'square','square','square','square','square'};
c = [79 22 94;40 48 121;23 116 135;15 157 127;79 196 97]/255;

Xthe_1 = [32 15 23 59 25 18;8 21 41 9 19 17;15 3 7 3 17 10;5 4 11 4 8 4;1 3 3 1 1 4]; %theta - 15
Xthe_1_mean = mean(Xthe_1,2);
Xthe_1_SE = std(Xthe_1,0,2)/sqrt(6);

errorbar(time,Xthe_1_mean,Xthe_1_SE,'LineWidth',2,'Marker','v','Color',[0 0 0]/255,'MarkerFaceColor',[0 0 0]/255,'LineWidth',2)
% 
cnt = 0;
for ii = 1:5 %loop through angles
        for jj = 1:5 %loop through times
            for kk = 1:15 %loop through samples
             cnt = cnt + 1;
             Xthe{ii}(jj,kk) = abs(Xend(cnt));
             %Vars(kk,jj)
        end
    end
    Xthe_mean{ii} =  mean(Xthe{ii},2);
    Xthe_2_SE{ii} = std(Xthe{ii},0,2)/sqrt(15);
    errorbar(time,Xthe_mean{ii},Xthe_2_SE{ii},'Marker',Marker{ii},'Color',c(ii,:),'MarkerFaceColor',c(ii,:),'LineWidth',2)
end

tvec = linspace(0.01e3,1e3,100);
Dt = [0.3953 0.4537 0.7969 5.1799 8.599 11.5104];
theta = [15 45 90 135 150 170];

% plot(tvec,sqrt(2.*Dt(1).*tvec),'LineWidth',2,'LineStyle','-.','Color',[0 0 0]/255)
% plot(tvec,sqrt(2.*Dt(2).*tvec),'LineWidth',2,'LineStyle','-.','Color',c(1,:))
% plot(tvec,sqrt(2.*Dt(3).*tvec),'LineWidth',2,'LineStyle','-.','Color',c(2,:))
% plot(tvec,sqrt(2.*Dt(4).*tvec),'LineWidth',2,'LineStyle','-.','Color',c(3,:))
% plot(tvec,sqrt(2.*Dt(5).*tvec),'LineWidth',2,'LineStyle','-.','Color',c(4,:))
% plot(tvec,sqrt(2.*Dt(6).*tvec),'LineWidth',2,'LineStyle','-.','Color',c(5,:))

legend('\theta_s = 15','\theta_s = 45','\theta_s = 90','\theta_s = 135','\theta_s = 150','\theta_s = 170')
xlabel('Time (sec)')
ylabel('Distance (\sigma)')
title('Translational Diffusion vs \theta_s')
set(gca,'XScale', 'log','YScale', 'log','LineWidth',1.75,'FontSize',14)
box on
axis square
grid on

%%%% 
theta_vec = linspace(0,175,100);
Dt_analytical = 2*theta_vec./(180-theta_vec);

figure(2); hold on
scatter(theta,Dt)
plot(theta_vec,Dt_analytical)


%ydata =  Xthe_1_mean;
