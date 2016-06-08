% this function finds the different sea tad traces from the MUD trace
% I1 = the retrieved mud tadpole trace
% Ref1 = the 1-D reference pulse spectra
% dl = the wavelength calibration (nm/pixel)
% pks = the pks in k-space for filtering
% lam0 = center wavelength
% tau = the delay spacing for the reference pulses


function [Et,E_lam,t_f,lam_eq,amp,t1]=single_mud_fiber(I1,Ref1,dl,N,lam0,tau,x1)
Fint=fftc(I1);

% isloting the retrived SEA traces:
for k=1:N
    dx=floor(mean(abs(diff(x1)))/2);
    cut=ifftc(Fint([x1(k)-dx:x1(k)+dx],:));
    phi= mean(unwrap(angle(cut(2:end-1,:)),[],2)); %summing over x to get the spectral phase
    spectrum = sum(abs(cut)).^2./Ref1(:,k)';
    %summing over x to get the spectrum, and dividing out the reference spectrum
    Elam=sqrt(spectrum).*exp(i*phi);
end
% converting to equally spaced freq axis:
[Ew,w_eq]=convert_retrieved_spectra(Elam,dl,lam0);
% subtracting the background:
x_c1=1;x_c2=500;x2=40;ymax=.1;
[Ew1,w1]=sub_bg2(Ew,x_c1,x_c2,w_eq,x2,ymax);
% concatenating the retrieved spectra:
[Et,E_lam,t_f,lam_eq,amp,t1]=best_concat2(fliplr(Ew),tau,w_eq,lam0);