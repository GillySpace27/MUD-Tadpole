% This function performs the concatenation routuine for 
% scanning sea tadpole
% t = array of times scanned in sec
% Ew = retrieved spectrum in equally spaced w
% w = equally spaced freq axis

function [B1,C1,E_lam,t_f,w_f,lam_eq]=best_concat(Ew,tau,w,lam0)
c=300;
% Generating the time window:
[tw,delta_t]=time_window(w,tau);
%clear w
% Making the temporal response function
Ht=ones(size(Ew));
% Filtering out only retrieved regions in the time window:
[Valid_unk,Valid_H,x]=temporal_filter_sea(fftc(Ew),tw,size(Ew,2),Ht);

% making the weighting function:
[Valid_H]=make_weighting_function(x,tw,Valid_unk);
% rephasing for a smooth concatenation, brother:
[offset]=new_phase_offset(Valid_unk,tw,x);
% indexing the retrieved amplitudes
[Uindex,Hindex]=index_temporal_slices(Valid_unk,Valid_H,tw,x);
% concatenating the temporal slices
% B1 is after concatenating the fields 
% C1 is after concatenating the amp and phase separately
[B1,C1]=new_concat(Uindex,Hindex,tw,x,offset);
% making the time axis:
Nt=length(C1);
[t_f]=(-Nt/2*delta_t:delta_t:(Nt-1)/2*delta_t);
w_f=ttow(t_f,2*pi*c/lam0);

[E_lam,lam_eq]=equally_spaced_spectrum_lam(w_f,fftc(C1));
x=1;
E_lam=E_lam(x:end-x);
lam_eq=lam_eq(x:end-x);
