function [a] = vecangle360(v1,v2)

%prepare inputs
v1 = [v1'; 0];
v2 = [v2'; 0];

%orthonormal vector
n = [0;0;1];

x = cross(v1,v2);
c = sign(dot(x,n)) * norm(x);
a = atan2d(c,dot(v1,v2));

end