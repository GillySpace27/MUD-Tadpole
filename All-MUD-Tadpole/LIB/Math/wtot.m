% This function converts frequency to time

function [t]=wtot(w)
dt = 2*pi/range(w);
N = length(w);
t = (-N/2:(N/2-1))*dt;