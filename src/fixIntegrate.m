function [robot_sectorangle] = fixIntegrate(robot_sectorangle,dt,tauR)

    %Rotational noise
    etaR = randn(length(robot_sectorangle),1);

    %Compute rotational noise
    theta_dot = etaR/tauR;

    %Integrate
    robot_sectorangle = robot_sectorangle + theta_dot*dt;

end