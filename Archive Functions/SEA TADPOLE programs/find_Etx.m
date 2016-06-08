function [ext,t]=find_Etx(spectrum, phase,cal,lo,phical);

%This function takes in the spectrum and phase as function of transverse
%position x and finds the temporal field as a function of transverse 
%position x. Phical is the calibraiton phase and can be subtraced out of
%the phase differenc using this program.The command to used this function 
%looks like this: [ext,t]=find_Etx(spectrum,phase,cal,phical)
%%
l = size(spectrum);
o = l(2);
lo = 810;

%%%Options
zero_fill = true;
crop = true;
num = 1000;%Number of Zeros to use in the filling
%%%
%% for using phical
if nargin==5;
    lam = lam_axis(cal, length(spectrum));
    omega = ltow(lam)-ltow(lo);
    phasecal = omega.^2.*phical;
    phasecal = repmat(phasecal,o,1)';
    size(phase)
    phase = phase-phasecal;
end
%% making the equally spaced omega vector
lam = lam_axis(cal, l(1),lo);
omega = ltow(lam)-ltow(lo);
omegaeq=equally_spaced_w(lam)-ltow(lo);
%% to crop the E(w) and removing the constant background
if crop == true;
    c1 =100;
    c2 = 1100;
    phase = phase(c1:c2,:);%usally 250to550
    spectrum = spectrum(c1:c2,:);
    spectrum = spectrum-spectrum(1);
    omegaeq = omegaeq(:,c1:c2);
    omega = omega(:,c1:c2);
end

%% Zero filling and interpolation
L = size(spectrum);
L = L(2);
n = 1;
ext =[];
spectrum = spectrum';
phase = phase';

while n <=L;
    sp = spectrum(n,:);
    phi = phase(n,:);
    
    seq =interp1(omega, sp, omegaeq, 'cubic');
    phieq =interp1(omega, phi, omegaeq, 'cubic');
    
    if zero_fill == true;
        
        phieq = [zeros(1,num) phieq(1:end-50) zeros(1,num)];
        seq = [zeros(1,num) seq(1:end-50) zeros(1,num)];
    
    end
    seq(seq<0) = 0;    
    ew = seq(1:end-50).^.5.*exp(-i*phieq(1:end-50)); %make sure to check the sign here!!!
    ext(n,:) = (fftc(ew)); %when I processed the grating data I had a conj here and the phase was negative
    
    n = n+1;
end
%%
M = size(ext);
O  = M(1);
M = M(2);
t =time_axis(cal,M,lo);
d = num/2+300;
if zero_fill == true;
    [p,l] =max(ext((round(O/2)),:));    
    ext = (ext(:,d:end-d)')';  
    t = t(d:end-d)*1000;
end



imagesc(abs(ext));


end