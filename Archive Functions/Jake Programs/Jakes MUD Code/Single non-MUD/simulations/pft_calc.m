% this function calculates the maximum pulse front tilt for 
% that can be used in MUD TADPOLE
% dx = pixel size on camera array (nm)
% lam0 = center wavelength (nm)
% dlam = spectral range (nm)
% Nx = number of pixels along the spatial dimension

function [pft_max,TBP_max]=pft_calc(dlam,lam0,dx,Nx)
c=300;
theta = lam0/(8*dx);
pft_max=lam0/(2*dx*c)*(lam0./dlam-.5);
TBP_max=Nx/2*(1-dlam/(2*lam0));
% fprintf('\n The maximum pft is %g fs/nm',max(pft_max));
% fprintf('\n For my camera this means a total delay range of %g ps\n',Nx*max(pft_max)*dx*1e-3);
% fprintf('\n For my camera this means a max TBP of %g\n',TBP_max);