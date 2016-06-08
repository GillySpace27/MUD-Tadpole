function  move_to_position(s,b,p);

%This function moves an actuator to a specific position that is specified in
%mm by p.  The axis or actuator moved (one of three) is specified by b. s 
%is the initialized serial port.  for example: move_to_position(s,b,p).  If 
%b is not specified, then axis 1 is moved.  

% if b ~= 4;
    fprintf(s{1}, [num2str(b) 'MF?\n']) %IS the stage on?
    fgetl(s{1});
    status = fgetl(s{1});%this returns 1 for on and 0 for off
    if str2num(status) == 1;       
        fprintf(s{1}, [num2str(b) 'PA' num2str(p) ';' num2str(b) 'WS\n']);
    else 
        %error('the stage is off')
    end
% elseif b == 4; %this loop is for the stage that uses the other controller
%     b = 1;
%     fprintf(s{2}, [num2str(b) 'MF?\n'])
%     fgetl(s{2});
%     status = fgetl(s{2});%this returs 1 for on and 0 for off
%     if str2num(status) == 1;       
%         fprintf(s{2}, [num2str(b) 'PA' num2str(p) ';' num2str(b) 'WS\n']);
%     else 
%         error('the stage is off')
%     end
end

