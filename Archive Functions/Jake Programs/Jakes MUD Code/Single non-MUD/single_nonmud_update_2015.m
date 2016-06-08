% this function simulates a angular dispersion experiment:
clear
c=300;
% The spatial dimension is:
Nx=1000; % 1 for 10ps temproal window, 2 for 5ps, 10 for 1ps
Nw=500;
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
kk=w_0/c;
% The intial width of the pulse out of the oscillator is 6nm:
delta_l=2;
delta_w=2*pi*c/lam0^2*delta_l;
sigma_ref=10000*dx;
sigma_unk=10000*dx;

%% The added GDD is:
GDD=4e4/1000;
% The reference pulses are generated:

% the angular dispersion introduced by the grating is:
% the diffracted angle is:
beta1=10*pi/180;
% the incident angle is:
beta=0*pi/180;
% the ang disp is:
%gamma=ww*(sin(beta1)-sin(beta))/(c*cos(beta1)*2*pi);
gamma=w_0*(sin(beta1)-sin(beta))/(c*cos(beta1)*2*pi);
gamma=10*gamma;
% the temporal spacing of each reference pulse is:
% the center of each reference pulse is:
Ref=(exp(-((xx)/(sqrt(2)*sigma_ref)).^2))...
        .*exp(-((ww-w_0)/(sqrt(2)*delta_w)).^2).*exp(i*gamma.*(ww-w_0).*xx);

    %% The unknown pulse is generated:
%  A single pulse
tau1=0;
Unk1=exp(-(xx/(sqrt(2)*sigma_unk)).^2).*exp(-((ww-w_0)/(sqrt(2)*delta_w)).^2).*(exp(0*i*tau1*(ww-w_0)));
% A triple Pulse:
%Unk1=exp(-(xx/(sqrt(2)*sigma_unk*Nx*dx)).^2).*exp(-((ww-w_0)/(sqrt(2)*delta_w)).^2).*(exp(i*(-tau)*(ww-w_0))+exp(i*(0*tau)*(ww-w_0))+.5*exp(i*(-.2*tau)*(ww-w_0))+.5*exp(i*(-1.1*tau)*(ww-w_0))+.5*exp(i*(-1.2*tau)*(ww-w_0))+.5*exp(i*(-3.5*tau)*(ww-w_0))+.5*exp(i*(-2.5*tau)*(ww-w_0))).*exp(i*-.5*tau*(ww-w_0)).*exp(i*(ww-w_0).^2*GDD/1.5);
% A super chirped pulse:
%Unk1=exp(-((xx)/(sqrt(2)*sigma_unk)).^2).*exp(-((ww-w_0)/(sqrt(2)*delta_w)).^2).*exp(i*(ww-w_0).^2*GDD/2);
% A super chirped double pulse:
%Unk1=exp(-(xx/(sqrt(2)*sigma_unk*dx)).^2).*exp(-((ww-w_0)/(sqrt(2)*delta_w)).^2).*exp(-i*(ww-w_0).^2*GDD).*(exp(i*1*(ww-w_0)*tau1)+exp(-i*1*(ww-w_0)*tau1));
% A super chirped double pulse with cubic phase:
%Unk1=exp(-(xx/(sqrt(2)*sigma_unk*dx)).^2).*exp(-((ww-w_0)/(sqrt(2)*delta_w)).^2).*exp(-i*(ww-w_0).^2*GDD+i*(ww-w_0).^3*1e-40).*(exp(i*0*(ww-w_0)*tau)+exp(-i*.1*(ww-w_0)*tau));
% A super chirped pulse with spatial chirp:
%Unk1=exp(-(xx/(sqrt(2)*Nx*dx)).^2).*exp(-((ww-w_0)/(sqrt(2)*delta_w/2)).^2).*exp(-i*(tau)*(ww-w_0)*0).*exp(i*(ww-w_0).^2*GDD).*exp(-i*10e-10*xx.*(ww-w_0));
% a super chirped pulse with missing center frequencies:
%Unk1=exp(-(xx/(sqrt(2)*Nx*dx)).^2).*(exp(-((ww-(w_0-delta_w/2))/(sqrt(2)*delta_w/10)).^2)+exp(-((ww-(w_0+delta_w/2))/(sqrt(2)*delta_w/10)).^2)).*exp(-i*(ww-w_0).^2*GDD);
cross = 0.05;
Unk=Unk1.*(exp(-i*kk.*xx*cross));%.*exp(-1e-12*i*kk.*ww*p*d/f);%.*exp(0*-10e-12*i*xx.*ww).*exp(0*1e-4*i*ww.^3*GDD.^(3/2)).*exp(.1*i*kk.*xx.^2);

