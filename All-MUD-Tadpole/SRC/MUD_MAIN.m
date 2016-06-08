function [PULSE] = MUD_MAIN()
%% SEA/MUD Tadpole Experiment Algorithm, with internal Simulation for Verification
% This program is designed to measure a complex unknown pulse by gating it
% with a known reference pulse and analyzing many interference patterns
% from a SEA Tadpole device equiped with a variable-delay reference.

% This function is the highest level function which runs the whole
% experiment. It's accuracy can be verified by using simulated pulses.
% There are many parameters within simulate_MUDPIX. 

% This function generates all of the required inputs (MUDDAT and REF
% objects). It then analyzes each of the tadpole traces and creates a 
% MUDDAT object which contains the spectra and spectral phases of each
% trace. Finally, it temporally interleaves the traces and outputs the
% reconstructed pulse. SIM_PULSE is the correct pulse, directly out of the
% math. 
% There is a detailed explaination/ guide through the experiment/code which
% can be found in the help file in the INFO folder.

% The only functions that should need to be altered to make the program run
% with your experiment are within 'capture_MUDPIX'. As long as you make
% that function work with your setup, everything else should work just
% fine.


%% Parameters
%Do you want to test the algorithm with simulated data?
Simulation = true; %Use false for real experiment.

%Do you want to plot each trace (Debug)?
Plot_traces = false;

%Do you want to store the data for possible future re-analysis?
    Store_data = false;
    MD_filename = 'my_MUDDAT';
    %Discarding the actual images dramatically reduces file size, but
    %retains all the data necessary to run the algorithm
    keep_data = false; 

%Do you want to export the traces as pictures?
    ExportMUDPIX = false;
    MP_filename = 'my_MUDPIX';
    MP_filetype = 'gif'; %Options are {gif,bmp,both}


%% Generate the MUDPIX traces and REF reference object
    % This gathers the data from the experiment
    
if Simulation
    % Simulate the pulse slices and references.
    [ MUDPIX, REF, SIM_PULSE ] = simulate_MUDPIX();
else
    % Capture pulse slices from the physical experiment
    [ MUDPIX, REF ] = capture_MUDPIX();
end

   %Plotting
    if false
        % This will display each picture out of MUDPIX
        display_MUDPIX(MUDPIX);
    end

    if ExportMUDPIX
        % This will save each picture to disk.
       export_MUDPIX(MUDPIX, REF, MP_filename, MP_filetype);
    end

        
%% Extract the spectrum and phase difference from each trace
    %This analyzes each picture
    
MUDDAT = extract_MUDPIX( MUDPIX, REF );

    %Plotting
    if Plot_traces
        % Look at the image, spectrum, and spectral phase of each trace.
        display_MUDDAT(MUDDAT)
    end
    
    %Save the data for later
    if Store_data
        save_MUDDAT(MUDDAT, MD_filename, keep_data)
    end

%% Reconstruct the pulse
    % This program supports any number of traces, intelligently
    % concatenating them to reconstruct the unknown pulse.
    
if length(MUDDAT) == 1
    % This is SEA tadpole. 
    warning('SEA Tadpole extraction still has a bug!');
    PULSE = sea_extract_MUDDAT(MUDDAT);
else
    % This is MUD tadpole.
    PULSE = temporal_interleave(MUDDAT);
end


%% Plot the Result
    if Simulation
        %Compare the pulses to see if the algorithm worked.
        pulsecompare(SIM_PULSE, PULSE);       
    else
        %Display the reconstructed pulse
        figure('Position', [100, 100, 2000, 2000]);
        movegui('center')
        pulseplot(PULSE, 'r');
    end

end



