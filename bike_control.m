function[sys,x0,str,ts] = spacemodel(t,x,u,flag)

switch flag,
case 0,
	[sys,x0,str,ts] = mdlInitializeSizes;
case 3,
	sys = mdlOutputs(t,x,u);
case {2,4,9}
	sys = [];
otherwise
	error(['Unhandled flag = ',num2str(flag)]);
end

function[sys,x0,str,ts] = mdlInitializeSizes
sizes = simsizes;
sizes.NumContStates  = 0;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 3;
sizes.NumInputs      = 15;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
x0 = [];
str = [];
ts = [0 0];

function sys = mdlOutputs(t,x,u)
persistent e10 de10 dde10 e20 de20 dde20 e30 de30 dde30
T =0.5;
% ===================================================================
% 1
% x11d = u(1);
% dx11d = pi/2*cos(pi*t/2);
% ddx11d = -(pi/2)^2*sin(pi*t/2);
% 
% x21d = u(2);
% dx21d = -pi*sin(pi*t);
% ddx21d = -pi^2*cos(pi*t);
% 
% x31d = u(3);
% dx31d = 0;
% ddx31d = 0;
% ===================================================================
% 2
% x11d = u(1);
% dx11d = 0;
% ddx11d = 0;
% 
% x21d = u(2);
% dx21d = 10;
% ddx21d = 0;
% 
% x31d = u(3);
% dx31d = 0;
% ddx31d = 0;
% ===================================================================
% 3
x11d = u(1);
dx11d = 0;
ddx11d = 0;

x21d = u(2);
dx21d = 7;
ddx21d = 0;

x31d = u(3);
dx31d = (sin(t)/(49 - cos(t)^2)^(1/2) + (cos(t)^2*sin(t))/(49 - cos(t)^2)^(3/2))/(7*(cos(t)^2/(cos(t)^2 - 49) - 1));
ddx31d = (cos(t)/(49 - cos(t)^2)^(1/2) + cos(t)^3/(49 - cos(t)^2)^(3/2) - (3*cos(t)^3*sin(t)^2)/(49 - cos(t)^2)^(5/2) - (3*cos(t)*sin(t)^2)/(49 - cos(t)^2)^(3/2))/(7*(cos(t)^2/(cos(t)^2 - 49) - 1)) + ((sin(t)/(49 - cos(t)^2)^(1/2) + (cos(t)^2*sin(t))/(49 - cos(t)^2)^(3/2))*((2*cos(t)*sin(t))/(cos(t)^2 - 49) - (2*cos(t)^3*sin(t))/(cos(t)^2 - 49)^2))/(7*(cos(t)^2/(cos(t)^2 - 49) - 1)^2);
% ===================================================================

x = u(4:1:9);
dx = u(10:1:15);
if t == 0
% 	e10 = x(1);
% 	de10 = x(2) - pi/2;
% 	dde10 = dx(2);
% 
% 	e20 = x(3) - 1;
% 	de20 = x(4);
% 	dde20 = dx(4) + pi^2;
% 
% 	e30 = x(5) - 1;
% 	de30 = x(6);
% 	dde30 = dx(6);
% ===================================================================
	e10 = x(1);
	de10 = x(2) ;
	dde10 = dx(2);

	e20 = x(3);
	de20 = x(4)-7;
	dde20 = dx(4);

	e30 = x(5) - (asin(1/7)/7);
	de30 = x(6);
	dde30 = dx(6)-0.0206;

end

C = [4 0 0 4 0 0 1 0 0;
     0 4 0 0 4 0 0 1 0;
     0 0 4 0 0 4 0 0 1];

e1 = x(1) - x11d;
de1 = x(2) - dx11d;
dde1 = dx(2) - ddx11d;

e2 = x(3) - x21d;
de2 = x(4) - dx21d;
dde2 = dx(4) - ddx21d;

e3 = x(5) - x31d;
de3 = x(6) - dx31d;
dde3 = dx(6) - ddx31d;

e = [e1;e2;e3];

