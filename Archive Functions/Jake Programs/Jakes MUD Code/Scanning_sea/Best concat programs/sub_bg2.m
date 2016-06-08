% this function subtracts background from a 
% retreived E(w) and then returns the subtracted 
% E(w)
% x_c1 = first cropped value where the spectrum is zero
% x_c2 = secodn cropped value where the spectrum is zero
% w_eq = equally spaced spectrum
% x2 = the and value of the region where the noise occurs
% Ew1 = retrieved 
% ymax = the limit of the intensity of the background;


function [Ew1,w1]=sub_bg2(Ew,x_c1,x_c2,w_eq,x2,ymax)
% cropping the retrieved spectra and freq axis:
Ew1=Ew(x_c1:x_c2,:);
w1=w_eq(x_c1:x_c2);

% subtracting the constant background in the retrieved spectra
amp=abs(Ew1);
phase1=angle(Ew1);
amp_z=amp-max(amp(1:x2,1));
% getting rid of the negative terms:
a=find(amp_z<0);
amp_z(a)=0;
% Gets rid of the max values:
amp_z=amp_z-ymax;
a=find(amp_z<0);
amp_z(a)=0;
% Putting the fields back together:
Ew1=amp_z.*exp(i*phase1);