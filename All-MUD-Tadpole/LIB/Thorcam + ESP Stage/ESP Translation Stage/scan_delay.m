function [spectra, temp_int ,delay,t,phases] = scan_delay(s,vid,bg,cal, real_spec);

fclose(s)
fopen(s)

home = find_position(s,3);
step_size = .3;  %scan z in steps of 0.25mm
num_steps = 10;
phases = [];
spectra = [];
delay = [];
temp_ints = {};
%some preliminary functions
function hold_on(T);
        t = timer('TimerFcn','disp(''Ready to Start!'')','StartDelay',T);
        start(t);
        wait(t);
end
%The code begins here
move_stage(s,-step_size*round(num_steps/2),3);
hold_on(1);
n = 1;        
hold on
while n <= num_steps
    delay(n) = find_position(s,3)-home;    
    dat = fw_snap(vid); 
    [phi,spec]= find_phi(dat,bg,vid);
    phases(n,:) = phi;
    spectra(n,:) = Norm(spec);
    [t, et] = find_et(-phi, spec, cal);
    %plot(spec);
    
    temp_int{n} = Norm(abs(et).^2);
    move_stage(s,step_size,3);
    n = n+1
end
lam = lam_axis(.177,1024);

close all
figure
hold on;
plot(lam,spectra');
if nargin == 5;
    [t2, et2] = find_et(-phases(round(num_steps/2),:), real_spec, cal);
    real_spec = sum(real_spec);
    plot(lam,Norm(real_spec-real_spec(1)));
end
figure
hold on;
delt = step_size/300*2*1000;
m = size(temp_int);
m = m(2);
n = 1;
while n<=m;
    plot((t-delt*(n-1)),temp_int{n});
    n = n+1;
end;

if nargin == 5;
    plot(t-delt*(round(num_steps/2)-1),Norm(abs(et2).^2),'g');
end
move_to_position(s,home, 3)
end