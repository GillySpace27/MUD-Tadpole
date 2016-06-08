function PULSE = sea_extract_MUDDAT(MUDDAT)

%% STILL BUGGY       

        %Pass through the spec domain stuff
        PULSE.lam = MUDDAT.lam;
        PULSE.spec = MUDDAT.spec;
        PULSE.sphi = MUDDAT.phi;
        
        % Transform to the frequency domain
        E_lam = sqrt(PULSE.spec).*exp(1i*PULSE.sphi);
        [Ew, PULSE.w] = equally_spaced_spectrum_w(PULSE.lam, E_lam);
        
        % Pad the frequency domain to get better resolution
        padd = length(Ew)/2;
        Ew = padarray(Ew, [0, padd]);
        
        % Transform to the time domain
        Et = fftc(Ew,[],2); %complex time domain field
        
        % Make the time axis
        PULSE.t = wtot_padd(PULSE.w, length(Et));
%         pulse.t = padarray(pulse.t, [0, padd]);
        
        % Temporal Intensity
        PULSE.int = norm1(abs(Et).^2);

        % Make the center phase be zero
        temporalphase = unwrap(angle(Et));
        PULSE.tphi = temporalphase - temporalphase(round(length(temporalphase)/2));        
        
        
        
%         %% Add zeros to the edges to increase resolution.
%     zerofactor = 10000; %How many zeros to add to each side
%     %convert to frequency
%     low_w = 2*pi*3e8/lam(end);
%     high_w = 2*pi*3e8/lam(1);
%     dw2 = (high_w - low_w)/Nw; 
% 
%     % wavelength values corrresponding to equally spaced frequency points,
%     %  centered at the middle of the wavelength range.
%     Lp= (2.*pi.*(3E8))./(0.5*(high_w+low_w)+dw2*(-Nw/2:Nw/2-1)); 
% 
%     % Have to interpolate intensity and phase separately or the spectrum gets
%     % weird.
%     spectrumw = spline(lam, spectrum, Lp);
%     newphiw = spline(lam, newphi, Lp);
%     
%     spectrumwpad = padarray(spectrumw, [ 0 zerofactor ]);
%     newphiwpad = padarray(newphiw,  [ 0 zerofactor ]);
%     
%     w = spline(-Nw/2:Nw/2-1, (0.5*(high_w+low_w)+dw2*(-Nw/2:Nw/2-1)), (-zerofactor-Nw/2:zerofactor+Nw/2-1));
%     t = wtot(w);

       % pulse.t 

        
end