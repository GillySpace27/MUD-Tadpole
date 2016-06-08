% this performs the filtering routine for the single shot mud
% points(1) = points value in k-space where the peak is
% points(2) = the points value in k-space where the center is

function [cut]=filter_snm(I1,points,dp)
% Finding the peaks
c=points(1);
c2=points(2);

cut = ifftc(I1(c-dp:c+dp,:),[],1);  %and this is to cut out the interference term 