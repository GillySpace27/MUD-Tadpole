
function test_shutter_speed(vid); 
    display('testing shutter speed');
    test = max(max(fw_snap(vid)));
    
    shutter_speed = get(H,'shutter');
    step = 1;
        while  test < 60;
            if test<254;
                shutter_speed = shutter_speed-step*5;
            end
            set(H, 'shutter', shutter_speed);
            display(['setting the shutter speed to ' num2str(shutter_speed)]) 
            test = max(max(fw_snap(vid)));
        end
        while shutter_speed<2845 & test > 254;
            if shutter_speed<2845
                shutter_speed = shutter_speed+step*5;
            else
                 shutter_speed = shutter_speed+step;
            end
            set(H, 'shutter', shutter_speed);
            display(['setting the shutter speed to ' num2str(shutter_speed)]) 
            test = max(max(fw_snap(vid)));
        end
end