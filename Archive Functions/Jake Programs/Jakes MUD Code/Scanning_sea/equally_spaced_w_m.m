function w = equally_spaced_w_m(lam)
% EQUALLY_SPACED_W Equally-spaced angular frequency
%
%   W = EQUALLY_SPACED_W(LAM) returns an equally-spaced array of angular
%   frequencies W corresponding to a sorted array of wavelenghts LAM
%   (increasing or decreasing).  
%

%%% Code starts here
c=3e8;
n = length(lam);
lam_0 = mean(lam);
w_0 = 2*pi/lam_0*c;
wmax=2*pi*c/min(lam);
wmin=2*pi*c/max(lam);
dw=(wmax-wmin)/n;
w = [w_0-n*dw/2:dw:w_0+(n-1)*dw/2];