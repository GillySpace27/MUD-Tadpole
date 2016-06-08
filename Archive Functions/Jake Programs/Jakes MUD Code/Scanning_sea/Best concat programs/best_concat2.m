% This function performs the concatenation routuine for 
% scanning sea tadpole really really well!
% tau = temporal delay between reference pulses
% Ew = retrieved spectrum in equally spaced w
% w = equally spaced freq axis
% lam0 = center wavelength

function [Et,E_lam,t_f,lam_eq,amp,t1]=best_concat2(Ew,tau,w,lam0)
c=300;
% Generating the time window:
[tw,delta_t]=time_window(w,tau);
% Filtering out only retrieved regions in the time window:
[Valid_unk,Valid_H,x]=temporal_filter_sea(fftc(Ew),tw,size(Ew,2));

% making the weighting function:
[Valid_H]=make_weighting_function(x,tw,Valid_unk);
% rephasing for a smooth concatenation, brother:
[offset]=new_phase_offset(Valid_unk,tw,x);
% indexing the retrieved amplitudes
[Uindex,Hindex]=index_temporal_slices(Valid_unk,Valid_H,tw,x);
% Getting the 
[amp,t1]=field_ready(Uindex);
% concatenating the temporal slices
% C_fields is after concatenating the fields 
% C_amps is after concatenating the amp and phase separately
[Et]=new_concat2(Valid_unk,Valid_H,tw,x,offset);
% making the time axis:
Nt=length(Et);
[t_f]=(-Nt/2*delta_t:delta_t:(Nt-1)/2*delta_t);
w_f=ttow(t_f,2*pi*c/lam0);
% FFTing to the equally spaced wavelength domain
% for the amplitues:
[amp_lam,lam_eq]=equally_spaced_spectrum_lam(w_f,abs(fftc(Et)));
% and the phase separately:
[phase_lam,lam_eq]=equally_spaced_spectrum_lam(w_f,unwrap(angle(fftc(Et))));
E_lam=amp_lam.*exp(i*phase_lam);
x=1;
E_lam=E_lam(x:end-x);
lam_eq=lam_eq(x:end-x);
