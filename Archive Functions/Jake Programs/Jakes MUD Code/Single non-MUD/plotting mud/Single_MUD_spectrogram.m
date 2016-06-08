% this function plots the multi shot MUD tadpole trace for a 
% given set of MUD data:
% w = equally spaced freq axis
% Ew = retrieved spectra
% tau = time delay axis
% lam0 = center wavelength

function []=Single_MUD_spectrogram(Ew,w,tau,varargin)
c=300;

% converting the retrieved spectrum into equally spaced wavelength:
[Elam,lam]=equally_spaced_spectrum_lam(w,abs(Ew)');
% making the figure
figure('Color','w');
% getting rid of the infinite values:
Eplot=log(abs(Elam)).*isfinite(log(abs(Elam)));
imagesc(tau*1e-3,lam,Eplot);
xlabel('Delay (ps)','fontsize',16);
ylabel('Wavelength (nm)','fontsize',16);
if nargin==3
    title('MUD TADPOLE spectrogram (log scale)','fontsize',16);
else
    title([varargin{1}],'fontsize',16);
end
set(gca,'fontsize',16);
set(gca,'box','on','linewidth',2.5)
colormap('jet');
colorbar('box','on','linewidth',2.5,'fontsize',16);
