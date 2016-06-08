function  move_stage(s,a,b)

%Moves the stage number b by the amount a where s is a cell array of two 
%differt serial opjects. I added some lines to this program to makes sure
%that it does not send commands to the controller to move the stage when it
%is off.
if  b == 2 & a> 2;
    display('too large of a step for the z axis, not moving the stage')
    return
    
end
if b ~= 4;
    fprintf(s{1}, [num2str(b) 'MF?\n'])
    fgetl(s{1});
    status = fgetl(s{1});%this returs 1 for on and 0 for off
    
    %if str2num(status) == 1;       
        fprintf(s{1}, [num2str(b) 'PR' num2str(a) ';' num2str(b) 'WS\n'])
    %else
        %error('the stage is off')
    %end
elseif b == 4; %this part of the loop is for moving the stage that is on the second esp controller
    b =1;
    fprintf(s{2}, [num2str(b) 'MF?\n'])
    fgetl(s{2});
    status = fgetl(s{2});%this returs 1 for on and 0 for off
    if str2num(status) == 1;       
        fprintf(s{2}, [num2str(b) 'PR' num2str(a) ';' num2str(b) 'WS\n'])
    else
        error('the stage is off')
    end
end

