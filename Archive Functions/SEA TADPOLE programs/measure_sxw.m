function [spectrum,x] = measure_sxw(s,vid, bg);

% This function uses make_vector which uses fit_phase and find_phi. It also uses
% find_position and  move_stage for controlling the motorozed actuator
% through the serial port.
%[v1,v2,x] = measure_phase_front(s,vid,bg);
%v1 is a vector of delays as a function of x and v2 is the GDD as a
%function of x.  s is the serial port object, vid is the ccd camera object
%and bg is the back ground wich is subtracted.

%%%Options
%specify the step size in mm for moving the motorized actuator
a = .02;
xc = 1.15;
xf = xc+.2;
xi = xc-.3;
x = [xi:a:xf];
H = getselectedsource(vid);
%%%


move_to_position(s,xi);
    
%%%
%Here I am trying to make sure that the program doesn't start until the
%stage is in the correct position
    
    function hold_on(s,T);
        t = timer('TimerFcn','disp(''Ready to Start!'')','StartDelay',T);
        start(t);
        wait(t);
    end

hold_on(s,2);
%%%

spectrum = [];
display_position(s);
display_position(s);
x = [];




figure



m = 0;
n = 1;
d =find_position(s)


    while d < xf;

    dat = fw_snap(vid);
    speck = sum(dat-bg);
    %speck = speck-speck(5);
    
    spectrum(end+1,:) = speck;
    plot(speck);
   
    %title(display_position(s));
 
   x(end+1) = xc+a*n;
    
    
    d = find_position(s);
       title(d);
     n= n+1;
     move_stage(s,a);
    hold_on(s,1);
    end



end