function calib = sp_calibration(spectra,etalon_spacing,lam0)
% function calibrate sp_calibartion(specta,etalon_spacing,lam0)
% Spectrometer calibration using an etalon

close all
s = spectra;
et = etalon_spacing;
t = .3;

if nargin == 2;
    lam0 = 810;
    display('using 800 nm as the center wavelength');
end

%B = sum(s);
B= (norm1((s)));
[pks, h] = lclmax((B), 30,t);
s  = length(pks);
%plot(B);
% hold on

%%%
%data for the etalon
n = lam0.^2/(2*et*1e3);
lams = [];
l1 = lam0-round(n/2)*s;
m =1;
while m<=  s;
    lams(m) = l1;
    m = m+1;
    l1 =l1+n;
end
lams = lams';
m = size(lams);

%%%
%plot(pks,h,'or');
length(lams);
%figure
%plot(pks,lams);
fit1 = polyfit(pks,lams,1);
% hold on
%plot(pks,lams,'o');
calib = fit1(1);
display(['the calibration is ' num2str(calib) 'nm/pix'])
