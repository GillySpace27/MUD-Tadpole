function [ ] = close_thorcam(cam)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

%   Close camera
if ~strcmp(char(cam.Exit), 'SUCCESS')
    error('Could not close camera');
else
    fprintf('Camera is Closed\n')
end

end

