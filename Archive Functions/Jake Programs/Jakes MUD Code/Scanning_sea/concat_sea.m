% This function performs the concatenation routuine for 
% scanning sea tadpole
% t = array of times scanned in sec
% Ew = retrieved spectrum in equally spaced w
% w = equally spaced freq axis

function [U_win,phase1,B1,E_lam,t_f,w_f,lam_eq]=concat_sea(Ew,t,w,lam0,H)
c=300;
N=size(Ew,2);
tau=mean(abs(diff(t)));
[U1,Ht]=add_phase_delay(Ew,tau,w,H);
% taking only a small time window:
[tw,delta_t]=time_window(w,tau);
[U_win,g,H]=window(U1,tw,N,Ht);
% 9.25 Calibrating each time window:
%[Valid_unk]=calibrate1(U_win);
% taking care of the phase constants for plotting purposes:
[phase0,offset]=phase_offset(U_win,g);
phase1=phase_ready(U_win);
% performing a weighted sum:
[amp,phase,B1,B2]=weighted_sum(U_win,H,phase0);
% making the time axis:
Nt=length(B1);
[t_f]=[-Nt/2*delta_t:delta_t:(Nt-1)/2*delta_t];
w_f=ttow(t_f,2*pi*c/lam0);
[fit1]=phase_fit1(unwrap(angle(B1)));
B3=abs(B1).*exp(i*fit1);
[E_lam,lam_eq]=equally_spaced_spectrum_lam(w_f,fftc(B3),lam0);
[E_lam2,lam_eq]=equally_spaced_spectrum_lam(w_f,fftc(B1),lam0);
