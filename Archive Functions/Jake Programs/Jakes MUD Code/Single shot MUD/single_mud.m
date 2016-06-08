% This program simulates a single shot MUD TADPOLE measurement:

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
rangel=78;
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
delta_l=10;
delta_w=2*pi*c/lam0^2*delta_l;
sigma_ref=40*dx;
sigmax=(xmax-xmin);
%% The added GDD is:
GDD=2e4;
% The reference pulses are generated:
% the number of reference pulses is:
N=4;
% the spatial separation of neighboring ref pulses is:
deltax=round(Nx/(N+1))*dx;
Ref=0;
% the temporal spacing of each reference pulse is:
tau=1e3;
for k=1:N
    % the center of each reference pulse is:
    x0=xmin+k*deltax;
    % the delay of each reference pulse is:
    %tau_ref(:,k)=(-(N-(1+isodd(N)))/2+k-1)*tau;
    tau_ref(:,k)=(-(N-(1+mod(N,2)))/2+k-1)*tau;
    Ref=Ref+(exp(-((xx-x0)/(sqrt(2)*sigma_ref)).^2))...
        .*exp(-((ww-w_0)/(sqrt(2)*delta_w)).^2).*(exp(i*(ww-w_0)*(tau_ref(:,k))));
    if k==1
        Ref1=sum(abs(Ref).^2,1);
    end
end
%% The unknown pulse is generated:
%  A single pulse
tau1=0;
%Unk1=exp(-(xx/(sqrt(2)*Nx*sigmax*dx)).^2).*exp(-((ww-w_0)/(sqrt(2)*delta_w)).^2).*(exp(0*i*tau1*(ww-w_0)));
% A triple Pulse:
%Unk1=exp(-(xx/(sqrt(2)*sigmax*Nx*dx)).^2).*exp(-((ww-w_0)/(sqrt(2)*delta_w)).^2).*(exp(i*(-tau)*(ww-w_0))+exp(i*(0*tau)*(ww-w_0))+.5*exp(i*(-.2*tau)*(ww-w_0))+.5*exp(i*(-1.1*tau)*(ww-w_0))+.5*exp(i*(-1.2*tau)*(ww-w_0))+.5*exp(i*(-3.5*tau)*(ww-w_0))+.5*exp(i*(-2.5*tau)*(ww-w_0))).*exp(i*-.5*tau*(ww-w_0)).*exp(i*(ww-w_0).^2*GDD/1.5);
% A super chirped pulse:
Unk1=exp(-((xx)/(sqrt(2)*sigmax)).^2).*exp(-((ww-w_0)/(sqrt(2)*delta_w)).^2).*exp(i*(ww-w_0).^2*GDD/2);
% A super chirped double pulse:
%Unk1=exp(-(xx/(sqrt(2)*sigmax*dx)).^2).*exp(-((ww-w_0)/(sqrt(2)*delta_w)).^2).*exp(-i*(ww-w_0).^2*GDD).*(exp(i*0*(ww-w_0)*tau)+exp(-i*1*(ww-w_0)*tau));
% A super chirped double pulse with cubic phase:
%Unk1=exp(-(xx/(sqrt(2)*sigmax*dx)).^2).*exp(-((ww-w_0)/(sqrt(2)*delta_w)).^2).*exp(-i*(ww-w_0).^2*GDD+i*(ww-w_0).^3*1e-40).*(exp(i*0*(ww-w_0)*tau)+exp(-i*.1*(ww-w_0)*tau));
% A super chirped pulse with spatial chirp:
%Unk1=exp(-(xx/(sqrt(2)*Nx*dx)).^2).*exp(-((ww-w_0)/(sqrt(2)*delta_w/2)).^2).*exp(-i*(tau)*(ww-w_0)*0).*exp(i*(ww-w_0).^2*GDD).*exp(-i*10e-10*xx.*(ww-w_0));
% a super chirped pulse with missing center frequencies:
%Unk1=exp(-(xx/(sqrt(2)*Nx*dx)).^2).*(exp(-((ww-(w_0-delta_w/2))/(sqrt(2)*delta_w/10)).^2)+exp(-((ww-(w_0+delta_w/2))/(sqrt(2)*delta_w/10)).^2)).*exp(-i*(ww-w_0).^2*GDD);
Unk=Unk1.*(exp(-i*kk.*xx*.05));%.*exp(-1e-12*i*kk.*ww*p*d/f);%.*exp(0*-10e-12*i*xx.*ww).*exp(0*1e-4*i*ww.^3*GDD.^(3/2)).*exp(.1*i*kk.*xx.^2);
U0=sum(Unk1,2);
% The transfer function is:
H=exp(-((ww-w_0)/(sqrt(2)*10*dw)).^2);
H1=sum(H,2);
H1='n';
if ischar(H1)==0
    Ref1=ifftc(fftc(Ref1,[],1).*fftc(H,[],1),[],1);
end
I1=abs(Ref+Unk).^2;
% converting the image to equally spaced in wavelength:
[I2,lam]=convert_retrieved_spectra_w(I1',w');
[Ref,lam]=convert_retrieved_spectra_w(abs(Ref).^2',w');
I2=I2';
Ref=Ref';
dl=mean(abs(diff(lam)));
lam0=median(lam);
imagesc(I2)
break
% if ischar(H1)==0
%     I1=ifftc(fftc(I1,[],1).*fftc(H,[],1),[],1);
%     U0 = ifftc(fftc(abs(Unk).^2,[],1).*fftc(H,[],1),[],1);
% end

% adding noise:
% noise1=0;
% I1=I1+noise1*rand(size(I1))*max(max(abs(I1)));
% Ref1=Ref1+noise1*rand(size(Ref1))*max(max(abs(Ref1)));


% plotting the spectrum of the unknown pulse:
Uw=sum(abs(Unk1).^2,2).*exp(i*(sum(unwrap(angle(Unk1)),2)));
%subplot(2,1,1);
