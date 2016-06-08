function dcam = fw_init(second_camera)
% FW_INIT Initialize a Firewire DCAM digital camera.
%
%   dcam = fw_init() attemps to initialize a DCAM-compliant Firewire camera.
%   The CMU Firewire driver must be properly installed in Windows XP.  If
%   the initialization fails for a specific camera and video format, it
%   might be necessary to edit this file.
%%% begin skeleton 
	version = '$Id: fw_init.m,v 1.2 2008-03-18 18:27:09 pam Exp $'; 
	disp(version);
	% Units
	cm = 1e-2;
	mm = 1e-3;
	um = 1e-6;
	nm = 1e-9;
    ps = 1e-12;
    fs = 1e-15;
	THz = 1e12; 
	% Constants
	c = 3e8; % speed of light
%%% end skeleton
%%% Options
perform_optimization = true;
%%% Code starts here
printf('Retrieving DCAM hardware information...\n');
if nargin==0
    info = imaqhwinfo('dcam',1)
else
    info = imaqhwinfo('dcam',2)
end

printf('Found a DCAM Firewire camera: "%s".\n', info.DeviceName);
switch info.DeviceName
    case 'XCD-X700  1.05'
        video_format = 'F7_Y8_1024x768';
    case 'XCD-SX910UV v3.00E'
        video_format = 'F7_Y8_1024x1024';
    case 'Firewire Camera Release 4'
        video_format = 'F7_Y8_1280x1024';
    otherwise
        video_format = info.DefaultFormat;
        printf('Unknown camera.  Default video format will be used.\n');
        printf('If this fails, try to set the video format manually.\n');
end
printf('Setting the video format to "%s"...\n', video_format);

if nargin==0;
    dcam = videoinput('dcam',1,video_format);
else
    dcam = videoinput('dcam',2,video_format);
end

printf('Camera ready.\n');
printf('Try "preview(dcam)" to preview the image, or "fw_grab(dcam)"\nto capture an image.\n');
