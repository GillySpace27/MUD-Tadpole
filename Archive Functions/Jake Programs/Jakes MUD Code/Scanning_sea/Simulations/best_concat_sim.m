% This function performs the concatenation routuine for 
% scanning sea tadpole
% tau = temporal delay between reference pulses
% Ew = retrieved spectrum in equally spaced w
% w = equally spaced freq axis
% lam0 = center wavelength

function [C_amps,E_lam,t_f,lam_eq,amp,t1]=best_concat_sim(Ew,tau,w,lam0)
c=300;
% Generating the time window:
[tw,delta_t]=time_window(w,tau);
% Filtering out only retrieved regions in the time window:
[Valid_unk,Valid_H,x]=temporal_filter_sea(fftc(Ew),tw,size(Ew,2));

% making the weighting function:
[Valid_H]=make_weighting_function_sim(x,tw,Valid_unk);
% rephasing for a smooth concatenation, brother:
[offset]=new_phase_offset(Valid_unk,tw,x);
% indexing the retrieved amplitudes
[Uindex,Hindex]=index_temporal_slices(Valid_unk,Valid_H,tw,x);
% Getting the 
[amp,t1]=field_ready(Uindex);
[E]=new_concat2(Valid_unk,Valid_H,tw,x,offset,amp,t1);
% concatenating the temporal slices
% C_fields is after concatenating the fields 
% C_amps is after concatenating the amp and phase separately
[C_fields,C_amps]=new_concat(Uindex,Hindex,tw,x,offset);
% making the time axis:
Nt=length(C_amps);
[t_f]=(-Nt/2*delta_t:delta_t:(Nt-1)/2*delta_t);
w_f=ttow(t_f,2*pi*c/lam0);

[amp_lam,lam_eq]=equally_spaced_spectrum_lam(w_f,abs(fftc(C_amps)));
[phase_lam,lam_eq]=equally_spaced_spectrum_lam(w_f,unwrap(angle(fftc(C_amps))));
E_lam=amp_lam.*exp(i*phase_lam);
x=1;
E_lam=E_lam(x:end-x);
lam_eq=lam_eq(x:end-x);
