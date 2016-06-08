function [et, t,w_eq] = find_et_jake(phase, spectrum, cal,lo)

%%%
%This program fourier transforms E(lam) to E(t)
%use it like this: [t, et] = find_et(phase, spectrum, cal,lo);

%options
zero_fill = false;
n = 2000;
%%
    
if nargin == 3;
    lo  = 800;
end

lam = lam_axis(cal, length(spectrum), lo);
omega = ltow(lam)-ltow(lo);
omegaeq=equally_spaced_w(lam)-ltow(lo);
spectrum = spectrum-spectrum(1);
phase = unwrap(phase);  %make sure that the phase is unwrapped before doing interpolation
seq =interp1(omega, spectrum, omegaeq, 'cubic');
phieq =interp1(omega, phase, omegaeq, 'cubic');

if zero_fill == true
    phieq = [zeros(1,n) phieq(1:end-50) zeros(1,n)];
    seq = [zeros(1,n) seq(1:end-50) zeros(1,n)];
end

ew = seq(1:end).^.5.*exp(-i*phieq(1:end));
et = fftc(ew);
w_eq=recal_axis(omegaeq,seq,1,length(omegaeq));
t =time_axis(cal,length(et));