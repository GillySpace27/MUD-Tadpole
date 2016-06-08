function time =time_axis(cal,numberofpoints, l0);

%time = time_axis(calibration, numberofpoints, lam)
%Given the calibration of the wavelength axis and the number of points
%needed this function returns a vector that describes the time axis.

c = 3e8;
nm = 1e-9;
if nargin == 2;
    l0 = 800;
end

nop = numberofpoints;
deltat = (l0.^2*nm.^2)/(c*cal*nm*nop);


%tau = total_time(cal);
t = [1:nop]*(deltat)*1e12;
tnew = t-mean(t);
time = tnew;