% This function plots the unknown pulse in time:
% Unk = MxN matrix where M = freq 
% and N = position
% w = freq axis

function [Ut]=plot_unk1(Unk,w)
t=wtot(w);
Ut=fftc(sum(Unk,2));
plot(t,abs(Ut))
xlabel('Time (s)');
ylabel('Amplitude');
title('The unknown pulse in time');
