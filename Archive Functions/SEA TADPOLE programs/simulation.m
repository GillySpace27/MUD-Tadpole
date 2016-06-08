function [int_pattern, uk_speck, uk_speck_smear, refspeck] = simulation; 
Wr = .01;%spectral resolution.
[xx,yy] = ndgrid(0:(.2/6.7):6.7, 790:.02:810);  

nm =1e-9;

omega = (ltow(yy) - ltow (800)) ;


theta = .04;

 dc = (exp(-(((xx-3)/(14)).^2 + ((yy-(800))/(2.5)).^2)));
C = 2*sin(degtorad(theta))*2*pi./(yy.*1e-6);
tau = 1000*2*6*0; %length of the double pulse

%%%Pulse transmitted by an etalon
L = 45e-6;  %%2 microns
r = .75;
t = .2;
%Eout = -dc.^.5./(1-r.^2*exp(-i*((omega+ltow(800))*L*2/3e8)*1e15));
%%%


E1 = dc.^(.5).*exp(i.*0);
E2 = dc.^(.5).*(exp(i*tau/2.*omega)+exp(-i*tau/2.*omega)).*exp(i*500*omega);
 
%E2 = Eout.*(exp(i*tau/2.*omega)+exp(-i*tau/2.*omega)).*exp(i*0*omega.^2);
refspeck = sum(abs(E1).^2); 

 %tau2 = 800;
%E2 = E2.*(exp(i*tau/2.*omega)+ (exp(i*-tau/2.*omega)));
%imagesc((sig))
%plot(sum(sig))

Phase =  C.*xx+unwrap(angle(E1))-unwrap(angle(E2));
phi = Phase(1,:);

lam  = yy(1,:);
omega = ltow(lam)-ltow(800);
omegaeq=equally_spaced_w(lam*nm)*1e-15-ltow(800);

phieq =interp1(omega, phi, omegaeq, 'cubic'); 

H = (exp(-(((xx-3)/(.001)).^2 + ((yy-(800))/Wr).^2))); 
H1d  = (exp(-(((yy-(800))/Wr).^2))); 
%imagesc(H)
%unknown spectrum unsmeared
sigspec = (sum((abs(E2)).^2));
%plot(Norm(sigspec))
%title(FWHM(Norm(sigspec)));
%unknown spectrum smeared
sigspec = conv(sum(H1d), sigspec);
%figure
%plot(Norm(sigspec(150:400)))
%title(FWHM(Norm(sigspec(150:400))))
%interference pattern smeared and cropped
int_pattern = abs(E1).^2+abs(E2).^2 +2*abs(E1).*abs(E2).*cos(Phase);
int_pattern = conv2(H,int_pattern);
w = size(H);
w = round(w(2)/2);
l = round(w(1)/2);

int_pattern =int_pattern(110:325,w:end-w+1);

imagesc( [790:.02:810],[0:(.2/6.7):6.7],int_pattern);

nice_plot_pm

 
uk_speck = sum(abs(E2).^2);
uk_speck_smear = conv(uk_speck,sum(H1d));
uk_speck_smear = uk_speck_smear(w:end-w+1);



seq =interp1(omega, uk_speck_smear, omegaeq, 'cubic'); 
ew = seq.^.5.*exp(i.*phieq);
et = fftc(ew);
%t = time_axis(.0534, length(sum(dc)));
L =length(phi);
cal = 100/L;
t = time_axis(cal, length(phi),810);


dat = int_pattern;
%plot( Norm(abs(et)).^2)

end
 