%% This script takes a reference and an interferogram and outputs the unknown pulse.
%
clc
clear
close all

%% Parameters

%What files should be analyzed?

%Reference with one of the arms blocked: Tadpole Trace
reffile = 'Calibrated Traces\ref 4-14.jpg';

%Interference Trace from Tadpole
interferogramfile = 'Calibrated Traces\flat 4-14.jpg';

%The "Speck.dat" file from the grenouille
grenfile = 'Calibrated Traces\gren ref 4-13\FrogFile-13-Apr-2015-16-23-14.Speck.dat';

%Add the reference phase from the gren?
phaseadd = 0;

%Add a bunch of spectral zeros to increase temporal resolution?
addZeros = true;

%Number of points on the x-axis of the traces
Nw=1280; 

%Calibration of the Wavelength Axis
dl = 0.050427e-9; %meters per pixel
%lowestLambda = 763.01e-9; %first wavelength on the camera (calibrated)
lowestLambda = 756.5e-9; %seems to be actual closest match

highestLambda = lowestLambda + dl*(Nw-1); 
lam = lowestLambda:dl:highestLambda;
blam = lam*1e9;
w = fliplr(equally_spaced_w_m(lam));
t=wtot(w);



% This sets up the wavelenth and time axes (Depricated)
% The max/min value of the wavelength distribution is:
% lam0 = 795e-9; %Center wavelength
% rangel = 50e-9; %Wavelength range
% lmax=lam0+rangel/2;
% lmin=lam0-rangel/2;
% dl=(lmax-lmin)/(Nw);
% lam=[-Nw/2*dl:dl:(Nw/2-1)*dl]+lam0;

%Import the traces
I1 = tadimport(interferogramfile);
Ref1 = tadimport(reffile);

%Plot the traces
figure();
imagesc(I1);
title('Interferogram');
% figure();
% imagesc(Ref1);
% title('Reference');
% figure();
% imagesc(I1-Ref1);
% title('Trace');

%% Figure out the spectrum and spectral phase (This is the main program)
[phi,spectrum,la]= find_phi_jake2(rot90(I1),rot90((Ref1)),.1);   

phi = unwrap(phi);
phi = phi - phi(Nw/2); %% make the center be zero phase



%% Retrieve the reference phase determined by a grenoullie
delimiter = '\t';
formatSpec = '%f%f%f%*s%*s%[^\n\r]';
fileID = fopen(grenfile,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter,  'ReturnOnError', false);
fclose(fileID);

refLam = flipud(dataArray{:, 1})' .* 10^-9;
refSpec = flipud(dataArray{:, 2})';
refPhase = flipud(dataArray{:, 3})';

%Generate a longer refPhase interpolation with the right number of points
longRphase = spline(refLam, refPhase, lam);

%% Add in the grenoullie reference phase.
if phaseadd == 1
   newphi = phi + longRphase;
else
   newphi = longRphase;
end

%% Add zeros to the edges to increase resolution.
if addZeros
    zerofactor = 10000;
    buffer = zeros(1, zerofactor);
    
    spectrum = [buffer spectrum buffer];
    newphi = [buffer newphi buffer];
    
    wavesize = 2 * zerofactor + 1000;
    
    tfirst = t(1);
    bfirst = blam(1);
    
    tsecond = t(2);
    bsecond = blam(2);
    
    dt = tsecond - tfirst;
    db = bsecond - bfirst;
    
    tlast = t(end);
    blast = blam(end);
    
    frontTbuf(zerofactor) = 0;
    frontBbuf(zerofactor) = 0;
        
    backTbuf(zerofactor) = 0;
    backBbuf(zerofactor) = 0;
        
    fstart = tfirst - zerofactor * dt;
    bstart = bfirst - zerofactor * db;
    for n = 1:zerofactor
        frontTbuf(n) = fstart + (n-1)*dt;
        backTbuf(n) = tlast + n*dt;
        frontBbuf(n) = bstart + (n-1)*db;
        backBbuf(n) = blast + n*db;
    end
    
    t = [frontTbuf t backTbuf];
    blam = [frontBbuf blam backBbuf];
    
else
    wavesize = Nw;

end

%% Regenerate the full unknown pulse in lambda domain
Ew=sqrt(spectrum).*exp(-1i*newphi);


% Plot the spectrum and spectral phase of the unknown pulse:
figure;
hold on;

title('Spectrum (Blue), Spectral Phase (Green)');

%Phase blanking
pphi(wavesize) = 0;
for n = 1:wavesize
   if spectrum(n) < 0.05
       pphi(n) = nan;
   else
       pphi(n) = newphi(n);
   end
end

spect = norm1(abs(Ew).^2);
uphi = unwrap(pphi);

lastreal = zerofactor + Nw;
real = [zerofactor:lastreal];

%Plot the stuff in the freq domain
[ax, p1, p2] = plotyy(blam(real),spect(real),blam(real),uphi(real),'plot','plot');

ylabel(ax(1),'Spectral Intensity') % label left y-axis
ylabel(ax(2),'Spectral Phase') % label right y-axis
xlabel(ax(2),'Wavelength (nm)') % label x-axis
axis(ax(2), [705, 920, -15 ,15]) %standardize the phase axis
axis(ax(1), [705, 920, 0 ,1]) 
%set(ax(2), 'YTickMode', 'auto')

% Plot the pulse in time domain:
figure()
ret_Ut = fftc(Ew,[],2);
bret_Ut = norm1(abs(ret_Ut).^2);

plot(t,bret_Ut,'r');

%[ax, p1, p2] = plotyy(t,bret_Ut,t,imag(ret_Ut),'plot','plot');

xlabel('Time (s)');
title('Temporal Profile');
axis([-5E-12 5E-12 -0.05 1]); 




%% Finding the GVD of the glass

% Speed of Light
%c = 3e2; %nm/fs

% for n = 1:1000
%     if isnan(uphi(n))
%         uphi(n)


%derivative = mydiff(uphi, dl*1e9);

%derivative2 = mydiff(derivative, dl*1e9);


% %Convert to freq domain from lam domain
% deriv2freq(1000) = nan;
% for n = 1:1000
%    deriv2freq(n) = derivative2(n)*lam(n)^4 / (4*pi^2*c^2);
% end

%Plot all the derivatives
% figure;
% title('First Derivative')
% plot(blam,uphi,'k')
% hold on
% plot(blam,derivative,'om');
% 
% [dfit, good, output] = fit(blam, uphi, 'smoothingspline');
% 
% plot(blam, dfit, 'c')

% plot(lam*1e9,derivative2, 'oc');


% figure;
% plot(lam*1e9,derivative2,'oc');
% title('Second Derivative')
% figure;
% plot(lam*1e9,deriv2freq,'ok');
% title('Second Derivative Freq')









