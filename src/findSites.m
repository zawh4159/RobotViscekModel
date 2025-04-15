function [PotentialSites] = findSites(lattice_coords,robot_coords,Idx)

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
        if sum(abs(robot_coords(:,ii) - lattice_coords(:,jj))) < 0.05
            continue
        end
        if any(Idx{jj}==ii)
            potentialSites = [potentialSites jj];
        end
    end
    
    PotentialSites{ii} = potentialSites;
    
end
end