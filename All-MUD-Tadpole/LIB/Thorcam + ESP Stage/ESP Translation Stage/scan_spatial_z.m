function [Ixz, xz,z] = scan_spatial_z(s,vid,spot_size,bg, number_of_scans);
%[phasexzw, spectrumxzw, xz,z] = scan_z(s,vid,bg,cal, number_of_scans);

%%
crash
step_size = .01;  %scan z in steps of 0.25mm
H = getselectedsource(vid);
pos1 = find_position(s,2);
pos2 = find_position(s,3);
initial_shutter_speed = 1800;
max_shutter_speed = 120;
diff = max_shutter_speed - initial_shutter_speed;
delta = abs(floor(diff/((number_of_scans-1)/2)));


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

   
    [x, Ix] = scan_spatial(s,vid,spot_size,bg);
    

    xz{n} = x;
    Ixz{n} = Ix;  
   
    
    move_stage(s,step_size,2)
   
    n = n+1; 
    z(n) = find_position(s,2);
   
    if n>=6;
        if n<=number_of_scans;
            set(H,'shutter',shutter_speed+delta);
        end
    else
        set(H,'shutter',shutter_speed-delta);
    end
    
    shutter_speed = get(H,'shutter');
    display(['the shutter speed is ' num2str(shutter_speed)]) 
    
end



end