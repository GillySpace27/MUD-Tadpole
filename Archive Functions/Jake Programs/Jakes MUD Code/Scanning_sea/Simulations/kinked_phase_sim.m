% The images are convolved, 1, or not, 0:
clear
% This funciton is to input the parameters for the simuations so that I can
% us my experimental retrieval alorightm:
c=300;
% The spatial dimension is:
Nw=300;
%% The max/min value of the wavelength distribution is:
lam0=800;
lmax=lam0+1*15;
lmin=lam0-1*15;
dl=(lmax-lmin)/(Nw);
lam=[-Nw/2*dl:dl:(Nw/2-1)*dl]+lam0;
w = fliplr(equally_spaced_w(lam));
%w=ltow(lam,'m/s');
w0=mean(w);
dw=abs(mean(diff(w)));

%% Making the grid:full
% The intial width of the pulse out of the oscillator is 6nm:
delta_l=4;
delta_w=2*pi*c/lam0^2*delta_l;

% Making the pulse
tau=1000;
beta=50000;
A=exp(-(w-w0).^2/(2*delta_w^2));
p1=exp(i*(w-w0).^2*beta);
A1=A.*p1;
p2=exp(i*((w-w0).^2*beta-(w-w0)*tau));
A2=A.*p2;
added_phase=exp(i*1e7);
% the e-field is:
Ew=A2+A1;
Ew=Ew.*added_phase;

% adding noise:
noise1=0*0.3;
Ew_n=Ew+noise1*rand(size(Ew))*max(max(abs(Ew)));
plot(real(fftc(Ew_n)))
