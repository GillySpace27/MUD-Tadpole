function [ pulse ] = temporal_interleave(MUDDAT)
% This function takes in the MUDDAT object and passes the data into the
% concatenation routine. This is basically a conversion between the
% paradigm created by Chris into the paradigm created by Jake. It then
% takes the output of the concatenation and outputs it as a PULSE object.

c = 300; % nm/fs

printf('Interleaving...')
tic

%% Gather required variables

%Find temporal delay between cross sections
tau = abs( MUDDAT(2).pos - MUDDAT(1).pos )/ c * 1e6;

%Create Frequency Axis
lam = MUDDAT(1).lam;
lam0 = mean(lam);
w = equally_spaced_w(lam);

%Pad the Frequency Axis (padding gives extra temporal resolution)
width = 1280;
padd = 0;%width-length(w);
NW = ( padd + length(w));
wmax = max(w);
wmin = min(w);
w0= mean(w);
dw = (wmax-wmin)/length(w);
long_w = (-NW/2*dw:dw:(NW/2-1)*dw)+w0;

%% Create a nice padded E(w) array to pass in to the algorithm

for nn = 1:(length(MUDDAT))
    
     %Go from lam domain to w domain
     w_spec = equally_spaced_spectrum_w(lam, MUDDAT(nn).spec);
     w_phi = equally_spaced_spectrum_w(lam, MUDDAT(nn).phi);
    
     %Pad
     pad_spec = padarray(w_spec, [0 padd]);
     pad_phi = padarray(w_phi, [0 padd]);
     
     %We need E, not spectrum
     new_Ew = sqrt(pad_spec);

     Ew(:,nn) = new_Ew.*exp(1i*pad_phi);

end


%% Temporal Interleave
%Jakes code for concatenation: "The Algorithm"
[Et, E_lam, t_f, w_f, lam_eq] = best_concat_mud(Ew,tau,long_w,lam0);


%% Output Pulse
%Pulse as a function of time
pulse.t = t_f;
pulse.w = w_f;
pulse.int = abs(Et).^2;
pulse.tphi = unwrap(angle(Et));

%Pulse as a function of wavelength
pulse.lam = lam_eq;
pulse.spec = abs(E_lam).^2;
pulse.sphi = unwrap(angle(E_lam));

printf('Complete. Took %0.2f seconds.\n', toc)
end



% INPUT:
%
% MUDDAT is a cell array. It has length(MUDDAT) number of elements
%   Each element has the following fields:
%   lam - the wavelength axis
%   spec - the picture's spectrum
%   rawphi - the phase difference
%   phi - the true phase, with reference phase added from grenouille
%   success = 0 if fail, 1 if win
%   pos = absolute position of stage in mm


% example:  spectrum = MUDDAT{3}.spec;
% notice the curly brackets
%
% OUTPUT:
%
% pulse should be a structure containing the full reconstructed pulse.
%   It needs the following fields:
%   hz - frequency abcissa
%   lam - wavelength abcissa
%   spec - spectrum
%   sphi - spectral phase
%   t - time axis
%   int - temporal intensity
%   tphi - temporal phase
