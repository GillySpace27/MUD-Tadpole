% This function converts frequency to time for a padded time axis

function [t]=wtot_padd(w, length_Et)
dt = 2*pi/range(w);
N = length_Et;
t = (-N/2:(N/2-1))*dt;