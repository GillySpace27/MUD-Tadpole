% this function performs the filtering and concatenation 
% for the single shot MUD 
% points = the k-space point of the AC term and the center DC term
% I1 = the 2-D interferogram
% Ref = the 2-D reference spectrum
% bg = the unknown 2-D spectrum
% lam0 = center wavelength (nm)
% dl = wavelength calibration
% dtau = delay calibration

function [Et,E_lam,t_f,lam_eq,amp,t1,Ew]=filter_snm2_sim(I1,Ref,bg,points,dp,dl,dtau,lam0)

% first the interferogram is filtered:
[cut1]=filter_snm(fftc(I1-Ref-bg),points,dp);
% the wavelength axis is made:
Nlam=size(cut1,2);
lam=lam_axis(dl,Nlam,lam0);
% the reference spectrum is divided out
[Unk1,w]=divide_spec(Ref,cut1,lam);
% taking out the inf terms
x=0;
Ew=Unk1(:,[1:end-x]);
w=w(1:end-x);
% concatenating the results:
[Et,E_lam,t_f,lam_eq,amp,t1]=best_concat2_mud(Ew',dtau,w,lam0);
