function [ Ref1 ] = take_ref_trace( cam )
% Waits for you to block one arm and then takes a picture

figure();
movegui('northeast');
fprintf('Press S when ready to Take Reference Trace...\n')
img = vidcap_thorcam(cam);
Ref1 = img.Data;
movegui('northwest');


end

