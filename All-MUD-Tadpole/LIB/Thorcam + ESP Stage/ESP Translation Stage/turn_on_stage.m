function [] =turn_on_stage(s,b);

% This function turns on the stage's motor
%%    
    if b <4;
        fprintf(s{1}, [num2str(b) 'MO\n']); 
        fprintf(s{1}, [num2str(b) 'MO?\n']);
        status = fgetl(s{1});
        status = fgetl(s{1});
    elseif b ==4;
        fprintf(s{2}, '1MO\n');
        fprintf(s{2}, '1MO?\n');
        status = fgetl(s{2});
        status = fgetl(s{2});
    end
        
status = str2num(status);

    if status==1
        display(['Axis ' num2str(b) ' is on']);
    else
        display(['Axis ' num2str(b) ' did not come on!!'])
    end

end