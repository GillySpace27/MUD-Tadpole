function hold_on(T);

%This function makes a program wait for an amount of time in seconds T;   

t = timer('TimerFcn','disp('''')','StartDelay',T);
start(t);
wait(t);
