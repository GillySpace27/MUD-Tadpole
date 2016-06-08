function [ MUDPIX, REF ] = capture_MUDPIX()
%  This function uses a thorcam and an esp stage to generate a MUDPIX and a
%  REF object for use in a MUD Tadpole analysis.
%
%   Called by MUD_MAIN, this function takes the reference trace, determines
%   where to put the stage, brings the stage to the beginning of the pulse,
%   and captures a series of pictures along the single axis of the
%   translation stage.
%
% This file is primarily for our specific experimental setup, and will need to
% be adapted heavily for yours. Your job is to use your setup to create a
% MUDPIX object and a REF object

%% Parameters

% Exposure time of the camera
thorcam_exposure = 3; %Milliseconds

% Calibration of the Wavelength Axes
dl = 0.051809e-9; %New value retrieved on May 29th
lowestLambda = 760e-9; %Approx value based on May 29th calibration

% Size of the camera's CCD in nm 
xsize = 3.9e-6;

% With what resolution should the stage scan?
scanResolution = 0.02; %base mm(smallest possible is ~70nm)
% 50fs = 0.015mm, 100fs = 0.03mm
% width_of_pulse * c * 0.8 = scanResolution

% Where is the "Speck.dat" file from the grenouille?
grenfile = 'C:\Users\Chris\Dropbox\Spring 2015\Trebino\All-Sea-Tadpole\Calibrated Traces\gren ref 4-13\FrogFile-13-Apr-2015-16-23-14.Speck.dat';
    

%% Initialize the camera and the translation stage
[cam, s] = init_all();

try
    %% Prepare the camera
    % Set the exposure time of the camera in ms
    exposureset_thorcam( cam, thorcam_exposure );
    
    % Label the Calibrated Axes
    [lam, x] = label_axes(cam, dl, lowestLambda, xsize);
    
    %% Generate REF Object
    % Take the Reference Trace
    REF.data  = take_ref_trace(cam);
       
    REF.gPhi = gren_phase( grenfile, lam );
    %Future work: get this in real time from a grenoullie. Ideally the two
    %devices should be immediately adjacent anyway.
    
    REF.lam = lam;
    REF.x = x;
    
    %% Generate MUDPIX object
    % Ask user where to take pictures
    snapPositions = create_snapPositions( cam, s, scanResolution );
    
    % Capture a series of pictures across the pulse
    MUDPIX = scan_over( cam, s, snapPositions );
    
    for nn = 1:length(MUDPIX)
        %Label those axes!
        MUDPIX(nn).lam = lam;
        MUDPIX(nn).x = x;
    end
    
    
catch errorcode
    %If you get an error, at least close the camera, or everything breaks
    %and you have to restart matlab.
    kill_all(cam, s);
    rethrow(errorcode)
end

%% Close the camera and the translation stage
kill_all(cam, s);
end

