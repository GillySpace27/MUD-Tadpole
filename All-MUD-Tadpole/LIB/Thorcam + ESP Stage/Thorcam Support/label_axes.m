function [lam, x] = label_axes( cam, dl, lowestLambda, xsize)
% Generates the wavelength and spacial axes, off of which everything is based.

img = snap_thorcam(cam);

%Find dimensions of the traces.
Nx = size(img,1);
Nw = size(img,2);

%Generate Lam axis
highestLambda = lowestLambda + dl*(Nw-1);
lam = lowestLambda:dl:highestLambda;

%Generate X axis
x = linspace(-xsize/2,xsize/2, Nx);

end

%% Might want to try this as another option for getting lam
% lam0=800; %Center wavelength
% rangel=60; %Range of distribution
% 
%     lmax=lam0+rangel/2;
%     lmin=lam0-rangel/2;
%     dl=(lmax-lmin)/(Nw);
%     lam=[-Nw/2*dl:dl:(Nw/2-1)*dl]+lam0; %This axis labels the lam direction of the camera.