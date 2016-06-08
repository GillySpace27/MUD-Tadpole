% this function indexes the temporally filtered fields for concatenation:
% makes alternate columns be data then an increasing index.
% U1 = temporally filtered slices
% H1 = weighting functions
% tw = delay between reference pulses (in index points not fs)
% tsp = temporal length of each section (in index points not fs)

function [Unew,Hnew]=index_temporal_slices(U1,H1,tw,tsp)
N=size(U1,2);
Unew=zeros([size(U1,1),size(U1,2)*2]);
Hnew=Unew;
for k=1:N
    if k==1
        Unew(:,2*k)=tw*(k-1)+(1:tsp); %index
        Unew(:,2*k-1)=U1(:,k); %data
        Hnew(:,2*k)=tw*(k-1)+(1:tsp); %index
        Hnew(:,2*k-1)=H1(:,k); %data
    else
        Unew(:,2*k)=tw*(k-1)+(1:tsp);
        Unew(:,2*k-1)=U1(:,k);
        Hnew(:,2*k)=tw*(k-1)+(1:tsp);
        Hnew(:,2*k-1)=H1(:,k);
    end
end