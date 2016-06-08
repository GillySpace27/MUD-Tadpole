
function [I,t] = get_FROG_full(s,vid,bg,nop,range);
%% options 
% start with the stage at 0 delay
% nop is the number of delay points 
% scanning range is range
tic;
axis = 1;
home = find_position(s,axis); %finding the initial position
preview(vid)

%% the actual code starts here

%loop 1 to find the edge of the beam

move_to_position(s,home-range-0.1,axis);
move_to_position(s,home-range,axis);
hold_on(2); 
initial_x = find_position(s,axis);
max_x = home+range;
a = range/nop; %step size
display(['The starting position is ' num2str(initial_x)]);
display(['The home position is ' num2str(home)]);
display(['The ending position is ' num2str(max_x)]);

%loop 2 to take the data
n = 1;
current_x = initial_x;
while n<=nop;
    dat =(fw_snap(vid)-bg);
    I(n,:) = sum(dat,1);
    x(n) = initial_x +a*(n-1);
    move_to_position(s,initial_x+a*n,axis);
    
    n = n+1;
end
x = x-mean(x);
%% going home and plotting the result
move_to_position(s,home-.1,axis);
move_to_position(s,home,axis);
t = (x)/300*2;
imagesc(I)
toc

end