% this function finds the linear term in the phase and returns that value
% t = time axis
% p1 = phase

function [term]=linear_phase_term(p1,t)
mid=round(length(t)/2);
p = polyfit(t(mid-100:mid+100),p1(mid-100:mid+100),2);
term=p(2);