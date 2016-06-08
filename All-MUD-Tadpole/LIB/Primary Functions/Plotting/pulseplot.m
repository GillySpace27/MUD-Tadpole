function pulseplot(pulse, color)
%Plots all four components of a given pulse

%% Temporal Phase
subplot(2,2,3)
hold on

%Phase blanking
good_tphi = norm1(pulse.int) > 0.01;

%Set center phase to zero
pulse.tphi = (pulse.tphi) - pulse.tphi(round(end/2));

%Plot
plot(pulse.t(good_tphi), pulse.tphi(good_tphi), color)

title('Temporal Phase')
xlabel('Time (fs)')
axis([-10000,10000,-inf,inf])

%% Spectral Phase
subplot(2,2,4)
hold on

%Phase Blanking
good_sphi = norm1(pulse.spec) > 0.001;
new_pulse_lam = pulse.lam(good_sphi);
pulse.sphi = unwrap(pulse.sphi(good_sphi));

%Set center phase to zero
pulse.sphi = (pulse.sphi) - pulse.sphi(round(end/2));

%Plot on same figure %%Switch order, blank then zero.
plot(new_pulse_lam, (pulse.sphi), color)

title('Spectral Phase')
xlabel('Wavelength (nm)')
axis([min(pulse.lam), max(pulse.lam), -inf, inf])

%% Spectral Intensity
subplot(2,2,2)
hold on

plot(pulse.lam, norm1(pulse.spec), color)

title('Spectrum')
xlabel('Wavelength (nm)')
axis([min(pulse.lam), max(pulse.lam), -inf, inf]) 

%% Temporal Intensity
subplot(2,2,1)
hold on

plot(pulse.t, norm1(pulse.int), color)

title('Temporal Intensity')
xlabel('Time (fs)')
axis([-10000,10000,0,1])




end