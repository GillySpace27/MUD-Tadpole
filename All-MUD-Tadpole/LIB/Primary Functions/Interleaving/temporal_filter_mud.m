% This function temporally filters the valid data points. The
function [Valid_unk,Valid_H,tsp]=temporal_filter_mud(Unk_of_t,tw,N_pulses)
N_pulses = uint16(N_pulses);


    
    
a=1.2;
% The temporal width of the reference pulse at the spectrometer:
tsp=round((a*tw));

% Find the center of each section;

center = round(size(Unk_of_t,1)/2);
bot = center - round(tsp/2);
top = center + round(tsp/2)-1;

H=ones(size(Unk_of_t));

% Crop each pulse so that only the center +- 1/2 of the reference pulse
% temporal width remains.
for k=1:N_pulses
    if k==1
        Valid_unk(:,k)=(Unk_of_t(bot:top,k));
        Valid_H(:,k)=H(bot:top);
    else
        Valid_unk(:,k)=(Unk_of_t(bot:top,k));
        Valid_H(:,k)=H(bot:top);
    end
end
tsp=size(Valid_unk,1);