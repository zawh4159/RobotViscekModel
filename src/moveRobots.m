function  [robot_coords] = moveRobots(lattice_coords,robot_coords,ihop,HopIndex)

[a,b] = size(robot_coords);

    for ii = 1:b
        
        %if robot didn't hop skip
        if ~ihop(ii)
            continue
        end
        
        %else move it to the new lattice position
        robot_coords(:,ii) = lattice_coords(:,HopIndex(ii));

    end

end