% this function recalibrates the retrieved spectrum in wavelength
% to make it evenly spaced in anglular frequency
% spectrum = evenly spaced spectrum
% lam = evenly spaced wavelength axis (nm)

function [seq,w_eq]=equally_spaced_spectrum_w(lam,spectrum)
c=300;
w=2*pi*c./lam;
w_eq = equally_spaced_w(lam);
seq =interp1(w, spectrum, w_eq, 'PCHIP');
% cutting off some inf terms
% seq=seq(5:end-5);
% w_eq=w_eq(5:end-5);
% 
