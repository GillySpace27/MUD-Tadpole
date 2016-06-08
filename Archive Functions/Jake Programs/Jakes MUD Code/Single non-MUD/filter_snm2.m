% this function performs the filtering and concatenation 
% for the single shot MUD 
% points = the k-space point of the AC term and the center DC term
% I1 = the 2-D interferogram
% Ref = the 2-D reference spectrum
% bg = the unknown 2-D spectrum
% lam0 = center wavelength (nm)
% dl = wavelength calibration
% dtau = delay calibration

function [Et,E_lam,t_f,lam_eq,amp,t1]=filter_snm2(I1,Ref,bg,points,dp,dl,tau_total,lam0,varargin)

% first the interferogram is filtered:
[cut1]=filter_snm(fftc(I1-Ref-bg),points,dp);
%[cut1]=filter_snm(fftc(I1),points,dp);
% the delay axis is generated:
Ntau=size(cut1,1);
dtau=floor(tau_total/Ntau);
tau=(-Ntau/2:Ntau/2-1)*dtau;
% the wavelength axis is made:
Nlam=size(cut1,2);
lam=lam_axis(dl,Nlam,lam0);
% the reference spectrum is divided out
[Unk1,w]=divide_spec(Ref,cut1,lam);
% taking out the inf terms
x=100;
Ew=Unk1(:,[1:end-x]);
w=w(1:end-x);
% fourier filtering:
x_c1=950;
x_c2=1350;
x2=1;
ymax=.1;
% plotting the traces:
% the retreived spectrogram:
[Ew1,w1]=sub_bg2(Ew',x_c1,x_c2,w,x2,ymax);
% subtracting off the reference phase:
if nargin==9
    frog_data=varargin{1};
    [Ew1]=phase_tadpole(frog_data,w1,Ew1);
end
% concatenating the results:
[Et,E_lam,t_f,lam_eq,amp,t1]=best_concat2_mud((Ew1),dtau,w1,lam0);
plot_single_mud;