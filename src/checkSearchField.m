function [ijump,JumpIndex] = checkSearchField(lattice_coords,robot_coords,robot_sectorangle,PotentialSites,SearchSectorAngle)

[a,b] = size(robot_coords);

%ijump = [];
%JumpIndex = [];
% 1. Loop through list of robots and determine if any site is seen
for ii = 1:b

    pot_sites = PotentialSites{ii};
    
    % if no potential sites - skip
    if isempty(pot_sites)
        ijump(ii) = 0;
        JumpIndex(ii) = NaN;
        continue
    end
    
    %loop through sites and find angle
    v1 = [1 0];
    for jj = 1:length(pot_sites)
        v2 = lattice_coords(:,pot_sites(jj))'-robot_coords(:,ii)';
        theta(jj) = vecangle360(v2,v1);
    end

    % find if site is within search sector
    isector = abs(robot_sectorangle-theta) < SearchSectorAngle/2;
    
    if sum(isector) == 1
        ijump(ii) = 1;
        JumpIndex(ii) = pot_sites(isector);
    elseif sum(isector) > 1
        ijump(ii) = 1;
        I = randi(length(isector),1); % IF for some reason more than one site is seen: THEN pick one randomly
        JumpIndex(ii) = pot_sites(I);
    else
        ijump(ii) = 0;
        JumpIndex(ii) = NaN;
    end

% if no potential sites - skip
    % if isempty(pot_sites)
    %     continue
    % end
    % 
    % % 2. Determine angle between robot and sites
    % Arobot = SearchAngle(search_sector(ii));
    % v1 = [cosd(Arobot) sind(Arobot)];
    % for kk = 1:length(potentialSites)
    %     v2 = lattice_coords(:,potentialSites(kk))'-robot_coords(:,ii)';
    %     theta(kk) = vecangle360(v1,v2);
    % end
    % 
    % % 3. Find if site is within the search angle
    % isector = abs(theta) <  SearchSectorAngle;
    % 
    % 


end