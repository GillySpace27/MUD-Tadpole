function [phasexyw, spectrumxyw, xy,y] = scan_y(s,vid,bg,cal, number_of_scans);
%[phasexzw, spectrumxzw, xz,z] = scan_z(s,vid,bg,cal, number_of_scans);

%%

step_size = .01;  %scan z in steps of 0.25mm
H = getselectedsource(vid);



%%

%The code begins here
n = 1;
y(n) = find_position(s,1);
while n <= number_of_scans

   
    
    display(['measuring the field at y =' num2str(y(n))]); 
    
   
    [x, phase,spectrum] = scan_x(s,vid,bg,.188,500);
    

    phasexyw{n} = phase;
    spectrumxyw{n} = spectrum;
    xy{n} =x;  
    %title(z(n))
    
    %make the assignments to the work space
    assignin('base', 'phases', phasexyw);
    assignin('base', 'spectrums', spectrumxyw);
    assignin('base', 'xes', xy);
    %%%
    move_stage(s,-step_size,1)

    n = n+1; 
    y(n) = find_position(s,1);
 
    
end



end