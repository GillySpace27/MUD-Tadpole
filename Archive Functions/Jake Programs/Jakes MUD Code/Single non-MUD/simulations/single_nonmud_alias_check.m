% this function simulates a angular dispersion experiment:
clear
clc;
c=300;
% The spatial dimension is:
Nx=1000; % 1 for 10ps temproal window, 2 for 5ps, 10 for 1ps
Nw=4000;
% The max/min value of x is +/-3.9mm
xmax=1.5e6;
xmin=-xmax;
dx=(xmax-xmin)/Nx;
x=[xmin:dx:xmax];
x_range=xmax-xmin;

%% The max/min value of the wavelength distribution is:
lam0=800;
rangel=100;
lmax=lam0+rangel/2;
lmin=lam0-rangel/2;
dl=(lmax-lmin)/(Nw);
lam=[-Nw/2*dl:dl:(Nw/2-1)*dl]+lam0;
w = equally_spaced_w(lam);
w_0=mean(w);
dw=abs(mean(diff(w)));
w_range=max(w)-min(w);

%% Making the grid:full
[xx,ww]=ndgrid(x,w);
% The wave numbers are:
kk=ww/c;
% The intial width of the pulse out of the oscillator is 6nm:
delta_l=5;
delta_w=2*pi*c/lam0^2*delta_l;
sigma_ref=10000*dx;
sigma_unk=10000*dx;


% the crossing angle is:
z1=4;
theta1=lam0/(z1*dx);

%% The added GDD is:
GDD=3e5;
% The reference pulses are generated:

% the pulse front tilt will be twice the value of the length of the unknown
% pulse
% the length of the unknown is:
%t_unk=sqrt(4*(1/delta_w^2+GDD^2*delta_w));
t_unk=10e3;
%gamma=t_unk/(xmax-xmin);
% the pulse front tilt so that there is no aliasing is:
theta2=.07;
gamma=4*(w_0-w_range/2)*theta1/(w_range*c);
gamma=.0034*4;

% the temporal spacing of each reference pulse is:
% the center of each reference pulse is:
Ref=(exp(-((xx)/(sqrt(2)*sigma_ref)).^2))...
        .*exp(-((ww-w_0)/(sqrt(2)*delta_w)).^2).*exp(i*gamma.*(ww-w_0).*xx);

    %% The unknown pulse is generated:
%  A single pulse
tau1=3000;
% Unk1=exp(-(xx/(sqrt(2)*sigma_unk)).^2).*exp(-((ww-w_0)/(sqrt(2)*delta_w)).^2).*(exp(0*i*tau1*(ww-w_0)));
% A triple Pulse:
%Unk1=exp(-(xx/(sqrt(2)*sigma_unk*dx)).^2).*exp(-((ww-w_0)/(sqrt(2)*delta_w)).^2).*(exp(i*(-6*tau1)*(ww-w_0))+exp(i*(-3*tau1)*(ww-w_0))+exp(i*(3*tau1)*(ww-w_0))+exp(i*(6*tau1)*(ww-w_0))).*exp(i*(ww-w_0).^2*GDD);
% A super chirped pulse:
Unk1=exp(-((xx)/(sqrt(2)*sigma_unk)).^2).*exp(-((ww-w_0)/(sqrt(2)*delta_w)).^2).*exp(i*(ww-w_0).^2*GDD);
% A super chirped pulse:
%Unk2=exp(-((xx)/(sqrt(2)*sigma_unk)).^2).*exp(-((ww-w_0)/(sqrt(2)*delta_w)).^2).*exp(i*(ww-w_0).^2*GDD).*exp(i*(ww-w_0)*tau1);
% A super chirped double pulse:
%Unk1=exp(-(xx/(sqrt(2)*sigma_unk*dx)).^2).*exp(-((ww-w_0)/(sqrt(2)*delta_w)).^2).*exp(-i*(ww-w_0).^2*GDD).*(exp(i*1*(ww-w_0)*tau1)+exp(-i*1*(ww-w_0)*tau1));
% A super chirped double pulse with cubic phase:
%Unk1=exp(-(xx/(sqrt(2)*sigma_unk*dx)).^2).*exp(-((ww-w_0)/(sqrt(2)*delta_w)).^2).*exp(-i*(ww-w_0).^2*GDD+i*(ww-w_0).^3*1e-40).*(exp(i*0*(ww-w_0)*tau)+exp(-i*.1*(ww-w_0)*tau));
% A super chirped pulse with spatial chirp:
%Unk1=exp(-(xx/(sqrt(2)*Nx*dx)).^2).*exp(-((ww-w_0)/(sqrt(2)*delta_w/2)).^2).*exp(-i*(tau)*(ww-w_0)*0).*exp(i*(ww-w_0).^2*GDD).*exp(-i*10e-10*xx.*(ww-w_0));
% a super chirped pulse with missing center frequencies:
%Unk1=exp(-(xx/(sqrt(2)*Nx*dx)).^2).*(exp(-((ww-(w_0-delta_w/2))/(sqrt(2)*delta_w/10)).^2)+exp(-((ww-(w_0+delta_w/2))/(sqrt(2)*delta_w/10)).^2)).*exp(-i*(ww-w_0).^2*GDD);
% Unk=Unk1.*(exp(-i*kk.*xx*.1));
Unk=Unk1.*(exp(-i*kk.*xx*theta1));
%Unk=(Unk1+Unk2).*(exp(-i*kk.*xx*.05));

%%
% The transfer function is:
H=exp(-((ww-w_0)/(sqrt(2)*1*dw)).^2);
H1=sum(H,2);
%H1='n';

%%
I1=abs(Ref+Unk).^2;
I0=abs(Unk).^2;
% if ischar(H1)==0
%     I1=ifftc(fftc(I1,[],2).*fftc(H,[],2),[],2);
%     I0=ifftc(fftc(I0,[],2).*fftc(H,[],2),[],2);
% end
% converting the image to equally spaced in wavelength:
[I0,lam1]=equally_spaced_spectrum_lam(w',I0');
[I2,lam1]=equally_spaced_spectrum_lam(w',I1');
[Ref,lam1]=equally_spaced_spectrum_lam(w',abs(Ref').^2);
%I2=I1;lam1=wtol(w);Ref=abs(Ref).^2;
I2=I2';
I0=I0';
Ref=Ref';

points=[Nx/2-Nx/z1,Nx/2];
dp=round(Nx/z1-20);
%points=[313,501];
[cut]=filter_snm(fftc(I1,[],2),points,dp);
% plotting that bad boy
[Ew,w_eq]=divide_spec(abs(Ref).^2,cut,lam);
% the total delay range is:
t_range=gamma*(xmax-xmin);
% the calibration is:
dt=round(t_range/(size(Ew,1)));
[Et,E_lam,t_f,lam_eq,amp,t1,Ew1]=filter_snm2_sim(I1,Ref,I0,points,dp,dl,dt,lam0);