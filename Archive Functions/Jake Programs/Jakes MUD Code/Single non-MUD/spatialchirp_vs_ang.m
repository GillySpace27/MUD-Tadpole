% this function simulates a angular dispersion experiment:
close all
clear
c=300;
% The spatial dimension is:
Nx=1000; % 1 for 10ps temproal window, 2 for 5ps, 10 for 1ps
Nw=1000;
% The max/min value of x is +/-3.9mm
xmax=1.5e6;
xmin=-1.5e6;
dx=(xmax-xmin)/Nx;
x=[xmin:dx:xmax];
%% The max/min value of the wavelength distribution is:
lam0=800;
rangel=38;
lmax=lam0+rangel/2;
lmin=lam0-rangel/2;
dl=(lmax-lmin)/(Nw);
lam=[-Nw/2*dl:dl:(Nw/2-1)*dl]+lam0;
w = equally_spaced_w(lam);
w_0=mean(w);
dw=abs(mean(diff(w)));

%% Making the grid:full
[xx,ww]=ndgrid(x,w);
% The wave numbers are:
kk=ww/c;
% The intial width of the pulse out of the oscillator is 6nm:
delta_l=5;
delta_w=2*pi*c/lam0^2*delta_l;
sigma_ref=400*dx;
sigmax=(xmax-xmin);
%% The added GDD is:
GDD=2e4;
% The reference pulses are generated:
% the spatial separation of neighboring ref pulses is:
% the angular dispersion introduced by the grating is:

% the groove spacing is:
d = 1e6/12;
% the diffracted angle is:
beta1=70*pi/180;
% the incident angle is:
beta=0*pi/180;
% the ang disp is:
gamma=(sin(beta1)-sin(beta))./(c*cos(beta1)*ww)*2*pi;
% or calulated from k-matrices:
gamma=(2*pi)./(ww.*sqrt((d*ww/(2*pi*c)).^2-1));
% the spatial chirp is:
% the focal length of the lens is:
f = 300e6;
spat_c=gamma*f;
% the temporal spacing of each reference pulse is:
% the center of each reference pulse is:
Ref_b=exp(-((xx)/(sqrt(2)*sigma_ref)).^2)...
        .*exp(-((ww-w_0)/(sqrt(2)*delta_w)).^2);
Ref_a=Ref_b.*exp(i*gamma.*(ww-w_0).*xx);
% a pulse with spatial chirp is:
Ref_c = Ref_b.*exp(spat_c.*(ww-w_0).*xx);
% the pulse length in time after the grating is:
Et_ang=sum(abs(fftc(Ref_a,[],2)));
% the pulse length in time before the grating is:
Et_before=sum(abs(fftc(Ref_b,[],2)));
% plotting the pulse width in time:
subplot(4,1,1)
plot(lam,Norm(sum(abs(Ref_b))).^2)
xlabel('Wavelength (nm)');
title('Input spectrum');
ylabel('Intensity');
t=wtot(w);
subplot(4,1,2)
imagesc(t*1e-3,x,abs(fftc(Ref_a,[],2)))
title('Time vs. position');
xlabel('Time (ps)');
ylabel('Position (mm)');
subplot(4,1,3);
plot(t*1e-3,Norm(Et_ang).^2);
hold;
%plot(t,Norm(Et_before).^2,'r');
title('The pulse in time before the grating (red) and after (blue)');
xlabel('Time (ps)');
ylabel('Intensity');
figure
imagesc(lam,x,abs(Ref_c))
title('Wavelength vs. position for the spatial chirp case');
xlabel('Wavelength (nm)');
ylabel('Position (mm)');
