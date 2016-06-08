function [pks,h] = smart_lclmax(B);
%changes the threshold for the lclmax function until three peaks are found.
% B is a vertical slice through the fourier transform of the interference
% pattern.  
if max(B)~= 1
    B = Norm(B);
end


t = .1;  %initial threshold value
[pks, h] = lclmax(B,10,t);

l = length (pks);
while l < 3;
    t = t-.001;
    [pks, h] = lclmax(B,10,t);
    l = length(pks);
end

while l > 3;
    
    t = t+.001;
    [pks, h] = lclmax(B,10,t);
    l = length(pks);
end