% This function performs the concatenation routuine for scanning sea
% tadpole really really well! tau = temporal delay between reference pulses
% Ew = retrieved spectrum in equally spaced w w = equally spaced freq axis
% lam0 = center wavelength

function [Et_p,E_lam,t_f,w_f,lam_eq]=best_concat_mud(Ew,tau,w,lam0)
c=300;
%% Figure out how much time each cross section represents:
[tw,delta_t]=time_window(w,tau);

% tw=tw-1;

% tw (scalar) -> number of time points per cross section
% delta_t (scalar) -> temporal resolution (fs / time point)
% tw * delta_t = tau


%% Crop off the wings of each cross section (time domain) (invalid data because intensity is low there)
[Valid_unk, ~,tsp]=temporal_filter_mud(fftc(Ew),tw,size(Ew,2));

% size(Ew,2) -> the number of pictures taken 
% tsp (scalar) -> T_sp, the temporal width of the reference pulse at the spectrometer 
% (in units of delta_t) (literally a*tw) 
% has a parameter, a, that modifies the width of the reference pulse 
% valid_unk is a time-domain cropped array


%% Make the weighting function:
[Valid_H]=make_weighting_function(tsp,tw,Valid_unk);

% Valid_H is an array of gaussians, with tw as the time constant.


    %% Plot the fields, overlapping, before concatination.
    % This shows a plot with the data from each individual trace
    % superimposed.

    if true

    plot_concat(Valid_unk,Valid_H,tw,tsp);

    end
            
%% Find the phase offset of each cross section
[offset]=new_phase_offset(Valid_unk,tw,tsp);

% offset is a 1 by N_pulses array of the difference in phase between each
% successive pulse at its boundaries.


%% Concatenating the temporal slices

Et = new_concat2(Valid_unk,Valid_H,tw,tsp,offset);

% Et is the complex valued, concatenated electric field as a function of
% time (Et=amp_tot.*exp(i*phase_tot);)

% Clean up
[Et] = Et.'; %Make it a row vector again.

if mod(length(Et),2)
    Et = Et(1:end-1); %Things seem to break if length(Et) is odd.
end
% 
% Et = Et(2:end);
% Et(end+1) = 0;


%% Pad the field and generate the time axis:

width = 4096; %Final width of the output pulse array

padd = 1000; %(width - length(Et))/2;

[Et_p] = padarray(Et, [0 padd]);

Nt = length(Et_p);

[t_f] = (-(Nt/2)*delta_t:delta_t:(Nt-1)/2*delta_t); 


%% Transform to the lam domain

% Transform to the w domain
Ew = fftc(Et_p);

% Generate the w axis
[w_f] = ttow(t_f,2*pi*c/lam0);

% Change from w to lam
[E_lam, lam_eq] = equally_spaced_spectrum_lam(w_f,Ew);

% E_lam is the complex valued, concatenated electric field as a function of
% wavelength
% lam_eq is the absicca of the wavelength axis

x = round(length(E_lam) * 0.1);
E_lam = E_lam(x:(end-x));
lam_eq = lam_eq(x:(end-x));

end



















