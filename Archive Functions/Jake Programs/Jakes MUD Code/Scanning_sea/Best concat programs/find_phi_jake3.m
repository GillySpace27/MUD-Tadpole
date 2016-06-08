function [phi,spectrum]= find_phi_jake3(int,ref,cal,pks)
%This function retrieves the unknonwn pulse from a SEA TADPOLE trace
%
%   use the command:  [phi, spectrum]= find_phi(a, refspec, cal, spec) 
%   a is the 2D interferogram, refspec is the image of the reference
%   spectrum, S(x,omega) and cal is the calibration of the wavelength axis
%

%% fourier filtering
b = (fftc(int-ref));  %fourier transforming the the interferogram. 

%[pks, h] = smart_lclmax(Norm(mean(abs(b'))));%this is a peak finding program to find the interference term

c = pks(1);
c2 = pks(2);
d = round(abs(c2-c)/2);  
cut = ifftc(b(c-d:c+d,:));  %and this is to cut out the interference term  
    
phi = mean(unwrap(angle(cut(2:end-1,:)))); %summing over x to get the spectral phase
    %phi = ((mean(unwrap(angle(cut(2:end-1,:)))))); %summing over x to get the spectral phase
    %If the unknown fiber is on the bottom, then a minus sign is needed here
spectrum = sqrt(sum(abs(cut)).^2./((sum(ref)))); 
lam = lam_axis(cal,length(phi));
