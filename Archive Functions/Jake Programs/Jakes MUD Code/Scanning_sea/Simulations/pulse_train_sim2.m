clear
% This funciton is to input the parameters for the simuations so that I can
% us my experimental retrieval alorightm:
c=300;
% The spatial dimension is:
Nw=300000;

%% The max/min value of the wavelength distribution is:
lam0=800;
rangel=100;
lmax=lam0+rangel/2;
lmin=lam0-rangel/2;
dl=(lmax-lmin)/(Nw);
lam=[-Nw/2*dl:dl:(Nw/2-1)*dl]+lam0;
w = equally_spaced_w(lam);
w0=mean(w);

bw=20;
%dw=2*pi*c/(lam0^2)*bw;
dw=dl2dw(bw,lam0);

chirp1=1000000;
Ew=exp(-(w-w0).^2./(2*dw^2)).*exp(i*(w-w0).^2*chirp1);
tau=425e3;
delta1=100;
Ew1=Ew;
Ew1=Ew+.9*Ew.*exp(i*(w-w0)*(tau+delta1)+i*10*pi/3)+.67*Ew.*exp(i*2*(w-w0)*(tau+2.4*delta1)+i*20*pi/6)+.41*Ew.*exp(i*3*(w-w0)*(tau+3.9*delta1));
% the temporal profile is:
Et=fftc(Ew1);
% the spectrum is:
[seq1,lam_eq]=equally_spaced_spectrum_lam(w,abs(Ew1));
[phase1,lam_eq]=equally_spaced_spectrum_lam(w,unwrap(angle(Ew1)));
Elam=seq1.*exp(i*phase1);
dl1=mean(abs(diff(lam_eq)));
t=wtot(w);
% the fwhm of the wavelength is:
fwhm_lam=fwhm(Norm(abs(Elam).^2),dl1)
% the fwhm of the time is:
fwhm_t_ps=fwhm(Norm(abs(Et).^2),mean(abs(diff(t))))*1e-3
subplot(2,1,1);
plot(lam_eq,abs(Elam).^2);
xlabel('Wavelength (nm)');
title('Spectrum');
subplot(2,1,2);
plotyy(t*1e-3,Norm(abs(Et).^2),t*1e-3,unwrap(angle(Et)));
title('Temporal profile');
xlabel('Time (ps)');