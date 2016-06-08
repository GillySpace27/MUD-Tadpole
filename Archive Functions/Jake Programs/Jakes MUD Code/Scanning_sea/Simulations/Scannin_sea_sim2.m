% This program simulates a temporal scanning SEA TADPOLE measurement:

% The images are convolved, 1, or not, 0:
clear
% This funciton is to input the parameters for the simuations so that I can
% us my experimental retrieval alorightm:
c=300;
% The spatial dimension is:
Nx=200; % 1 for 10ps temproal window, 2 for 5ps, 10 for 1ps
Nw=1000;
% The max/min value of x is +/-3.9mm
xmax=1.5e6;
xmin=-1.5e6;
dx=(xmax-xmin)/Nx;
x=[xmin:dx:xmax];

%% The max/min value of the wavelength distribution is:
lam0=800;
rangel=30;
lmax=lam0+rangel/2;
lmin=lam0-rangel/2;
dl=(lmax-lmin)/(Nw);
lam=[-Nw/2*dl:dl:(Nw/2-1)*dl]+lam0;
w = fliplr(equally_spaced_w(lam));
%w=ltow(lam,'m/s');
w_0=mean(w);
dw=abs(mean(diff(w)));

%% Making the grid:full
[xx,ww]=meshgrid(x,w);
tau1=1.5e3;
% The wave numbers are:
kk=ww/c;
% The pinhole separation is:
d=.5e6;
%The focal length of the collimating lens is:
f=100e6;
% The intial width of the pulse out of the oscillator is 6nm:
delta_l=3;
delta_w=2*pi*c/lam0^2*delta_l;
sigmax=200;
%% The added GDD is:
GDD=1e5;
% The reference pulses are generated:
Ref=(exp(-((xx)/(sqrt(2)*sigmax*dx)).^2)).*exp(-((ww-w_0)/(sqrt(2)*delta_w)).^2).*(exp(i*kk.*xx*d/f));
Ref1=abs(Ref).^2;

%% The unknown pulse is generated:
%  A single pulse
%Unk1=exp(-(xx/(sqrt(2)*Nx*sigmax*dx)).^2).*exp(-((ww-w_0)/(sqrt(2)*delta_w)).^2).*(exp(i*-tau*(ww-w_0)));
% A triple Pulse:
%Unk1=exp(-(xx/(sqrt(2)*sigmax*Nx*dx)).^2).*exp(-((ww-w_0)/(sqrt(2)*delta_w)).^2).*(exp(i*(-tau)*(ww-w_0))+exp(i*(0*tau)*(ww-w_0))+.5*exp(i*(-.2*tau)*(ww-w_0))+.5*exp(i*(-1.1*tau)*(ww-w_0))+.5*exp(i*(-1.2*tau)*(ww-w_0))+.5*exp(i*(-3.5*tau)*(ww-w_0))+.5*exp(i*(-2.5*tau)*(ww-w_0))).*exp(i*-.5*tau*(ww-w_0)).*exp(i*(ww-w_0).^2*GDD/1.5);
% A super chirped pulse:
Unk1=exp(-((xx)/(sqrt(2)*sigmax*dx)).^2).*exp(-((ww-w_0)/(sqrt(2)*delta_w)).^2).*exp(i*(ww-w_0).^2*GDD);
% A super chirped double pulse:
%Unk1=exp(-(xx/(sqrt(2)*sigmax*dx)).^2).*exp(-((ww-w_0)/(sqrt(2)*delta_w)).^2).*exp(-i*(ww-w_0).^2*GDD).*(exp(i*0*(ww-w_0)*tau)+exp(-i*1*(ww-w_0)*tau));
% A super chirped double pulse with cubic phase:
%Unk1=exp(-(xx/(sqrt(2)*sigmax*dx)).^2).*exp(-((ww-w_0)/(sqrt(2)*delta_w)).^2).*exp(-i*(ww-w_0).^2*GDD+i*(ww-w_0).^3*1e-40).*(exp(i*0*(ww-w_0)*tau)+exp(-i*.1*(ww-w_0)*tau));
% A super chirped pulse with spatial chirp:
%Unk1=exp(-(xx/(sqrt(2)*Nx*dx)).^2).*exp(-((ww-w_0)/(sqrt(2)*delta_w/2)).^2).*exp(-i*(tau)*(ww-w_0)*0).*exp(i*(ww-w_0).^2*GDD).*exp(-i*10e-10*xx.*(ww-w_0));
% a super chirped pulse with missing center frequencies:
%Unk1=exp(-(xx/(sqrt(2)*Nx*dx)).^2).*(exp(-((ww-(w_0-delta_w/2))/(sqrt(2)*delta_w/10)).^2)+exp(-((ww-(w_0+delta_w/2))/(sqrt(2)*delta_w/10)).^2)).*exp(-i*(ww-w_0).^2*GDD);
Unk=Unk1.*(exp(-i*kk.*xx*d/f));%.*exp(-1e-12*i*kk.*ww*p*d/f);%.*exp(0*-10e-12*i*xx.*ww).*exp(0*1e-4*i*ww.^3*GDD.^(3/2)).*exp(.1*i*kk.*xx.^2);
U0=sum(Unk1,2);
% the reference pulse separation is:
tau=.5e3;
N=30;
% changing from freq to lambda axis:
% The transfer function is:
H=exp(-((ww-w_0)/(sqrt(2)*2*dw)).^2);
H1=sum(H,2);
H1='n';
delay=0;
if ischar(H1)==0
    Ref1=ifftc(fftc(Ref1,[],1).*fftc(H,[],1),[],1);