%%
% The transfer function is:
%H=exp(-((ww-w_0)/(sqrt(2)*5*dw)).^2);
% H=exp(-((ww-w_0)/(sqrt(2)*10000*dw)).^2);
% H1=sum(H,2);
H = ones(size(Ref));
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
min_1 = 0;
I2=I2'+min_1;
I0=I0'+min_1;
Ref=Ref'+min_1;
%% Retrieving the spectrogram

lam0=median(lam1);
% Retrieving the Unknown:
% finding the peaks:
%[x1, x2] = lclmax(norm1(sum(abs(fftc(I2-Ref-I0,[],2)),2)),30,.001);
fint_1d = norm1(sum(abs(fftc(I2,[],1)),2));
[y1,x1] = findpeaks(fint_1d,'MinPeakHeight',0.05);
points = x1;
%points=[x1(1),x1(2)];
dp=round(abs(x1(1)-x1(2))/2);
[cut]=filter_snm(fftc(I2-Ref-I0,[],1),points,dp);
% plotting that bad boy
[Ew,w_eq]=divide_spec(abs(Ref).^2,cut,lam1);
%%

% retrieving the pulse:
% after the calibration, I have determing the delay to be:
dt=58;
%[dt]=double_cal_mud(Ew,2*tau1);
[Et,E_lam,t_f,lam_eq,amp,t1]=best_concat2_mud(Ew',dt,w_eq,lam0);
% comparing teh results with what I expect to get:
% the expected spectrum is:
I_spec=sum(I0);
% the expected temporal profile is:
t2=wtot(w);
dt2=mean(abs(diff(t2)));


%% Plotting the interferogram
figure('Color','w');
subplot(2,2,[1,3]);
imagesc(lam,x*1e-6,I2-Ref-I0)
title('The interferogram')
xlabel('Wavelength');
ylabel('Position (mm)');
subplot(2,2,2);
imagesc((abs(fftc(I2-Ref-I0))))
title('The FFT of the interferogram')
xlabel('Wavelength');
ylabel('k-space');
subplot(2,2,4);
% plotting the spectrogram
imagesc(lam1,1:size(Ew,1),abs(Ew))
ylabel('Delay');
xlabel('Wavelength (nm)');
title('The retrieved spectrogram');

%% Comparing the unknown and the retrieved
figure('Color','w');
Et_expec=fftc(Unk1,[],2);
plot((t2+dt2*2)*1e-3,Norm(sum(abs(Et_expec))),'linewidth',2);
hold;
plot(t_f*1e-3,Norm(abs(Et)),'r','linewidth',2);
hold;
temp_plot1('Comparing the expected (blue) and retrieved (red)','Amplitude');
% plotting the spectrum:
figure('Color','w');
plot(lam_eq,Norm(abs(E_lam)),'r','linewidth',2);
hold;
% making the spectrum equally spaced in wavelength:
[Elam_expec,lam1]=equally_spaced_spectrum_lam(w,sum(abs(Unk1)));
h=plot(lam1+1.8,Norm(abs(Elam_expec)),'g','linewidth',2);
spec_plot1('Plotting the expected (blue) and the retrieved (red)',h);
hold;