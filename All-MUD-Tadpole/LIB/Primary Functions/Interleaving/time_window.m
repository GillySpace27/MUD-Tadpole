%This function calculates the time window of the spectrometer where
%lambda_res is the resolution of the spectrometer and N_f is the number of
%points along the wavelength axis of the spectrometer, adn t_delay is the
%time delay between succesive reference pulses, and lambda_0 is the center
%wavelength
function [tw,delta_t]=time_window(w,t_delay)
[t]=wtot(w);
% the temporal resolution is:
delta_t=abs(mean(diff(t)));
% The number of valid data points to take is:
tw=ceil(abs((t_delay/delta_t-1)));
