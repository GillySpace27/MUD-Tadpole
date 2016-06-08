function [img] = spec_thorcam( cam )
% Video Capture
%   This function will display the spectrum along the middle row of the
%   camera until the 's' key is pressed, at which point it will output the
%   image. It times out after 10,000 loops



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

h = figure();
hh = figure();

jj = 0;
k=0;
while ~k
    
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
    
    %   Update the screen
    %display_thorimg(img)
    plot(norm1(img.Data(400,:)));
    drawnow;
    
    jj = jj+1;
    

    if strcmp(get(gcf,'currentcharacter'),'s');
        k=1;
        set(gcf,'currentcharacter','*');
        fprintf('Image Acquired\n');
    end
end



end

