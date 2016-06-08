% This function performs the concatenation routuine for 
% scanning sea tadpole
% t = array of times scanned in sec
% Ew = retrieved spectrum in equally spaced w
% w = equally spaced freq axis

function [U1,phase1,C1,B1,E_lam,t_f,w_f,lam_eq]=concat_sea3_no_end2(Ew,tau1,w,lam0,H)
c=300;
N=size(Ew,2);
tau=mean(abs(diff(tau1)));
% Generating the time window:
[tw,delta_t]=time_window(w,tau);
% Making the temporal response function
Ht=ones(size(Ew));
% Filtering out only retrieved regions in the time window:
[Valid_unk,Valid_H,Valid_unk_begin,Valid_unk_end,x]=temporal_filter_sea(fftc(Ew),tw,size(Ew,2),Ht);
% Getting the retrieved amplitudes ready for concatenation by shifting them
% in time
[U1,H1,g1]=add_phase_delay1(Valid_unk,tw,Valid_H,x,Valid_unk_begin,Valid_unk_end);

% 9.25 Calibrating each time window:
%[Valid_unk]=calibrate1(U_win);
% taking care of the phase constants for plotting purposes:
[phase0,offset]=phase_offset(U1,g1);
phase1=phase_ready(U1);
% performing a weighted sum:
[amp,phase,B1,C1]=weighted_sum(U1,H1,phase0);
% making the time axis:
Nt=length(C1);
C1=crop(C1);
[t_f]=[-Nt/2*delta_t:delta_t:(Nt-1)/2*delta_t];
w_f=ttow(t_f,2*pi*c/lam0);
%[fit1]=phase_fit1(unwrap(angle(C1)));
[E_lam,lam_eq]=equally_spaced_spectrum_lam(w_f,fftc(C1));
E_lam=E_lam([500:end-500]);
lam_eq=lam_eq(500:end-500);
