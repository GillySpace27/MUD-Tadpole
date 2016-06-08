function [img] = snap_thorcam(cam)
%Snap Thorcam
%   This takes a single photo from the thorcam

%   Allocate image memory
[ErrChk, img.ID] = cam.Memory.Allocate(true);
if ~strcmp(char(ErrChk), 'SUCCESS')
    error('Could not allocate memory');
end


%   Obtain image information
[ErrChk, img.Width, img.Height, img.Bits, img.Pitch] ...
    = cam.Memory.Inquire(img.ID);
if ~strcmp(char(ErrChk), 'SUCCESS')
    error('Could not get image information');
end

%   Acquire image
if ~strcmp(char(cam.Acquisition.Freeze(true)), 'SUCCESS')
    error('Could not acquire image');
end
%   Extract image
[ErrChk, tmp] = cam.Memory.CopyToArray(img.ID); 
if ~strcmp(char(ErrChk), 'SUCCESS')
    error('Could not obtain image data');
end
%   Reshape image
img.Data = reshape(uint8(tmp), [img.Width, img.Height, img.Bits/8]);

    img.Data = rot90(img.Data);

end

