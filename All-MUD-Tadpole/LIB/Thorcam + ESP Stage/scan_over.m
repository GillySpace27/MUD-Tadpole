function [ MUDPIX ] = scan_over( cam, s, snapPositions )
%Captures many pictures of a pulse while translating an axis,
%stores those pictures in a cell array.

figure();
movegui('northeast');

scanSteps = length(snapPositions);

MUDPIX(scanSteps).data = []; %Cell array containing all pictures
MUDPIX(scanSteps).pos = [];

for nn = 1:scanSteps
%For each picture

    %Send the stage to the correct location
        hold_on(0.5);
        move_to_position(s,1,snapPositions(nn));
        hold_on(1.5);
        
    %Acquire the Photo
        img = snap_thorcam(cam);
    
    %Update the screen
        display_thorimg(img)
        drawnow;
        
    %Store the picture and stage location
    MUDPIX(nn).data = img.Data;
    MUDPIX(nn).pos = snapPositions(nn);
    
          
end

end

