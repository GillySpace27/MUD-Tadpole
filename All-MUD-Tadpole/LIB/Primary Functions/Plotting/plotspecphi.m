function plotspecphi(spectrum, phi, lam)

%Plots the spectral and temporal phases. Meant to be called multiple times
%to plot several on same graph. Called by extract_mudpix.

 r_E_lam = sqrt(spectrum).*exp(1i*phi);
        [r_E_w, rw] = equally_spaced_spectrum_w(lam, r_E_lam);
        r_E_t = ifftc(r_E_w);
        rt = wtot(rw);

        %title( sprintf('Delay: %0.2f', MUDPIX{nn}.pos/300*1e6))
    
        subplot(1,3,1)
        hold on
         plot(lam, spectrum)
         axis([-1000, 1000, 0, inf])
                title('Spectrum')
        
        subplot(1,3,2)
        hold on
         %plot(rt, abs(r_E_t).^2)
         %axis([-1000, 1000, 0, inf])
        pulse_phase_lam = unwrap(phi);
        pulse_phase_lam = pulse_phase_lam - pulse_phase_lam(length(pulse_phase_lam)/2);
        plot(lam, pulse_phase_lam)
        title('Spectral Phase')
        %axis([-1000, 1000, -20, 20])
        
        subplot(1,3,3)
        hold on
        pulse_phase_t = unwrap(angle(r_E_t));
        pulse_phase_t = pulse_phase_t - pulse_phase_t(length(pulse_phase_t)/2);
        indextoplot = norm1(abs(r_E_t).^2) > 0.01;
        plot(rt(indextoplot), pulse_phase_t(indextoplot))
        axis([-1000, 1000, -20, 20])
        title('Temporal Phase')

end
