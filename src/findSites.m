function [ihop,HopIndex] = findSites(lattice_coords,robot_coords,search_sector,SearchAngle,SearchSectorAngle,Rcut,Idx)

[a,b] = size(robot_coords);

for ii = 1:b

    % first see if any sites are within cutoff
    % if isempty(Idx{:,ii})
    %     ihop(ii) = 0;
    %     continue
    % end
    
    % 1. Get the indices of sites within range
    potentialSites = [];
    for jj = 1:length(Idx)
        
        % Dont include the site your on
        if robot_coords(:,ii) == lattice_coords(:,jj) 
            continue
        end
        if any(Idx{jj}==ii)
            potentialSites = [potentialSites jj];
        end
    end

    % if no potential sites - skip
    if isempty(potentialSites)
        continue
    end
    
    % 2. Determine angle between robot and sites
    Arobot = SearchAngle(search_sector(ii));
    v1 = [cosd(Arobot) sind(Arobot)];
    for kk = 1:length(potentialSites)
        v2 = lattice_coords(:,potentialSites(kk))'-robot_coords(:,ii)';
        theta(kk) = vecangle360(v1,v2);
    end

    % 3. Find if site is within the search angle
    isector = abs(theta) <  SearchSectorAngle;
    

    if any(isector)
        ihop(ii) = 1;
        HopIndex(ii) = potentialSites(isector);
    elseif all(isector)
        ihop(ii) = 1;
        I = randi(length(isector),1);
        HopIndex(ii) = potentialSites(I);
    else
        ihop(ii) = 0;
        HopIndex(ii) = NaN;
    end

end
end