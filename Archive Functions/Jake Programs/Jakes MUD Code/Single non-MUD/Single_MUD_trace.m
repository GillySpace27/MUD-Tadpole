% this function plots the multi shot MUD tadpole trace for a 
% given set of MUD data:
% dx = pixel size (mm)
% I1 = retrieved trace
% dl = wavelength calibration (nm)
% lam0 = center wavelength

function []=Single_MUD_trace(I1,dl,dx,lam0)
Nl=size(I1,2);
Nx=size(I1,1);
x=(-Nx/2:Nx/2-1)*dx;
lam=(-Nl/2:Nl/2-1)*dl+lam0;
% making the figure
figure('Color','w');
imagesc(lam,x,I1);
ylabel('Position (mm)','fontsize',16);
xlabel('Wavelength (nm)','fontsize',16);
if nargin==4
    title('MUD TADPOLE trace','fontsize',16);
else
    title([varargin{1}],'fontsize',16);
end
set(gca,'fontsize',16);
set(gca,'box','on','linewidth',2.5)
colormap('jet');
colorbar('box','on','linewidth',2.5,'fontsize',16);
