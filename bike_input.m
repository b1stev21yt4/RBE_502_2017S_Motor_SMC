% S-function for continuous state equation
function [sys,x0,str,ts] = s_function(t,x,u,flag)

switch flag,
% initialization
case 0,
	[sys,x0,str,ts]=mdlInitializeSizes;
% Outputs
case 3,
	sys=mdlOutputs(t,x,u);
% Unhandled flags
case {2,4,9}
	sys = [];
% Unexpected flags
otherwise
	error(['Unhandled flag = ',num2str(flag)]);
end

%mdlInitializeSizes
function[sys,x0,str,ts]=mdlInitializeSizes
sizes = simsizes;
sizes.NumContStates  = 0;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 3;
sizes.NumInputs      = 1;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 0;

sys = simsizes(sizes);
x0 = [];
str = [];
ts = [];
function sys = mdlOutputs(t,x,u)

% ===================================================================
% 1
% x11d=sin(pi*t/2);     % alpha
% x21d=cos(pi*t);       % int vr
% x31d=0;               % sigma

% ===================================================================
% 2
% x11d = 0;
% x21d = 10*t;
% x31d = 0;

% ===================================================================
% 3
x11d = 0;
x21d = 7*t - 7*0;
x31d = asin(cos(t)/7)/7 - asin(cos(0)/7)/7;
% ===================================================================


sys(1) = x11d;
sys(2) = x21d;
sys(3) = x31d;