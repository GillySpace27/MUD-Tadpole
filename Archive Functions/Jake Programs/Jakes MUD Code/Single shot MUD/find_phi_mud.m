function [Elam,lam]= find_phi_mud(int,ref,cal,points)
%This function retrieves the unknonwn pulse from a SEA TADPOLE trace
%
%   use the command:  [phi, spectrum]= find_phi(a, refspec, cal, spec) 
%   a is the 2D interferogram, refspec is the image of the reference
%   spectrum, S(x,omega) and cal is the calibration of the wavelength axis
%   points = the k-space values of the AC terms
%
%% options
make_plots = true;

if nargin == 0;
    cal = .1;
    display('Because cal was not specified, the wavelenght axis in the plots will not correct.')
end

%% fourier filtering
b = (fftc(int-ref));  %fourier transforming the the interferogram. 
center=round(size(int,1));

for k=1:length(points)
    d = mean(abs(diff(points)));
    cut = ifftc(b(points(k)-d:points(k)+d,:));  %and this is to cut out the interference term
    phi(:,k) = mean(unwrap(angle(cut(2:end-1,:)))); %summing over x to get the spectral phase
    %phi = ((mean(unwrap(angle(cut(2:end-1,:)))))); %summing over x to get the spectral phase
    %If the unknown fiber is on the bottom, then a minus sign is needed here

    spectrum(:,k) = sum(abs(cut)).^2./((sum(ref)));
    %summing over x to get the spectrum, and dividing out the reference spectrum
    Elam(:,k)=sqrt(spectrum(:,k)).*exp(i*phi(:,k));
end
%% plotting the results

lam = lam_axis(cal,length(phi));
