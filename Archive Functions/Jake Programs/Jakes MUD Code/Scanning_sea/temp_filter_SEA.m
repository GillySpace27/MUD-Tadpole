% This function temporally filters the scanning SEA TADPOLE data

function [U1]=temp_filter_SEA(Ut,tau,lam)
t=wtot(ltow(lam,'m/s'));
% The time window is:
tw=time_window(lam,tau);
% temporally offsetting the temporal amplitudes:
N=size(Ut,2);
H='n';
[U1]=new_weight_sea(Ut,tw,H);
