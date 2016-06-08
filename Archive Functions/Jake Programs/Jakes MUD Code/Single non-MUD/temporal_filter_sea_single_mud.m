% This function temporally filters the valid data points. The
function [Valid_unk,Valid_H,x]=temporal_filter_sea_single_mud(Unk_of_t,tw,N_pulses)
% Find the center of each section;
for (k=1:N_pulses)
    center(k)=round(size(Unk_of_t,1)/2);
end
a=5;
% The width of the temporal response function is:
x=round((a*tw));
H=ones(size(Unk_of_t));
% taking the valid data ponts:
for k=1:N_pulses
    if k==1
        Valid_unk(:,k)=(Unk_of_t([center(k)-round(x/2):center(k)+(round(x/2)-1)],k));
        Valid_H(:,k)=H([center(k)-round(x/2):center(k)+(round(x/2)-1)]);
    else
        Valid_unk(:,k)=(Unk_of_t([center(k)-round(x/2):center(k)+(round(x/2)-1)],k));
        Valid_H(:,k)=H([center(k)-round(x/2):center(k)+(round(x/2)-1)]);
    end
end
x=size(Valid_unk,1);