a00 = -10;
a10 = 15;
a20 = -6;
a01 = -6;
a11 = 8;
a21 = -3;
a02 = -1.5;
a12 = 1.5;
a22 = -0.5;
T = 0.5;
if t<=T
    A10 = (a00/(T^3))*e10 + (a01/(T^2))*de10 + (a02/T)*dde10;
    A11 = (a10/(T^4))*e10 + (a11/(T^3))*de10 + (a12/(T^2))*dde10;
    A12 = (a20/(T^5))*e10 + (a21/(T^4))*de10 + (a22/(T^3))*dde10;
    p1 = e10 + de10*t + 0.5*dde10*t^2 + A10*t^3 + A11*t^4 + A12*t^5;
    dp1 = de10 + dde10*t + 3*A10*t^2 + 4*A11*t^3 + 5*A12*t^4;
    ddp1 = dde10 + 6*A10*t + 12*A11*t^2 + 20*A12*t^3;

    A20 = (a00/(T^3))*e20 + (a01/(T^2))*de20 + (a02/T)*dde20;
    A21 = (a10/(T^4))*e20 + (a11/(T^3))*de20 + (a12/(T^2))*dde20;
    A22 = (a20/(T^5))*e20 + (a21/(T^4))*de20 + (a22/(T^3))*dde20;
    p2 = e20 + de20*t + 0.5*dde20*t^2 + A20*t^3 + A21*t^4 + A22*t^5;
    dp2 = de20 + dde20*t + 3*A20*t^2 + 4*A21*t^3 + 5*A22*t^4;
    ddp2 = dde20 + 6*A20*t + 12*A21*t^2 + 20*A22*t^3;

    A30 = (a00/(T^3))*e30 + (a01/(T^2))*de30 + (a02/T)*dde30;
    A31 = (a10/(T^4))*e30 + (a11/(T^3))*de30 + (a12/(T^2))*dde30;
    A32 = (a20/(T^5))*e30 + (a21/(T^4))*de30 + (a22/(T^3))*dde30;
    p3 = e30 + de30*t + 0.5*dde30*t^2 + A30*t^3 + A31*t^4 + A32*t^5;
    dp3 = de30 + dde30*t + 3*A30*t^2 + 4*A31*t^3 + 5*A32*t^4;
    ddp3 = dde30 + 6*A30*t + 12*A31*t^2 + 20*A32*t^3;
else
    p1=0;dp1=0;ddp1=0;
    p2=0;dp2=0;ddp2=0;
    p3=0;dp3=0;ddp3=0;
end

p = 1;
c = 0.5;
m = 40;
g = 9.8;
m11 = p^2;
m12 = -c*p*cos(x(1))*x(6);
m21 = m12;
m22 = 1+x(6)^2*(c^2+p^2*sin(x(1))^2);
K = [g*p*sin(x(1))+(1+p*x(6)*sin(x(1)))*p*cos(x(1))*x(6)*x(4)^2;
    -(1+p*x(6)*sin(x(1)))*2*p*cos(x(1))*x(6)*x(4)*x(2)-c*p*x(6)*sin(x(1))*x(2)^2;
    0];
M = [m22,-m12,0;
    -m21,m11,0;
    0,0,1];
f = (1/(m11*m22-m12*m21))*M*K;
f = f';
u1 = f(1)-ddx11d-ddp1+4*[x(2)-dx11d-dp1];
u2 = f(2)-ddx21d-ddp2+4*[x(4)-dx21d-dp2];
u3 = f(3)-ddx31d-ddp3+4*[x(6)-dx31d-dp3];

rou1 = 4*e1+de1-4*p1-dp1;
rou2 = 4*e2+de2-4*p2-dp2;
rou3 = 4*e3+de3-4*p3-dp3;
rou=[rou1;rou2;rou3];

delta0 = 0.03;
delta1 = 5;
delta = delta0 + delta1 * norm(e);
mrou = norm(rou) + delta;

K = 10;
F = 2+t;
ut = -[u1;u2;u3]-rou/mrou*(F+K);

sys(1) = ut(1);
sys(2) = ut(2);
sys(3) = ut(3);