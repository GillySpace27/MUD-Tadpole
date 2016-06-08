% This function temporally filters the valid data points. The
function [Valid_unk,Valid_H,Valid_unk1,Valid_H1,Valid_unkN,Valid_HN,x]=temporal_filter_sea2(Unk_of_t,tw,N_pulses,H)
% Find the center of each section;
for (k=1:N_pulses)
    center(k)=round(size(Unk_of_t,1)/2);
end
a=1.1;
% The width of the temporal response function is:
x=round((a*tw));
phase=angle(Unk_of_t);
if ischar(H)==1
    H=ones(size(Unk_of_t));
end
% taking the valid data ponts:
for (k=1:N_pulses)
    if k==1
        Valid_unk1=(Unk_of_t([1:center(k)+(round(x/2)-1)],k));
        Valid_H1=H([1:center(k)+(round(x/2)-1)]);
    elseif k==N_pulses
        Valid_unkN=Unk_of_t([center(k)-round(x/2):end-1],k);
        Valid_HN=H([center(k)-round(x/2):end-1],k);
    else
        Valid_unk(:,k)=(Unk_of_t([center(k)-round(x/2):center(k)+(round(x/2)-1)],k));
        Valid_H(:,k)=H([center(k)-round(x/2):center(k)+(round(x/2)-1)]);
    end
end
% Valid_unk_begin=Unk_of_t([1:center(k)-round(x/2)],1);
% Valid_unk_end=Unk_of_t([center(k)+round(x/2):end],end);