% this function gets rid of the angular disperiosn term in the phase
% ang_disp = angular dispersion value
% phase1 = retrieved phase (2-D matrix)
% theta = the crossing angle
% w = frequency matrix
% xrange = range in x
% AC = retrieved AC term

function [AC]=rid_ang_term(ang_disp,theta,AC,w,rangex)
c = 300;  
N=size(AC,1);
dx=rangex/N;
x=(-N/2:N/2-1)*dx;
[xx,ww]=ndgrid(x,w);
phase0=unwrap(angle(AC),[],2)-((2*theta/c)*0+ang_disp).*xx.*ww;
AC=abs(AC).*exp(i*phase0);