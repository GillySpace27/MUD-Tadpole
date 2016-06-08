function x = display_position(s,b);

%This function finds the position of one of the motorized actuators by 
%talking to the ESP 300 box throught the serial port where s is the serial 
%port object.  b is the axis that is used (one through three). If b is not
%specified then axis one is used.
%see also serial_init, move_stage, make_vector, or measure_phase_front
%example: x = find_position(s,2) 
    
    
    if b == 1;
        fprintf(s{1}, '1TP\n');
    elseif b ==2;
        fprintf(s{1}, '2TP\n');
    elseif b ==3;
        fprintf(s{1}, '3TP\n');
    elseif b ==4;
        fprintf(s{2}, '1TP\n');
    end
        
    
    if b<4;
        location = fgetl(s{1});
        location = fgetl(s{1});
        
    else
        location = fgetl(s{2});
        location = fgetl(s{2});
        
    end
   
    display(location);
    
    x = str2num(location);

end