function[sys,x0,str,ts] = spacemodel(t,x,u,flag)

switch flag,
case 0,
	[sys,x0,str,ts] = mdlInitializeSizes;
case 1,
	sys = mdlDerivatives(t,x,u);
case 3,
	sys = mdlOutputs(t,x,u);
case {2,4,9}
	sys = [];
otherwise
	error(['Unhandled flag = ',num2str(flag)]);
end

function[sys,x0,str,ts] = mdlInitializeSizes
sizes = simsizes;
sizes.NumContStates  = 6;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 6;
sizes.NumInputs      = 3;
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
x0 = [1,0,0,0.5,0,0];
str = [];
ts = [0 0];

function sys = mdlDerivatives(t,x,u)
p = 1;
c = 0.5;
m = 40;
g = 9.8;
m11 = p^2;
m12 = -c*p*cos(x(1))*x(6);
m21 = m12;
m22 = 1+x(6)^2*(c^2+p^2*sin(x(1))^2);
b11 = c*p*cos(x(1))*x(4); 
b12 = 0;
b21 = -(c^2*x(6)+p*sin(x(1))*(1+p*x(6)*sin(x(1))))*x(4);
b22 = 1/m;
K = [g*p*sin(x(1))+(1+p*x(6)*sin(x(1)))*p*cos(x(1))*x(6)*x(4)^2;
    -(1+p*x(6)*sin(x(1)))*2*p*cos(x(1))*x(6)*x(4)*x(2)-c*p*x(6)*sin(x(1))*x(2)^2;
    0];
M = [m22,-m12,0;
    -m21,m11,0;
    0,0,1];
B = [b11,b12,0;
    b21,b22,0;
    1,0,1];
f = (1/(m11*m22-m12*m21))*M*K;
f = f';
b = (1/(m11*m22-m12*m21))*M*B;

sys(1) = x(2);
sys(2) = f(1)+u(1);

sys(3) = x(4);
sys(4) = f(2)+u(2);

sys(5) = x(6);
sys(6) = f(3)+u(3);

function sys = mdlOutputs(t,x,u)

sys(1) = x(1);
sys(2) = x(2);
sys(3) = x(3);
sys(4) = x(4);
sys(5) = x(5);
sys(6) = x(6);



