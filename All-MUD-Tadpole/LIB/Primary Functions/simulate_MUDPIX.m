function [ MUDPIX, REF, SIM_PULSE ] = simulate_MUDPIX( )
% Creates a simulated MUDPIX array to test operation of the code.
% The MUDPIX file is a cell array.
%%  MUDPIX{:}  cell array of structs
% data - the full picture taken by the sea tadpole device
% pos - the position the picture was taken at in mm

% This array is extracted with extract_MUDPIX to get the spectrum 
% and phase, etc, from each picture.

fprintf('\n\nSimulating Traces')
tic

clear

%% Parameters
c=300; %nm/fs %% Everywhere in the code, base length is in nm, and time is in fs. Always.

% The dimensions of the camera in pixels:
Nx=1024; %In the spacially disperced direction
Nw=1280; %In the spectrally disperced direction

% How big is the actual CCD surface (in nm)
xmax=1.5e6; 
xmin=-1.5e6;

    dx=(xmax-xmin)/Nx;
    x=[xmin:dx:(xmax-dx)]; %This axis labels the x direction of the camera.

% Setting the wavelength axis
lam0=800; %Center wavelength
rangel=60; %Range of distribution

    lmax=lam0+rangel/2;
    lmin=lam0-rangel/2;
    dl=(lmax-lmin)/(Nw);
    lam=[-Nw/2*dl:dl:(Nw/2-1)*dl]+lam0; %This axis labels the lam direction of the camera.
    w = fliplr(equally_spaced_w((lam))); %Not sure why there is a fliplr, but it makes it work.
    w_0=mean(w);
    dw=abs(mean(diff(w)));
    [xx,ww]=meshgrid(x,w); % Making the 2D Grid
    kk=ww/c; % Converts frequency to wave number


% Delay of the unknown pulse
tau = 1.5e3;

% The fiber separation is:
d = 0.5e6;

%The focal length of the collimating lens is:
f = 100e6;

% The intial width of the pulse out of the oscillator is 6nm:
delta_l = 6;
    
    delta_w = 2*pi*c/lam0^2*delta_l;

%The spacial dispersion of the reference gaussian:
sigmax=2000; 

% The GDD of the unknown pulse is: (not always used)
GDD=1e5;

% The temporal separation of the cross sections is:
tau1= 6000; %2.76/delta_w; %795; %fs

%Number of cross sections to be taken:
N=3;%round(20000/tau1);


%% The reference pulse is generated:
Ref=(exp(-((xx)/(sqrt(2)*sigmax*dx)).^2)).*exp(-((ww-w_0)/(sqrt(2)*delta_w)).^2).*(exp(1i*kk.*xx*d/f));


%% The unknown pulse is generated: (just pick one to uncomment)

%  A single pulse
%  Unk1=exp(-(xx/(sqrt(2)*Nx*sigmax*dx)).^2).*exp(-((ww-w_0)/(sqrt(2)*delta_w)).^2).*(exp(1i*tau*(ww-w_0)));
 
% A super chirped double pulse:
 Unk1=exp(-(xx/(sqrt(2)*sigmax*dx)).^2).*exp(-((ww-w_0)/(sqrt(2)*delta_w)).^2).*exp(-i*(ww-w_0).^2*GDD).*(exp(i*0*(ww-w_0)*tau)+exp(-i*1*(ww-w_0)*tau));