end

for k=1:N
    t1(k)=-tau*(k-N/2);
    Refk=Ref.*exp(i*(ww-w_0)*t1(k));
    I1=abs(Refk+Unk).^2;
    if ischar(H1)==0
        I1=ifftc(fftc(I1,[],1).*fftc(H,[],1),[],1);
        U0 = ifftc(fftc(abs(Unk).^2,[],1).*fftc(H,[],1),[],1); 
    end
    [phi,spectrum]= find_phi_jake(rot90(I1),rot90((Ref1)));
    Ew(:,k)=sqrt(spectrum).*exp(i*phi);
    Rt(:,k)=sum(abs(fftc(Refk)),2);
    if k==floor(N/4)
        T1(:,:,1)=I1;
        num(1)=k;
    elseif k==floor(N/2)
        T1(:,:,2)=I1;
        num(2)=k;
    elseif k==floor(3*N/4)
        T1(:,:,3)=I1;
        num(3)=k;
    end
end
% figure
Ut=sum(abs(fftc(Unk1)),2).*exp(i*sum(unwrap(angle(fftc(Unk1))),2));
% plot4yy(t*1e-3,Norm(abs(Ut).^2),unwrap(angle(Ut)),'Temporal profile','time');
% % figure;
% plot(t*1e-3,sum(abs(fftc(H)),2))
% xlabel('Time (ps)');
% title('The temporal response function');
% Doing the MUD TADPOLE algorithm:
tau=abs(tau);
break
[U1,C1,E_lam,t_f,w_f,lam_eq]=concat_sea4_no_end(flipud(Ew),tau,w,lam0,'n');
figure
plot(t_f*1e-3-.7,fliplr(Norm(abs(C1).^2)),'r')
temp_plot1('Comparison of the expected and retrieved temporal profile','Intensity');
% 
% % plot(abs(U1))
% % % comparing the expected and retrieved:
figure
plot(lam_eq,Norm(abs(E_lam).^2),'.');
hold;
plot(lam*1e9,Norm(sum(abs(U0),2)),'r')
hold;
xlabel('Wavelength (nm)');
ylabel('Intensity');
% title('Comparing the expected (red), and retrieved (blue)');
% % % [phase,amp]=Nan_value(phase1,abs(U1));
% % % amp=nmlz_set(amp);