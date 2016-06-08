% this program fits the phase and give a function 
% which represents that phase:

function [fit1]=phase_fit1(phase1,varargin)
N=length(phase1);
x0=round(N/2);
Nx=2000;
x1=1:Nx;
x2=1:N;
if nargin==1
    phase2=phase1(x0-Nx/2:x0+(Nx-1)/2);
else
    y0=varargin{1};
    phase2=phase1(y0:y0+Nx-1);
end
p = polyfit(x1,phase2,2);
fit1=p(1)*(x2-x0).^2+p(2)*(x2-x0)+p(3);