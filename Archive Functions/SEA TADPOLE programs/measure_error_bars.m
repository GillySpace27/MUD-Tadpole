function [v,v2] = measure_error_bars(vid,bg); 
v = [];
v2 = [];
 if nargin == 1;
     bg = 0;
 end
figure('WindowButtonDownFcn',@click_callback);

global no_click;
no_click = true;

n = 0;
m =0;
while no_click
    n =n+1;
   [v,v2,m] = make_vector(v,v2,vid,bg,m);
    

end


end

function click_callback(src,eventdata)
global no_click;
disp('Stopping the camera...');
no_click = false;
end