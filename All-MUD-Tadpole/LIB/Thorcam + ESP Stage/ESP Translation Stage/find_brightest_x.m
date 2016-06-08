function home = find_brightest_x(vid,s);
    display('finding the center')
    int = [];
    l = [];
    r = a*20;
    pos0 = find_position(s,axis);
    move_stage(s,-r/2,axis);
   
    pos = find_position(s,axis);
    n = 1;
    dist = 0;
    while dist<(r) 
        int(n) = max(max(fw_snap(vid)));
        l(n) = find_position(s,axis);
        move_stage(s,a*2,axis);
        
        n = n+1;
        dist = n*a;
    end
    [pk,h] = max(int);
    home = l(h)
    move_to_position(s,home,axis);
   
end