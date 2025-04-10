function  [robot_coords,robot_sectorangle] = moveRobots(lattice_coords,robot_coords,robot_sectorangle,ijump,JumpIndex)

[a,b] = size(robot_coords);

    for ii = 1:b
        
        %if robot didn't hop skip
        if ~ijump(ii)
            continue
        end
        
        %else move it to the new lattice position
        robot_coords(:,ii) = lattice_coords(:,JumpIndex(ii));
        robot_coords(2,:) = robot_coords(2,:) + 0.01;
        
        %need to reset - robot_sectorangle
        v1 = [1 0]; %Fixed coordinate frame
        v2 = robot_coords(:,ii)'-lattice_coords(:,JumpIndex(ii))'; %Normal vector from sit to robot
        robot_sectorangle(ii) = vecangle360(v1,v2);
        
    end

    
end