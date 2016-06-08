function [t, et] = find_et(phase, spectrum, cal,lo);

%%%
%options
skip_plot = true;
zero_fill = true;
n = 2000;
nm = 1e-9;

%%%

    
  if nargin == 3;
      lo  = 825;
  end

lam = lam_axis(cal, length(spectrum), lo);
omega = ltow(lam)-ltow(800);
omegaeq=equally_spaced_w(lam*nm)*1e-15-ltow(800);


test2 = size(spectrum);

if test2(1)>1
    spectrum = sum(spectrum);
    spectrum = spectrum-spectrum(1);
end

seq =interp1(omega, spectrum, omegaeq, 'cubic');
phieq =interp1(omega, phase, omegaeq, 'cubic');

if zero_fill == true
    phieq = [zeros(1,n) phieq zeros(1,n)];
    seq = [zeros(1,n) seq zeros(1,n)];
end

ew = seq.^.5.*exp(i*phieq);
%plot(unwrap(angle(ew(1:end-100))));
et = fftc(ew(1:end-100));

t =time_axis(cal,length(et));

if skip_plot== false;
    plot(t,Norm(abs(et).^2))
    
end