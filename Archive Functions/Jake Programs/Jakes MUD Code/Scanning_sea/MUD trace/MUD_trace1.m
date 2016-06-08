% this function plots the multi shot MUD tadpole trace for a 
% given set of MUD data:
% w_eq = equally spaced freq axis
% Ew = retrieved spectra
% tau = time delay 

function []=MUD_trace1(Ew,w_eq,tau,lam0,varargin)
c=300;
% making the spectra equally spaced:
Nt=size(Ew,2);
t=(1:Nt)*tau-Nt*tau/2;
% making the wavelength axis equally spaced:
lam=equally_spaced_lam(w_eq+2*pi*c/lam0);
imagesc(t*1e-3,lam,abs(Ew));
xlabel('Delay (ps)','fontsize',15);
ylabel('Wavelength (nm)','fontsize',15);
if nargin==4
    title('MUD trace','fontsize',15);
else
    title([varargin{1}],'fontsize',15);
end
set(gca,'fontsize',12);
set(gca,'box','on','linewidth',2.5)