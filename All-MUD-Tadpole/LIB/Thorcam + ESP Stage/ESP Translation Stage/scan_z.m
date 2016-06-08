function [phasexzw, spectrumxzw, xz,z] = scan_z(s,vid,bg,cal, number_of_scans);
%[phasexzw, spectrumxzw, xz,z] = scan_z(s,vid,bg,cal, number_of_scans);

%%

step_size = .05;  %scan z in steps of 0.25mm
H = getselectedsource(vid);
pos1 = find_position(s,2);
pos2 = find_position(s,3);
initial_shutter_speed = 2050;
max_shutter_speed = 2800;
diff = max_shutter_speed - initial_shutter_speed;
delta = floor(diff/((number_of_scans-1)/2))*0;
delta = 3;

    phasexzw = {};
    spectrumxzw = {};
    xz = {};
    z =[];
    n = 1;



%%
set(H,'shutter',initial_shutter_speed);
display(['the shutter speed is ' num2str(get(H,'shutter'))]);
shutter_speed = get(H,'shutter');
 z(n) = find_position(s,2);
%The code begins here
while n <= number_of_scans
    fclose(s{1})
    fopen(s{1})
    fclose(s{2})
    fopen(s{2})
       
    display(['measuring the field at z =' num2str(z(n))]); 
    
   
        [x, phase,spectrum] = scan_x(s,vid,bg,.17,.02);
    

    phasexzw{n} = phase;
    spectrumxzw{n} = spectrum;
    xz{n} =x;  
    %title(z(n))
    
    %make the assignments to the work space
    assignin('base', 'phases', phasexzw);
    assignin('base', 'spectrums', spectrumxzw);
    assignin('base', 'xes', xz);
    %%%
    
    move_stage(s,-step_size,2)
    move_stage(s,-step_size/2,3)
    n = n+1; 
    z(n) = find_position(s,2);
   
    if z(n)<=0;
        %set(H,'shutter',shutter_speed-delta);
    else
        %set(H,'shutter',shutter_speed+delta);
    end
    
    
    shutter_speed = get(H,'shutter');
    display(['the shutter speed is ' num2str(shutter_speed)])
        
        
    
end

%move_to_position(s,pos1, 2)
%move_to_position(s,pos2, 3)

end