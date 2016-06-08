function [phi,spectrum]= find_phi_jake4(int,pks)
%This function retrieves the unknonwn pulse from a SEA TADPOLE trace
%
%   use the command:  [phi, spectrum]= find_phi(a, refspec, cal, spec) 
%   a is the 2D interferogram, refspec is the image of the reference
%   spectrum, S(x,omega) and cal is the calibration of the wavelength axis
%
%% options
make_plots = true;

if nargin == 0;
    cal = .1;
    display('Because cal was not specified, the wavelenght axis in the plots will not correct.')
end

%% fourier filtering
% b = (fftc(int-ref));  %fourier transforming the the interferogram. 
b=fftc(int);
if size(pks)<1;
    %If there are no fringes the phase and spectrum are set to 0
    phi = zeros(size(sum(int)));
    spectrum = zeros(size(sum(int)));
    display('There are no finges in the interferogram!')
else
    c = pks(1);
    c2 = pks(2);
    d = round(abs(c2-c)/2); 
    d=20;
    cut = ifftc(b(c-d:c+d,:));  %and this is to cut out the interference term  
    x=1;
    cut=cut(x:end-x,:);
    phi = mean(unwrap(angle(cut),[],2)); %summing over x to get the spectral phase
    %phi = ((mean(unwrap(angle(cut(2:end-1,:)))))); %summing over x to get the spectral phase
    %If the unknown fiber is on the bottom, then a minus sign is needed here
        
%     spectrum = sum(abs(cut)).^2./((sum(ref))); 
    spectrum = mean(abs(cut)).^2;
    %summing over x to get the spectrum, and dividing out the reference spectrum
end

%% plotting the results

if make_plots==false;
    return
end
