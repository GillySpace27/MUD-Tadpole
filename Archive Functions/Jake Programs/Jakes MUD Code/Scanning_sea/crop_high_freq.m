% This function crops out the high frequencies of the 
% retrieved spectra:
% Ew = the retrieved spectra in freq
% L = the size of the alloweed window in freq space
% num0 = the initial cut-off value

function [Ew1]=crop_high_freq(Ew,min1,max1)
N=size(Ew,2);
Ew1=zeros(size(Ew));
for k=1:N
    Ew1([min1:max1],k)=Ew([min1:max1],k);
end