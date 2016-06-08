function lam = equally_spaced_lam(w)
% EQUALLY_SPACED_W Equally-spaced angular frequency
%
%   Lam = EQUALLY_SPACED_lam(w) returns an equally-spaced array of angular
%   wavelengths corresponding to a sorted array of frequencies.
%   (increasing or decreasing).
%
%   Units are nm/fs
%%% begin skeleton 
	version = '$Id: equally_spaced_w.m,v 1.1 2008-10-13 21:26:11 pam Exp $'; 
	
	% Constants
	c = 300; % speed of light
%%% end skeleton
%%% Code starts here
n = length(w);
w_0 = mean(w);
lmax=2*pi*c/max(w);
lmin=2*pi*c/min(w);
lam_0 = 2*pi*c/w_0;
dlam = (lmax-lmin)/n; % dl2dw always makes dw>0
lam = [-n/2*dlam:dlam:(n-1)/2*dlam]+lam_0;
