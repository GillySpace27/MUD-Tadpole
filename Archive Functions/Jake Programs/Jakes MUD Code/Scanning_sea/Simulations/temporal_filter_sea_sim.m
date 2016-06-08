% This function temporally filters the valid data points. The
function [Valid_unk,Valid_H,x]=temporal_filter_sea_sim(Unk_of_t,tw,N_pulses,H)
% Find the center of each section;
for (k=1:N_pulses)
    center(k)=round(size(Unk_of_t,1)/2);
end
a=1.5;
% The width of the temporal response function is:
x=round((a*tw));
if ischar(H)==1
    H=ones(size(Unk_of_t));
end
% taking the valid data ponts:
for (k=1:N_pulses)
    if k==1
        Valid_unk(:,k)=(Unk_of_t([center(k)-round(x/2):center(k)+(round(x/2)-1)],k));
        Valid_H(:,k)=H([center(k)-round(x/2):center(k)+(round(x/2)-1)]);
    else
        Valid_unk(:,k)=(Unk_of_t([center(k)-round(x/2):center(k)+(round(x/2)-1)],k));
        Valid_H(:,k)=H([center(k)-round(x/2):center(k)+(round(x/2)-1)]);
    end
end