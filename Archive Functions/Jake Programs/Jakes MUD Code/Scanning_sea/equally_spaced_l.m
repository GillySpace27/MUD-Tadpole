function lam = equally_spaced_l(w)
% EQUALLY_SPACED_L Equally-spaced wavelength axis
%
%   lam = EQUALLY_SPACED_L(LAM) returns an equally-spaced array of angular
%   frequencies W corresponding to a sorted array of wavelenghts LAM
%   (increasing or decreasing).
%
%   Units are m/s.
%%% begin skeleton 
	version = '$Id: equally_spaced_w.m,v 1.2 2009-03-07 19:21:52 pam Exp $'; 
	
	% Units
	cm = 1e-2;
	mm = 1e-3;
	um = 1e-6;
	nm = 1e-9;
    ps = 1e-12;
    fs = 1e-15;
	THz = 1e12; 
	% Constants
	c = 300; % speed of light
%%% end skeleton
%%% Code starts here
n = length(w);
if n == 0
    w = [];
else if n == 1
        w = ltow(lam);
    else
        w_0 = mean(w);
        dw = mean(diff(w));
        lam0 = ltow(w_0);
        lmax=2*pi*c/min(w);
        lmin=2*pi*c/max(w);
        dl=(lmax-lmin)/n;
        lam = [lam0-n*dl/2:dl:lam0+(n-1)*dl/2];    
    end
end