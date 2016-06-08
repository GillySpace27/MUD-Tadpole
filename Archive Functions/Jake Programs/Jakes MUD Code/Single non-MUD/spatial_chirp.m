% this function models spatial chirp:
c=300;
Nx=1000;
Nw=1000;
dx=1000*3.5e6;
x=(-Nx/2:Nx/2-1)*dx;
lam0=800-20;
lmax=850;
lmin=750+20;
dl=(lmax-lmin)/Nw;
lam=lmin:dl:lmax;
w=equally_spaced_w(lam);
w0=median(w);
[xx,ww]=meshgrid(x,w);
% making the pulse:
dlam=10;
dw=2*pi*c/lam0^2*dlam;
delx=20*dx;
Aw=exp(-((ww-w0)/(2*dw)).^2);
% the spatial chirp term is:
% the focal length of the lens is 100mm:
f=100e6;
% the groove density of the grating is:
d = 1e6/1200;
% the spatial chirp term is:
beta=2*pi*f./(ww.*sqrt((d*ww/c).^2-1));
beta=1e12;
sc=exp(-((beta.*(ww-w0)+xx)./(2*delx)).^2);
Ewx=Aw.*sc;
% plotting the results:
subplot(2,1,1);
imagesc(x*1e-6,lam,abs(Ewx));
xlabel('Position (mm)');
ylabel('Wavelength (nm)');
title('Spatial chirp measurement');
% plotting the temporal duration of the pulse:
t=wtot(w);
subplot(2,1,2);
Et=sum(abs(fftc(Ewx)),2);
plot(t,Norm(Et.^2));
xlabel('Time (fs)');
ylabel('Intensity');
title('Temporal profile');
