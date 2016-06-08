function [] = go_home(s,d,d2)

%this function is to send the stages home which works better when moving
%the screws out or coming from the negative directions.

if nargin == 1;
    d = 0;
    d2 = 0;
end
    
if nargin == 2;
    d2 = d;
end

move_to_position(s,-.01,4)
move_to_position(s,d,4)
move_to_position(s,-.01,1)
move_to_position(s,d2,1)