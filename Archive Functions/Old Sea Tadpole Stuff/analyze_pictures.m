%% This script takes a reference and an interferogram and outputs the unknown pulse.
%
clc
clear
close all

%% Parameters

%What files should be analyzed?

%Reference with one of the arms blocked: Tadpole Trace
reffile = 'C:\Users\Chris\Dropbox\Spring 2015\Trebino\All-Sea-Tadpole\Calibrated Traces\ref 4-14.jpg';

%Interference Trace from Tadpole
interferogramfile = 'C:\Users\Chris\Dropbox\Spring 2015\Trebino\All-Sea-Tadpole\Calibrated Traces\flat 4-14.jpg';

%The "Speck.dat" file from the grenouille
grenfile = 'C:\Users\Chris\Dropbox\Spring 2015\Trebino\All-Sea-Tadpole\Calibrated Traces\gren ref 4-13\FrogFile-13-Apr-2015-16-23-14.Speck.dat';


%Add a bunch of spectral zeros to increase temporal resolution?
addZeros = 1;

%Number of points on the x-axis of the traces
Nw=1280; 

%Calibration of the Wavelength Axis
dl = 0.050427e-9; %meters per pixel
lowestLambda = 763.01e-9 - 2*3.25e-9; %first wavelength on the camera (calibrated)
% lowestLambda = 746.5e-9; %seems to be actual closest match

highestLambda = lowestLambda + dl*(Nw-1); 
lam = lowestLambda:dl:highestLambda;
blam = lam*1e9;

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
% figure; plot(lam,spectrum,lam,smooth(spectrum, 21));
% spectrum = smooth(spectrum, 21);
phi = unwrap(phi);
phi = phi - phi(Nw/2); %% make the center be zero phase
% phi = smooth(phi, 21)';


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
refSpec = spline(refLam, refSpec, lam);
% spectrum = spline(refLam, refSpec, lam);
% plot(spectrum);

%Add the reference phase from the gren?
phaseadd = 1;

%% Add in the grenoullie reference phase.
if phaseadd == 1
   newphi = -longRphase + phi;
else
   newphi = phi;
end

%% Add zeros to the edges to increase resolution.
    zerofactor = 10000; %How many zeros to add to each side
    %convert to frequency
    low_w = 2*pi*3e8/lam(end);
    high_w = 2*pi*3e8/lam(1);
    dw2 = (high_w - low_w)/Nw; 

    % wavelength values corrresponding to equally spaced frequency points,
    %  centered at the middle of the wavelength range.
    Lp= (2.*pi.*(3E8))./(0.5*(high_w+low_w)+dw2*(-Nw/2:Nw/2-1)); 

    % Have to interpolate intensity and phase separately or the spectrum gets
    % weird.
    spectrumw = spline(lam, spectrum, Lp);
    newphiw = spline(lam, newphi, Lp);
    
    spectrumwpad = padarray(spectrumw, [ 0 zerofactor ]);
    newphiwpad = padarray(newphiw,  [ 0 zerofactor ]);
    
    w = spline(-Nw/2:Nw/2-1, (0.5*(high_w+low_w)+dw2*(-Nw/2:Nw/2-1)), (-zerofactor-Nw/2:zerofactor+Nw/2-1));
    t = wtot(w);

%     wavesize = 2 * zerofactor + Nw;

%% Regenerate the full unknown pulse in frequency domain
Ew=sqrt(spectrumwpad).*exp(-1i*newphiwpad);
ret_Ut = fftc(Ew,[],2); %complex time domain field

% Plot the spectrum and spectral phase of the unknown pulse:
figure;
hold on;

title('Spectrum (Blue), Spectral Phase (Green)');

%Phase blanking
pphi = zeros(1, length(spectrum));
for n = 1:length(spectrum)
   if spectrum(n) < 0.01
       pphi(n) = nan;
   else
       pphi(n) = newphi(n);
   end
end

% spect = norm1(abs(Ew).^2);
% uphi = unwrap(pphi);
% lastreal = zerofactor + Nw;
% real = [(zerofactor+1):lastreal];

%Plot the stuff in the freq domain
[ax, p1, p2] = plotyy(blam,norm1(spectrum),blam,newphi,'plot','plot');


% [ax, p1, p2] = plotyy(blam(real),spect(real),blam(real),uphi(real),'plot','plot');

ylabel(ax(1),'Spectral Intensity') % label left y-axis
ylabel(ax(2),'Spectral Phase') % label right y-axis
xlabel(ax(2),'Wavelength (nm)') % label x-axis
axis(ax(2), [705, 920, -15 ,15]) %standardize the phase axis
axis(ax(1), [705, 920, 0 ,1]) 
%set(ax(2), 'YTickMode', 'auto')
figure;
plot(lam, norm1(spectrum), lam, norm1(refSpec));

% Plot the pulse in time domain:
figure()

bret_Ut = norm1(abs(ret_Ut).^2);
temporalphase = unwrap(angle(ret_Ut));
temporalphase = temporalphase - temporalphase(length(temporalphase)/2);

% plot(t,bret_Ut,'r');
[ax, p1, p2] = plotyy(t, bret_Ut,t,temporalphase,'plot','plot');
%[ax, p1, p2] = plotyy(t,bret_Ut,t,imag(ret_Ut),'plot','plot');

xlabel('Time (s)');
title('Temporal Profile');
axis(ax(1), [-2E-13 2E-13 -0.05 1]); 
axis(ax(2), [-2E-13 2E-13 -20 20]); 



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


%     
%     %Now we need to generate a new index for these arrays
%     %Both the time and the lambda axes
%     tfirst = t(1);
%     bfirst = blam(1);
%     
%     tsecond = t(2);
%     bsecond = blam(2);
%     
%     dt = tsecond - tfirst;
%     db = bsecond - bfirst;
%     
%     tlast = t(end);
%     blast = blam(end);
%     
%     %initialize the new x-axis buffers
%     frontTbuf(zerofactor) = 0;
%     frontBbuf(zerofactor) = 0;
%     backTbuf(zerofactor) = 0;
%     backBbuf(zerofactor) = 0;
%        
%     %What are the values at the beginning of the index arrays?
%     fstart = tfirst - zerofactor * dt;
%     bstart = bfirst - zerofactor * db;
%     
%     %Now build the index arrays
%     for n = 1:zerofactor
%         frontTbuf(n) = fstart + (n-1)*dt;
%         backTbuf(n) = tlast + n*dt;
%         frontBbuf(n) = bstart + (n-1)*db;
%         backBbuf(n) = blast + n*db;
%     end
%     
%     %And concatenate them to the original index arrays
%     t = [frontTbuf t backTbuf];
%     blam = [frontBbuf blam backBbuf];
%     
% else
%     wavesize = Nw;
%     zerofactor = 0;
% end



% This sets up the wavelenth and time axes (Depricated)
% The max/min value of the wavelength distribution is:
% lam0 = 795e-9; %Center wavelength
% rangel = 50e-9; %Wavelength range
% lmax=lam0+rangel/2;
% lmin=lam0-rangel/2;
% dl=(lmax-lmin)/(Nw);
% lam=[-Nw/2*dl:dl:(Nw/2-1)*dl]+lam0;





