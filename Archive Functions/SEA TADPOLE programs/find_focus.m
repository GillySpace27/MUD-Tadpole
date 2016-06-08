function find_focus(dcam);

figure('WindowButtonDownFcn',@click_callback);

global no_click;
no_click = true;
n = 0;

while no_click
    n= n+1;

    this_frame = fw_snap(dcam);
    a = this_frame;
    a = sum(a);
    a = a-a(10);
    plot(a);
    
    title(FWHM(Norm(a)));
end

last_frame = this_frame;
clear this_frame;

function click_callback(src,eventdata)
global no_click;
disp('Stopping the camera...');
no_click = false;
