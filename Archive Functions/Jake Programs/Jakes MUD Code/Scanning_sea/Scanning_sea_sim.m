% This program simulates a temporal scanning SEA TADPOLE measurement:

% The images are convolved, 1, or not, 0:
clear
% This funciton is to input the parameters for the simuations so that I can
% us my experimental retrieval alorightm:
c=3e8;
% The spatial dimension is:
Nx=200; % 1 for 10ps temproal window, 2 for 5ps, 10 for 1ps
Nw=200;
% The max/min value of x is +/-3.9mm
xmax=3.9e-3;
xmin=-3.9e-3;
dx=(xmax-xmin)/Nx;
x=[xmin:dx:xmax];
%% The max/min value of the wavelength distribution is:
% lmax=800e-9+30e-9;
% lmin=800e-9-30e-9;
% dl=(lmax-lmin)/(Nw);
l_0=790e-9;
dl=.75e-9;
lam=[-Nw/2*dl:dl:(Nw/2-1)*dl]+l_0;

w=ltow(lam,'m/s');
w_0=median(w);
dw=abs(mean(diff(w)));

%% Making the grid:full
[xx,ww]=meshgrid(x,w);
% The wave numbers are:
kk=ww/c;
%kk=w_0/c;
% The width of the temporal response function is:
T_res=1/dw;
% The width of the spatial response function is:
x_res=.5*dx;
% The pinhole separation is:
d=.5e-3;
%The focal length of the collimating lens is:
f=250e-3;
% The intial width of the pulse out of the oscillator is 6nm:
delta_l=20e-9;
delta_w=2*pi*c/l_0^2*delta_l;
sigmax=200;
%% The added GDD is:
GDD=0*5e2*1e-30;
%GDD=gdn(800e-9,'SF11',1.8e-2,2);
% The reference pulses are generated:
Ref=(exp(-((xx)/(sqrt(2)*sigmax*dx)).^2)).*exp(-((ww-w_0)/(sqrt(2)*delta_w)).^2).*(exp(i*kk.*xx*d/f));
Ref1=sum(abs(Ref).^2,2);

%% The unknown pulse is generated:
%  A single pulse
%Unk1=exp(-(xx/(sqrt(2)*Nx*sigmax*dx)).^2).*exp(-((ww-w_0)/(sqrt(2)*delta_w)).^2).*(exp(i*-tau*(ww-w_0)));
% A triple Pulse:
%Unk1=exp(-(xx/(sqrt(2)*sigmax*Nx*dx)).^2).*exp(-((ww-w_0)/(sqrt(2)*delta_w)).^2).*(exp(i*(-tau)*(ww-w_0))+exp(i*(0*tau)*(ww-w_0))+.5*exp(i*(-.2*tau)*(ww-w_0))+.5*exp(i*(-1.1*tau)*(ww-w_0))+.5*exp(i*(-1.2*tau)*(ww-w_0))+.5*exp(i*(-3.5*tau)*(ww-w_0))+.5*exp(i*(-2.5*tau)*(ww-w_0))).*exp(i*-.5*tau*(ww-w_0)).*exp(i*(ww-w_0).^2*GDD/1.5);
% A super chirped pulse:
Unk1=exp(-((xx)/(sqrt(2)*sigmax*dx)).^2).*exp(-((ww-w_0)/(sqrt(2)*delta_w)).^2).*exp(i*(ww-w_0).^2*GDD);
% A super chirped double pulse:
%Unk1=exp(-(xx/(sqrt(2)*sigmax*Nx*dx)).^2).*exp(-((ww-w_0)/(sqrt(2)*delta_w)).^2).*exp(-i*(ww-w_0).^2*GDD).*(exp(i*-.75*(ww-w_0)*tau)+exp(-i*1.25*(ww-w_0)*tau));
% A super chirped pulse with spatial chirp:
%Unk1=exp(-(xx/(sqrt(2)*Nx*dx)).^2).*exp(-((ww-w_0)/(sqrt(2)*delta_w/2)).^2).*exp(-i*(tau)*(ww-w_0)*0).*exp(i*(ww-w_0).^2*GDD).*exp(-i*10e-10*xx.*(ww-w_0));
% a super chirped pulse with missing center frequencies:
%Unk1=exp(-(xx/(sqrt(2)*Nx*dx)).^2).*(exp(-((ww-(w_0-delta_w/2))/(sqrt(2)*delta_w/10)).^2)+exp(-((ww-(w_0+delta_w/2))/(sqrt(2)*delta_w/10)).^2)).*exp(-i*(ww-w_0).^2*GDD);
Unk=Unk1.*(exp(-i*kk.*xx*d/f));%.*exp(-1e-12*i*kk.*ww*p*d/f);%.*exp(0*-10e-12*i*xx.*ww).*exp(0*1e-4*i*ww.^3*GDD.^(3/2)).*exp(.1*i*kk.*xx.^2);
tau=100e-12;
N=3;
for k=1:N
    t1(k)=tau*(k-1-N/2);
    I1=abs(Ref+Unk.*exp(i*t1(k)*(ww-w_0))).^2;
    Fint=nmlz(sum(abs(fftc(I1,[],2))));
    [pks,h] = smart_lclmax(Fint,3);
    [Unk2(:,k),Unk_of_t(:,k),w2,t,AC(:,k)]=Sea_tad(I1,Ref1,pks(1),w);
end
%[U1]=temp_filter_SEA(Unk_of_t,tau,lam);
[U1]=add_phase_delay(Unk2,tau,w2);
Ret=sum(fftc(U1),2);



% Hn=1;
% if Hn==1
%  Htk(1:size(Ref,1),1:size(Ref,2))=1;
%  Hwx=fftshift(fft2(Htk));
%  %Hw=abs(fftc(H,[],1));
% %[H]=temp_resp(H,lam,2*tau);
% else
%     % The spectral response function is generated:
%      Hw=exp(-((ww-w_0)/(sqrt(2)*(1/(T_res*1)))).^2);
%      Hw=sinc((ww-w_0));%/(120/(T_res)));
%      Hwx=exp(-((ww-w_0)/(sqrt(2)*(1/(T_res)))).^2).*exp(-(xx/(sqrt(2)*x_res)).^2);
%      % a sum of gaussians:
%      %Hwx=exp(-(xx/(sqrt(2)*x_res)).^2).*(.5*exp(-((ww-w_0)/(sqrt(2)*(1/(T_res)))).^2)+exp(-((ww-w_0)/(sqrt(2)/(T_res/5))).^2));
%      %H=fftc(Hw,[],1);
% end
% 
