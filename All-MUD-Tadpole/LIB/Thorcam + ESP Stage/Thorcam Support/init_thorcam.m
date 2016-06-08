function [ cam, asm ] = init_thorcam( )
%Initialize the Thorcam
%   This does all the magic that opens the camera.

%   Add NET assembly if it does not exist
%   May need to change specific location of library
asm = System.AppDomain.CurrentDomain.GetAssemblies;
if ~any(arrayfun(@(n) strncmpi(char(asm.Get(n-1).FullName), ...
        'uc480DotNet', length('uc480DotNet')), 1:asm.Length))
    NET.addAssembly(...
        'C:\Program Files\Thorlabs\Scientific Imaging\DCx Camera Support\Develop\DotNet\signed\uc480DotNet.dll');
end
%   Create camera object handle
cam = uc480.Camera;
%   Open 1st available camera
%   Returns if unsuccessful
if ~strcmp(char(cam.Init), 'SUCCESS')
    error('Could not initialize camera');
end
%   Set display mode to bitmap (DiB)
if ~strcmp(char(cam.Display.Mode.Set(uc480.Defines.DisplayMode.DiB)), ...
        'SUCCESS')
    error('Could not set display mode');
end
%   Set colormode to 8-bit RAW
if ~strcmp(char(cam.PixelFormat.Set(uc480.Defines.ColorMode.SensorRaw8)), ...
        'SUCCESS')
    error('Could not set pixel format');
end
%   Set trigger mode to software (single image acquisition)
if ~strcmp(char(cam.Trigger.Set(uc480.Defines.TriggerMode.Software)), 'SUCCESS')
    error('Could not set trigger format');
end

exposureset_thorcam( cam, 100 ); %Set exposure time in ms

    fprintf('Camera Initialized\n')
    
    %Suppress stupid warnings
    warning('off','images:initSize:adjustingMag');
    
end
