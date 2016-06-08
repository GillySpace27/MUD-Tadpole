function last_frame = fw_spec(dcam);

%dat1 = fw_snap(dcam);
%dat1 =dat1/max(max(dat1));
closepreview(dcam)

figure('WindowButtonDownFcn',@click_callback);

global no_click;
no_click = true;
while no_click
    dat = fw_snap(dcam);
    %plot(dat(400,:))
    %b = fftc(dat);
    %imagesc(dat(620:690,520:570))
    imagesc(dat)
    %colorbar
    %plot(abs(b(:,600)))
end
last_frame = speck;
clear this_frame;

end
function click_callback(src,eventdata)
global no_click;
disp('Stopping the camera...');
no_click = false;
end

