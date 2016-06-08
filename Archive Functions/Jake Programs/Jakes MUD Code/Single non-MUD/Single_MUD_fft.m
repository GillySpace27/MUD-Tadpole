% this function plots the multi shot MUD tadpole trace for a 
% given set of MUD data:
% dx = pixel size (mm)
% I1 = retrieved trace
% dl = wavelength calibration (nm)
% lam0 = center wavelength

function []=Single_MUD_fft(I1,dl,dx,lam0)
Nl=size(I1,2);
Nx=size(I1,1);
x=(-Nx/2:Nx/2-1)*dx;
k1=1./x;
lam=(-Nl/2:Nl/2-1)*dl+lam0;
% making the figure
figure('Color','w');
imagesc(lam,k1,I1);
ylabel('k-space (mm^{-1})','fontsize',16);
xlabel('Wavelength (nm)','fontsize',16);
if nargin==4
    title('FFT of the interferogram','fontsize',16);
else
    title([varargin{1}],'fontsize',16);
end
set(gca,'fontsize',16);
set(gca,'box','on','linewidth',2.5)
colormap('jet');
colorbar('box','on','linewidth',2.5,'fontsize',16);
