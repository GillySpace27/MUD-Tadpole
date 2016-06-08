function [x, phase,spectrum] = scan_x(s,vid,bg,nop,range,axis);
%This program measures the phase and spectrum at each x along the
%crossection of a focusing beam.  Run the program like this:
%[x, phase,spectrum] = scan_x(s,vid,bg,nop,range,axis)
%
%inputs:    s           the serial port object for the stages
%           vid         the video object
%           bg          the image of the reference spectrum
%           nop         the number of points to collect
%           range       2 times the scanning range
%           axis        the axis to scan which is 4 by default.
%outputs:   x           the values of x where E(w) was found
%           phase       the retrieved spectral phase at every x (a matrix)
%           spectrum    the spectrum at each x (a matrix)
%% options 

tic; %to start a timer
thresh = 0.003;
if nargin==5
    axis = 4;
end
home = find_position(s,axis); %finding the initial position
a = .05;
preview(vid)

%% Finding the peaks
dat = fw_snap(vid);
b = (fftc(dat-bg));
B = (Norm(abs(mean(b'))));  

%[peaks, h] = smart_lclmax(B);
pks  = [439 513 587];
display(['using ' num2str(pks) ' for the peaks'])
%if length(pks)<3;
    %pks =  [439 513 587];
    %display('less than three peaks were found!')
%end
%% the actual code starts here

%loop 1 to find the edge of the beam
skip = true; 
while length(pks) >= 2&& skip == false;
    move_stage(s,-a,axis);
    dat  = fw_snap(vid);
    B = Norm(abs(mean(fft(dat)')));   
    [pks,h] = lclmax(B,10,thresh);
end

if skip== false
    current_x = find_position(s,axis);
    initial_x = current_x;
else
    move_to_position(s,home-range-0.1,axis);
    move_to_position(s,home-range,axis);
    initial_x = find_position(s,axis);
end

max_x = home+range;
a = range*2/nop; %step size
display(['The starting position is ' num2str(initial_x)]);
display(['The home position is ' num2str(home)]);
display(['The ending position is ' num2str(max_x)]);

%loop 2 to take the data
n = 1;
current_x = initial_x;
while current_x<=max_x;
    [phi,spec]= find_phi_scanning(bg,vid,pks);
    x(n) = initial_x +a*(n-1);
    current_x = x(n);
    phase(n,:) =phi;
    spectrum(n,:) = spec;
    move_to_position(s,initial_x+a*n,axis);    
    n = n+1;
end
%% going home and plotting the result
move_to_position(s,home-.1,axis);
move_to_position(s,home,axis);
x = (x)*1000;
imagesc([],x,spectrum);
toc %to stop the timer and print out the total time of the scan
end