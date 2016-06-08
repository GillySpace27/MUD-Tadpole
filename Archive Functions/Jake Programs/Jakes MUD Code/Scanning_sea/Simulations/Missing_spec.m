

c=300;
% making the wavelength axis
N=20000;
lam0=800;
range=100;
lmax=lam0+range/2;
lmin=lam0-range/2;
dl=range/N;
lam=[lmin:dl:lmax];
w=equally_spaced_w(lam);
w0=median(w);

% the bandwidth
band=10;
bw=2*pi*c/lam0^2*band;

% the e-field is:
Ew=exp(-((w-w0)/(2*bw)).^2);
a=.000005;
delta1=exp(-(w-w0).^2/(2*a)^2);

Etot=Ew-delta1;
% making the spectrum equally spaced:
[seq1,lam_eq]=equally_spaced_spectrum_lam(w,abs(Etot));
[phase1,lam_eq]=equally_spaced_spectrum_lam(w,unwrap(angle(Etot)));
Elam=seq1.*exp(i*phase1);
% plotting the result:
x1=10;
lam1=lam_eq(x1:end-x1);
Elam1=Elam(x1:end-x1);
subplot(2,1,1);
plot(lam1,abs(Elam1).^2);
xlabel('Wavelength (nm)');
title('Spectrum');
subplot(2,1,2);
t=wtot(w);
plot(t*1e-3,abs(fftc(Etot)).^2);
xlabel('Time (ps)');
title('Temporal profile');
