% this function makes a temporal response function for weighting the
% retrieved amplitudes and phases:
% tsp = the number of points in each time window
% tw = the delay between reference pulses (in points not in time)
% U1 = the retrieved amplitudes after being cut for concatenation

function [H]=make_weighting_function(tsp,tw,U1)
% The number of points in each time window is:
Nt=size(U1,1);
t=(1:Nt)-round(Nt/2);
H1=exp(-(t/(tw)).^2);
% for 833 fs tau:
%H1=exp(-(t/(2*tw)).^2);
%H1=ones(size(H1));
H=zeros(size(U1));
for k=1:size(U1,2)
    H(:,k)=H1;
end