% A triple Pulse:
% Unk1=exp(-(xx/(sqrt(2)*sigmax*Nx*dx)).^2).*exp(-((ww-w_0)/(sqrt(2)*delta_w)).^2).*(exp(i*(-tau)*(ww-w_0))+exp(i*(0*tau)*(ww-w_0))+.5*exp(i*(-.2*tau)*(ww-w_0))+.5*exp(i*(-1.1*tau)*(ww-w_0))+.5*exp(i*(-1.2*tau)*(ww-w_0))+.5*exp(i*(-3.5*tau)*(ww-w_0))+.5*exp(i*(-2.5*tau)*(ww-w_0))).*exp(i*-.5*tau*(ww-w_0)).*exp(i*(ww-w_0).^2*GDD/1.5);
% A super chirped pulse:
% Unk1=exp(-((xx)/(sqrt(2)*sigmax*dx)).^2).*exp(-((ww-w_0)/(sqrt(2)*delta_w)).^2).*exp(i*(ww-w_0).^2*GDD);
% A super chirped double pulse with cubic phase:
% Unk1=exp(-(xx/(sqrt(2)*sigmax*dx)).^2).*exp(-((ww-w_0)/(sqrt(2)*delta_w)).^2).*exp(-i*(ww-w_0).^2*GDD+i*(ww-w_0).^3*1e-40).*(exp(i*0*(ww-w_0)*tau)+exp(-i*.1*(ww-w_0)*tau));
% A super chirped pulse with spatial chirp:
%Unk1=exp(-(xx/(sqrt(2)*Nx*dx)).^2).*exp(-((ww-w_0)/(sqrt(2)*delta_w/2)).^2).*exp(-i*(tau)*(ww-w_0)*0).*exp(i*(ww-w_0).^2*GDD).*exp(-i*10e-10*xx.*(ww-w_0));
% a super chirped pulse with missing center frequencies:
% Unk1=exp(-(xx/(sqrt(2)*Nx*dx)).^2).*(exp(-((ww-(w_0-delta_w/2))/(sqrt(2)*delta_w/10)).^2)+exp(-((ww-(w_0+delta_w/2))/(sqrt(2)*delta_w/10)).^2)).*exp(-i*(ww-w_0).^2*GDD);


% This part makes them 'cross', this is where things like focal length and
% pinhole seperation come in.
Unk=(Unk1.*(exp(-1i*kk.*xx*d/f)));


%% Interfere the pulses and take cross sections, creates MUDPIX file

for k=1:N
    
    if ~mod(k,floor(N/3))
        fprintf('.')
    end
    
    t1(k)=-tau1*(k-N/2-0.5); %Find this picture's delay.
    Refk=Ref.*exp(1i*(ww-w_0)*t1(k)); %Delay the reference pulse appropriately
    MUDPIX(k).data = (abs(Refk+Unk).^2).'; %Interfere them. (notice the transpose, necessary)
    MUDPIX(k).pos = t1(k) * c * 1e-6; %this should now be in mm

end

fprintf('Transforming')

for k = 1:N
    %Change the Mudpix file to be in lam domain, because thats what the camera does.
        [MUDPIX(k).data, lam]=img_wtolam2(MUDPIX(k).data,w);
         MUDPIX(k).lam = lam;
         MUDPIX(k).x = x; %Label the spacial dimention too
         
         if ~mod(k,floor(N/3))
             fprintf('.')
         end

end

%% Generate the other outputs

% Output the Reference Trace
Refw=abs(Ref.').^2;
% Reference trace must also be in lam domain
[Ref1, ~]=img_wtolam2(Refw,w);
[REF.data] = Ref1;
REF.x = x;


% Output the Reference (Grenoullie) Phase
    % refPhi = sum(Ref,2).'; %old way, has issues.
refPhi = Ref(:, end/2).'; %Just take the phase from the middle
refPhi_lam = equally_spaced_spectrum_lam(w,refPhi);
[REF.gPhi] = unwrap(angle(refPhi_lam));


% Find the simulated E-field
sim_Ew = (sum(Unk1, 2).');
[sim_E_lam, lam] = equally_spaced_spectrum_lam(w,sim_Ew);

% Output simulated lam domain information
SIM_PULSE.lam = lam;
SIM_PULSE.spec = abs(sim_E_lam).^2;
SIM_PULSE.sphi = (angle(sim_E_lam));

% Inverse fourier transform to get time domain info
sim_Et = ifftc(sim_Ew);
w_eq = equally_spaced_w_m(lam)*1e-6;

% Output simulated time domain information
SIM_PULSE.t = wtot(w_eq);
SIM_PULSE.int = abs(sim_Et).^2;
SIM_PULSE.tphi = unwrap(angle(sim_Et));


fprintf('Complete. Took %0.2f seconds.\n', toc)

end