% This function performs the concatenation routuine for 
% scanning sea tadpole
% t = array of times scanned in sec
% Ew = retrieved spectrum in equally spaced w
% w = equally spaced freq axis

function [U1new,C1,E_lam,t_f,w_f,lam_eq]=concat_sea3_no_end(Ew,tau,w,lam0,H)
c=300;
N=size(Ew,2);
% Generating the time window:
[tw,delta_t]=time_window(w,tau);
clear w
% Filtering out only retrieved regions in the time window:
[Valid_unk,Valid_H,x]=temporal_filter_sea(fftc(Ew),tw,size(Ew,2));
clear Ew Ht
% making the weighting function:
[Valid_H]=make_weighting_function(x,tw,Valid_unk);
% Getting the retrieved amplitudes ready for concatenation by shifting them
% in time
[U1,H1,g1]=add_phase_delay1(Valid_unk,tw,Valid_H,x);
clear Valid_unk Valid_H
% 9.25 Calibrating each time window:
%[Valid_unk]=calibrate1(U_win);
% taking care of the phase constants for plotting purposes:
[U1new]=phase_offset(U1,g1);
clear U1
% performing a weighted sum:
[C1]=weighted_sum(U1new,H1);
% making the time axis:
Nt=length(C1);
C1=crop(C1);

[t_f]=[-Nt/2*delta_t:delta_t:(Nt-1)/2*delta_t];
w_f=ttow(t_f,2*pi*c/lam0);
% getting rid of the zero terms:
z1=1;
%z1=4200;
%z2=2.539e4;
z2=length(C1)-1;
C1(1,[1:z1,z2:end])=0;
[E_lam,lam_eq]=equally_spaced_spectrum_lam(w_f,fftc(C1));
x=390;
E_lam=E_lam([x:end-x]);
lam_eq=lam_eq(x:end-x);
