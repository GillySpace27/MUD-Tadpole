% this program simulates two heavily chirped pulses interfering with each
% other in time:
clear
c=300;
Nl=8000;
lmax=850;
lmin=750;

dl=(lmax-lmin)/Nl;
lam=lmin:dl:lmax;
w=equally_spaced_w(lam);
w0=median(w);
lam0=804.5;
dw=abs(mean(diff(w)));
dlam=1.4;
%Elam=exp(-(lam-lam0).^2/(2*dlam^2));
bw=2*pi*c/(lam0^2)*dlam;
% the time axis is:
t=wtot(w);
% the chirp value is
beta=100000;
% the added third order phase is:
gamma=0*1000000;
% the added fourth order phase is:
delta=0*100000000;
% the added 5th order phase is:
five_od=0*100000000;
% the time delay is 1ps:
tau=5070;
% making the pulses:
A=exp(-(w-w0).^2/(2*bw^2));
A1=A.*exp(i*(w-w0).^2*beta).*exp(i*(w-w0).^3*gamma).*exp(i*(w-w0).^4*delta).*exp(i*(w-w0).^5*five_od).*exp(i*(w-w0)*tau/2);
A2=A1.*exp(-i*(w-w0)*tau);
A3=0*A.*exp(i*(w-w0)*tau/4).*exp(i*(w-w0).^2*beta/2);
% the signal is:
Ew=A1+A2+A3;
Et=fftc(Ew);
% figure;
% % plotting the initial pulse:
% plot(t,Norm(abs(fftc(abs(A1))).^2))
% xlabel('Time (fs)','fontsize',15);
% ylabel('Intensity','fontsize',15);
% title('Temporal profile of the initial pulse before the compressor','fontsize',15);
% figure;
% % plotting the spectrum:
% plot(lam,Norm(abs(A1).^2));
% xlabel('Wavelength (fnm)','fontsize',15);
% ylabel('Intensity','fontsize',15);
% title('Spectrum of the initial pulse before the compressor','fontsize',15);
% 
plot(lam,abs(Ew).^2);
title('The spectrum');
xlabel('Wavelength (nm)');
% plot(lam,abs(Ew).^2);
% xlabel('Wavelength (nm)','fontsize',15);
% ylabel('Intensity','fontsize',15);
% title('Spectrum of a 50 ps chirped double pulse','fontsize',15);
%plot4yy(t*1e-3,abs(Et).^2,unwrap(angle(Et))-800,'The temporal profile of a 50 ps chirped double pulse','time');
%plot(abs(fftc(abs(Ew).^2)))
% It=abs(fftc(Ew)).^2;
% plotyy(t,It,t,unwrap(angle(It)))
% xlabel('Time (fs)');
% title('Temporal profile')
fwhm(abs(Et).^2,mean(abs(diff(t))))

