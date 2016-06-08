function [Elam,lam]= find_phi_mud2(int,ref,cal,points,lam0)
%This function retrieves the unknonwn pulse from a SEA TADPOLE trace
%
%   use the command:  [phi, spectrum]= find_phi(a, refspec, cal, spec) 
%   int =  the 2D interferogram,
%   ref =  1-D spectrum of the each reference pulse
%   cal = wavelength calibration (nm/pixel)
%   points = the k-space values of the AC terms
%
%% fourier filtering
b = fftc(int);  %fourier transforming the the interferogram. 

d = floor(mean(abs(diff(points)))/2);
cut = ifftc(b(points(1)-d:points(1)+d,:));  %and this is to cut out the interference term
phi= mean(unwrap(angle(cut(2:end-1,:)),[],2)); %summing over x to get the spectral phase
spectrum = sum(abs(cut)).^2./ref';
%summing over x to get the spectrum, and dividing out the reference spectrum
Elam=sqrt(spectrum).*exp(i*phi);
%% plotting the results

lam = lam_axis(cal,length(phi),lam0);
