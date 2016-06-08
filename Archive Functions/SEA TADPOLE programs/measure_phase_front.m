function [v,phasereal, phase,x,ebars] = measure_phase_front(s,vid,bg, cal);

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
H = getselectedsource(vid);
c1 = 300;
c2 = 500;

tolerance = .054;
%%%
clear dat
if nargin == 2;
    bg = 0;
    
end

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
display_position(s);
display_position(s);

%%%

v = [];

x = [];
ebars = [];
phasereal = [];
phase = [];
figure
lam = lam_axis(cal, 1024, 825);% this should really have lo not 817 here
omega = ltow(lam)-ltow(800);


m = 0;
n = xi;
d =find_position(s);
phase = [];
phasereal = [];
    
n = 0;
   while d < xf;
    dat = fw_snap(vid);
   phi = find_phi(dat-bg);
   phasereal(end+1,:) = phi;
 
   %x(end+1) = find_position(s);
   x(end+1) = xc+a*n; 
   
   fit = polyfit(omega(c1:c2),phi(c1:c2),2); 
   phase(end+1,:) = omega.^2*fit(1)+omega*fit(2)+fit(3);
    
    d = find_position(s);
       title(d);
    
      diff = mean(((phase(end,c1:c2))-phi(c1:c2)).^2)
    m= 1;
    
    plot(phasereal(end,c1:c2))
    hold on
    plot(phase(end,c1:c2),'g')
    while diff>tolerance & m<3
        dat = fw_snap(vid);
        phi = find_phi(dat-bg);
        phasereal(end,:) = phi;
        fit = polyfit(omega(c1:c2),phi(c1:c2),2) 
        phase(end,:) = omega.^2*fit(1)+omega*fit(2)+fit(3);
        
        plot(phasereal(end,c1:c2))
       hold on
       plot(phase(end,c1:c2),'g')
        
        m = m+1;
    end
       
       v(end+1) = fit(2);
    
  
         ebars(end+1) = diff;
    
    
     move_stage(s,a);
    hold_on(s,1);
    
    n = n+1;
    end
this_frame = dat;
clear this_frame;

close(figure(1))

plot(v,'.')

end
