% this program simulates two heavily chirped pulses interfering with each
% other in time:
clear
c=300;
Nl=8000;
trange=120e3;
dt=trange/Nl;
t=-trange/2:dt:trange/2-dt;

% delt=6.5 ps
del_t=12.5e3;
% the time axis is:
tau0=17.1e3;

A=exp(-(t-tau0).^2/(2*del_t^2));
% the chirp value is
beta=.0000004;
% the time delay is 1ps:

c1=(.5);
A1=A.*exp(i*(t-tau0).^2*beta);
% the delayed pulse is:
tau2=6e3;
A2=c1*exp(-(t-tau2).^2/(2*del_t^2)).*exp(i*(t-tau2).^2*beta);

% the signal is:
Et=A1+A2;
% the measured intensity is:
Im=Norm(abs(Et).^2);
[I2]=Norm(sub_bg3(Im,0));

% plotting the chirped pulse:
plot6yy(t*1e-3-1.8,I2,unwrap(angle(Et))+1650+t*.006,'time');
[width_t]=fwhm(Im,mean(abs(diff(t))))

