% this function gets the retrieved temporal fields ready for
% plotting for trouble shooting 
% Uindex = indexed temporal fields
% tw = delay between reference pulses

function [y,t]=field_ready(Uindex)
N=size(Uindex,2)/2;
for k=1:N
    t(:,k)=Uindex(:,2*k);
    y(:,k)=Uindex(:,2*k-1);
end
% phase1=unwrap(angle(y));
% for k=1:N
%     g(k)=k*tw+1;
% end
% getting the phases ready for plotting comparisons
% for k=1:N-1
%     dp=round((phase1(g(k),k)-phase1(g(k+1),k+1))/(2*pi)); % The Difference in the phase between the two successive time windows is:
%     phase1(:,k+1)=phase1(:,k+1)+dp*2*pi;
% end