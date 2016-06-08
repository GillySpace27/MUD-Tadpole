function [x, Ix] = scan_spatial(s,vid,spot_size,bg);
%This program measures the phase and spectrum at each x along the
%crossection of a focusing beam
%[x, phase,spectrum] = scan_x(s,vid,bg,cal,spot_size)

%options 
find_edge =true;
min_int = 0.015;
axis = 1;
home = find_position(s,axis);
nop = 100;

preview(vid)

%%

current_x = find_position(s,axis);
move_to_position(s,-spot_size+current_x,axis);
H = getselectedsource(vid);
a = spot_size/nop;
max_x = spot_size+current_x;
%%

% the actual code starts here
%loop 2 to take the data

n = 1;

while current_x<=max_x;
    x(n) = find_position(s,axis);
    Ix(n,:) = sum(fw_snap(vid)-bg);
    current_x = x(n);
    move_stage(s,a,axis);    
    n = n+1;
end

move_to_position(s,home-.01,axis);
move_to_position(s,home,axis);
x = (x-mean(x))*1000;
Ix = Ix(2:end,:);
x = x(2:end);
imagesc(Ix);
Ix = sum(Ix');
Ix = Norm(Ix-Ix(end));
end