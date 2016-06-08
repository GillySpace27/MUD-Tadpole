% this program calibrates the single shot MUD with a double pulse:
% I_spec = the retrieved spectrogram
% tau = the time delay between pulses in the double pulse
% dt = is the calibration along the delay dimension

function [dt]=double_cal_mud(I1,tau)
% First, the spectrogram is summed along the wavelength dimension:
Is=Norm(sum(abs(I1),2));
% Then, the two peaks are found:
[x1, x2] = lclmax(Is,20,.1);
dx=abs(diff(x1));
% the delay calibration is:
dt=round(tau/dx);
