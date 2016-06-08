% this function converts the retrieved spectra to equally spaced frequency
% Elam = equally spaced retrieved spectrum
% dl = wavelength calibration for the wavlength axis
% lam0 = center wavelength

function [Ew,w_eq]=convert_retrieved_spectra(Elam,dl,lam0)
N=size(Elam,1);
lam=(-N/2:(N-1)/2)*dl+lam0;
Ew=zeros(size(Elam));
[seq1,w_eq]=equally_spaced_spectrum_w(lam,abs(Elam));
[phase1,w_eq]=equally_spaced_spectrum_w(lam,unwrap(angle(Elam)));
Ew=seq1.*exp(i*phase1);


