function [lattice_coords,ellipseaxes] = constructEllipse(N,e,sigma);

% DO NOT ADJUST
tol = 0.1e-1;
maxiter = 1e6;
da = 0.001;

if e == 1
    warning('Value of e = 1 would lead to line... manually decreasing to e = 0.99')
    e = 0.99; %if user inputs e = 1 (line) then manual adjust
end

%%
% First we need to find the semi-major and semi-minor axes lengths that
% satisfy the circumference we need (N*sigma) and the eccentricity (e)

disp('Finding semi-major and semi-minor axes...')

% Intial condition
a_start = 0.01; % make a guess for a

% Find the major and minor axis
curtol = 1; iter = 0;
while curtol > tol
    iter = iter + 1;
    
    if iter > maxiter
        error('Could not find ellipse')
    end
    
    % Increment the minor axis
    if iter == 1
        a = a_start;
    else
        a = a + da;
    end
    
    % Find the major axis
    b = sqrt(a^2-(e*a)^2);

    % parameter for elliptic integral
    m = 1 - b^2/a^2;
    
    %get the circumference
    circumference = 4*a*ellipticE(m);
    curtol = abs(circumference -N*sigma); %error

end
fprintf("done in %4.0f iterations. \n",iter)
%%
% Now that we know the semi-major and minor axes: need to compute the
% inverse of the incomplete elliptic integral of the second kind to find
% the angles for the N points

%Preallocate
theta = zeros([1 N]);
xcoord = zeros([1 N]);
ycoord = zeros([1 N]);

%Initialize
theta(1) = 0;
xcoord(1) = a*sin(theta(1));
ycoord(1) = b*cos(theta(1));

dtheta = 0.005; %Angle incremement
for ii = 2:N
    fprintf("Computing elliptic point... %1.0f/%1.0f \n",ii,N)
    
    % new start point
    phi = theta(ii-1) + 2*dtheta;

    curtol = 1; iter = 0;
    while curtol > 0.025
        iter = iter + 1;
        
        phi = phi + dtheta;

        if iter > maxiter
            error('Could not find ellipse')
        end 
        
        %the new theta_start is the old point
        curtol = abs(a*ellipticE(phi,m) - ((ii-1)/N)*circumference);
    end

    theta(ii) = phi;
    xcoord(ii) = a*sin(theta(ii));
    ycoord(ii) = b*cos(theta(ii));
    
end
fprintf("done... found ellipse \n")

lattice_coords = [xcoord;ycoord];
ellipseaxes.a = a;
ellipseaxes.b = b;

scatter(xcoord,ycoord)
axis('square')
% axis([-5 5 -5 5])