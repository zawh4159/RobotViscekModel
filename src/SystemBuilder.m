function [Coords,Polarity,Type,DomainBoundaries,SimulationParameters] = SystemBuilder(experimentType,L0,Nrobots,sigma)


% 0. Define the domain and raft
     %Define the domain boundaries
     DomainBoundaries = [-L0*sigma L0*sigma -L0*sigma L0*sigma]; % Size of domain

% 1. Error checks
    %if RaftRadi > L0*sigma
    %    error('Inital raft radius R must be less then system domain L0')
    %end
    %if Ns > Nants
    %    error('The number of raft ants cannot exceed the total number of ants')
    %end

% 2. Create the structural and water layers
    %[Coords,type] = createRaft(DomainBoundaries,RaftRadi,sigma,raftDens);

% 3. Add surface ants
     %Nsurface = Nants - Ns;
     [Coords,Polarity,Type] = addRobots(DomainBoundaries,RaftRadi,sigma,Nrobots);

% 4. setup experiment type
    switch experimentType
        case 'viscek'

             SimulationParameters(1) = 1000; %simulation time
             
        case wetting
        case dewetting
        case air

        case contraction

    end

end