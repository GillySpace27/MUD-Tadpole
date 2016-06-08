function dat = simulation_dp  

[xx,yy] = ndgrid(0:0.006545:6.7, 775:0.03943:825);
omega = ltow(yy) - ltow (800);
theta = .1;
 dc = (exp(-(((xx-3)/(6)).^2 + ((yy-(800))/30).^2)));
 C = 2*sin(degtorad(theta))*2*pi./(yy.*1e-6);
 phase = C.*xx + 0.* (omega) +0.*(omega).^2;
alpha = .5;% the contrast ratio
tau = 100; % the delay between the two pulses in the double pulse
 phasedp = atan((1+alpha*cos(omega.*tau))/(alpha.*tau));
 %plot(sum(phasedp))
 dc2 = (4*dc.*(cos(omega.*tau/2)).^2);
 dat  = dc +dc2 + 2*(dc2.*dc).^(.5).*cos (phasedp+phase);
imagesc(dat)

%subplot(2,1,1);
 %imagesc(dat1)
 %subplot(2,1,2);
 %b = fftshift(fft(dat1),1);
 %imagesc(abs(log(b)))
 