% this function makes a MUD TADPOLE trace out the FFT of the images:
% Fint = fft AC terms of the MUD trace
% tau = the delay corresponding to the trace

function [MUD_trace,delay1]=mud_tad_fft(Fint,tau,MUD,delay,k)
tau1=ones([size(Fint,1),1]);
if k==1
    MUD_trace=Fint;
    delay1=tau1*tau;
else
    delay1=cat(1,delay,tau1);
    MUD_trace=horzcat(Fint,MUD);
end

