% this function calculates the spectrum of 
% the pulse for teh chirped pulse beating sim program
% given the experimental parameters for the temporal 
% phase and the intensity:
% t_fwhm = the fwhm of the temporal amplitude
% b = the quadratic temporal chirp term 

function [alpha,beta]=cpb_param(t_fwhm,b)
% the exponential term is:
a=(2/t_fwhm)^2*log(2);
% the spectral chirp is:
beta = b/(4*(a^2+b^2));
alpha = a/(4*(a^2+b^2));
