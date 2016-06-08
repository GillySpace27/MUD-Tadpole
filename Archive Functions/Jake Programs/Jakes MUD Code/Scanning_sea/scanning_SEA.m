
function [Unk,lam2,time,t] = scanning_SEA(s,vid,bg,nop,range,Ref,points,lam)
%% options 
% start with the stage at 0 delay
% nop is the number of delay points 
% scanning range is range
c=3e8;

tic;
axis = 1;
home = find_position(s,axis); %finding the initial position

%% the actual code starts here

%loop 1 to find the edge of the beam

%move_to_position(s,home-range-0.1,axis);
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
Unk=zeros(3000,n);
current_x = initial_x;
while n<=nop;
    I1=(snap(vid)-bg);
    [Unk(:,n),lam2,time]=Sea_tad(I1,Ref,points,lam);
    x(n) = initial_x +a*(n-1);
    move_to_position(s,initial_x+a*n,axis);
    % the time for each step is
    t(n)=(n-1)*a*1e-3/c;
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