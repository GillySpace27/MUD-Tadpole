% this function gets rid of the "noise" by subtracting out 
% everything below a certain level in the spectral domain:
% ylim = normalized maximum value of the AC term which 
% is deemed not noise
% Ew = retrieved spectra

function [Ew2]=noise_sub(ylim,Ew)
Ew=Norm(Ew);
Ew2=zeros(size(Ew));
Ew=Ew-ylim;
for k=1:size(Ew,2)
    for m=1:size(Ew,1)
        if Ew(m,k)<0
            Ew2(m,k)=0;
        else
            Ew2(m,k)=Ew(m,k);
        end
    end
end

    
