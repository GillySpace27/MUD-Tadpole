function [Unk,Unk_of_t,w2,t,AC]=Sea_tad(I1,Ref,points,w)

c=3e8;
d_points=30;

% Retrieving the individual AC terms and inverse fourier transforming:
[AC,a2]=filter2(fftc(I1,[],2),points,d_points);
%5. Dividing out the reference pulse amplitude, leaving only the ampltitude
%and the phase difference as a function of frequency:
[Unk1]=retrieval(AC,Ref,1);
% Zeroing some points:
%[Unk1]=zero1(Unk1);
%6. Cropping the Unknown vector to get rid of the Inf terms:
[Unk]=crop(crop(Unk1));
%5.7 adding the correct phase factor to each time window:
%[Unk2]=phase_factor(Unk1,lam,t_delay);

% %7.5 Recalibrating the frequency axis. 
% [Unk,New_Unk1,F]=recal(Unk2,lam,c,0);
% Lam2=c./F;
%z1=1320;z2=1682;
z1=1;z2=size(Unk,1);
% Zero padding and fourier filtering:
[Unk]=fourier_filter(Unk,z1,z2,0);
% recalibrating the wavelength axis to accomodate the new points:
w2=recal_axis(w,Unk(:,1),z1,z2);
[t]=wtot(w2);
Unk_of_t=fftc(Unk);
