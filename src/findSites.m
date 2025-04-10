function [PotentialSites] = findSites(lattice_coords,robot_coords,Idx)

[a,b] = size(robot_coords);
robot_coords(2,:) = robot_coords(2,:) - 0.01; %remove the offset (just for finding sites)

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
    
    PotentialSites{ii} = potentialSites;
    
end
end