function lam =lam_axis(cal,numberofpoints,lo);

%lam =lam_axis(cal,numberofpoints,lo)
%cal is the calibration for the wavelength axis and numberofpoints is the
%number of points on the wavelength axis and lo is the center wavelength.
%IF the center wavelength is not specified 800mn will be used
%Given the calibration of the wavelength axis and the number of points
%needed this function returns a vector that describes the time axis.


ni = nargin;


if ni<3
  lo = 800;  
  %display('using 800nm for the center wavlength')
end

nop = numberofpoints;

l = [1:nop]*cal;
lnew = l+lo-mean(l);
lam = lnew;