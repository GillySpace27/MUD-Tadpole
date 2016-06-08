% this function reclaibrates the frequency axis when I 
% input the wrong calibration when scanning;

% dl = valid calibration (nm)
% w_old = wrong frequency axis

function [w_new]=recal_freq_sea(dl,w_old,lam0)
N = length(w_old);
lam_new=lam_axis(dl,N,lam0);
% making the wavelength axis an equally spaced array:
w_new = equally_spaced_w(lam_new);