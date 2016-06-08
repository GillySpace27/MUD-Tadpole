function [phi, spectrum, success]= find_phi_jake2(int,ref,cal)
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
b = (fftc(int));  %fourier transforming the interferogram. 
%figure;
%imagesc(abs(b));

[pks, h] = smart_lclmax(Norm(mean(abs(b'))));%this is a peak finding program to find the interference term
%pks=[85,101,117];
if size(pks)<=1;
    %If there are no fringes the phase and spectrum are set to 0
    phi = zeros(size(sum(ref)));
    spectrum = zeros(size(sum(ref)));
    display('There are no finges in the interferogram!')
    success = 0;
else
    c = pks(1);
    c2 = pks(2);
    d = round(abs(c2-c)/3);  
    cut = ifftc(b(c-d:c+d,:));  %and this is to cut out the interference term  
    
    phi = (mean(unwrap(angle(cut(2:end-1,:))))); %summing over x to get the spectral phase
    %phi = ((mean(unwrap(angle(cut(2:end-1,:)))))); %summing over x to get the spectral phase
    %If the unknown fiber is on the bottom, then a minus sign is needed here
        
    spectrum = sum(abs(cut)).^2./((sum(ref))); 
    %summing over x to get the spectrum, and dividing out the reference spectrum
    success = 1;
end

%% plotting the results

if make_plots==false;
    return
end
% scrsz = get(0,'ScreenSize');
% figure('Position',[scrsz(4)/3 scrsz(4)/22 scrsz(3)/1.5 scrsz(4)*.85])

lam = lam_axis(cal,length(phi));
% subplot(2,1,1)
% plot_ew(lam,spectrum,unwrap(phi))
% subplot(2,1,2)
% 
% [t,et] = find_et(phi,spectrum,cal);
% plot_et(t,et)
% %plot the itnerferogram
% figure(2)
% imagesc(int)
% axis off
% title('Interferogram')
% xlabel('\lambda')
