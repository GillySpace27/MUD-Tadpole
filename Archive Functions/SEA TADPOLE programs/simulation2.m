function dat = simulation2 (theta, tau) 

[xx,yy] = ndgrid(0:0.006545:6.7, 775:0.03943:825);

 dc1 = (exp(-(((xx-3)/(6)).^2 + ((yy-(800))/30).^2)));
 dc2 = 2.*dc1.*(cos((ltow(yy)-ltow(800)).*tau)).^2;
 C = 2*sin(degtorad(theta))*2*pi./(yy.*1e-6);
 phase = C.*xx + 100.* (ltow(yy) - ltow (800));
 dat1 = dc1 +dc2 + 2*(dc1.*dc2).^(.5).*cos (phase);
 subplot(2,1,1);
 imagesc(dat1)
 subplot(2,1,2);
 b = fftshift(fft(dat1),1);
 imagesc(abs(log(b)))