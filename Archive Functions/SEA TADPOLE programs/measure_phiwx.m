function [phase, x, spectrum] = measure_phiwx(s,vid,bg,cal, spot_size);

%The fiber has to be near the center of the beam before starting this
%program

%%%Maybe this will help the display position command work
fclose(s)
fopen(s)
%close(figure(1))
%%%Options
plot_phase_front = true;
thresh = 0.0085;

%specify the step size in mm for moving the motorized actuator
z_location = find_position(s,2);
move_to_position(s,0,1);
if nargin == 4;
    spot_size = abs(z_location)*.3/2+.03;

end
home = find_position(s);
skip = false;
if z_location < .4 & z_location>=-.4&skip == false;
    a = (spot_size/40);
    display('using higher spatial resolution')
    
   
else
    a = (spot_size/30);
    display('using lower spatial resolution')
   
end
    
 home2 = home-10*a;

%Some prelminary functions    
function hold_on(T);
        t = timer('TimerFcn','disp(''Ready to Start!'')','StartDelay',T);
        start(t);
        wait(t);
end

function test_shutter_speed(vid); 
    display('testing shutter speed');
    test = max(max(fw_snap(vid)));
    H = getselectedsource(vid);
    shutter_speed = get(H,'shutter');
        if abs(z_location) < 1;
            step = 1;
        else
            step = 3;
        end
        
        while shutter_speed<2850 & test > 254 &round(z_location*100)/100~=0;
            shutter_speed = shutter_speed+step;
            set(H, 'shutter', shutter_speed);
            display(['setting the shutter speed to ' num2str(shutter_speed)]) 
            test = max(max(fw_snap(vid)));
        end
        while  test < 60& round(z_location*100)/100~=0;
            if test<254
                shutter_speed = shutter_speed-step;
            end
            set(H, 'shutter', shutter_speed);
            display(['setting the shutter speed to ' num2str(shutter_speed)]) 
            test = max(max(fw_snap(vid)));
        end
        if round(abs(z_location*100))/100<=.4;
           shutter_speed = 2848;
           set(H, 'shutter', shutter_speed);
           display(['z = 0, so setting the shutter speed to ' num2str(shutter_speed)]) 
        end
end

test_shutter_speed(vid);
move_to_position(s,home2);
hold_on(2);
%%%

% the actual code starts here
phase = [];
x = [];
spectrum = [];

dat = fw_snap(vid);
[h,cent] = max(dat(400,:));

test = Norm((abs(fftc(dat(:,cent))))); 
[pks,h] = lclmax(test,10,thresh);
   n = 1;
%close all
%figure
hold on
while length(pks) == 3;
    [phi, spec] = find_phi(dat-bg, bg, vid);
    spectrum(n,:) = spec;
    phase(n,:)= phi; 
    x(n) = find_position(s);
    move_stage(s,a);
    n =n+1;
    dat  = fw_snap(vid);
    test = Norm((abs(fftc(dat(:,cent))))); 
    [pks,h] = lclmax(test,10,thresh);
end

move_to_position(s,home2-a); 
hold_on(6);

%close(figure(1));

dat = fw_snap(vid);
%imagesc(dat);
%close all
test = Norm((abs(fftc(dat(:,cent))))); 
[pks,h] = lclmax(test,10,thresh);

phase2 = [];
spectrum2 =[];
x2 = [];

%close all;
%figure(1)
hold on
while length(pks) == 3;
    [phi, spec] = find_phi(dat,bg, vid);
   
    spectrum2(end+1,:) = spec;
    phase2(end+1,:) = phi;
    x2(end+1) = find_position(s);
    move_stage(s,-a);
    dat = fw_snap(vid);
    test = Norm((abs(fftc(dat(:,cent))))); 
    [pks,h] = lclmax(test,10,thresh);
end

phase = [(flipud(phase2))' phase'];

x = [fliplr(x2) x];
spectrum = [(flipud(spectrum2))' spectrum'];
move_to_position(s,home);

    if plot_phase_front == false;
        [v,phasefit,ebars] = fit_phase(phase',cal);
        close(figure(1));
        plot(x,v,'.');
    end

%close all

end