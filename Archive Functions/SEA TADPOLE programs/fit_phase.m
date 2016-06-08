function [v,phasefit,ebars] = fit_phase(phasereal,cal);


c1 = 500;
c2 = 700;   

lam = lam_axis(cal, length(phasereal), 800);
omega = ltow(lam)-ltow(800);


phase = phasereal(:,c1:c2);
v = [];
phasefit = [];
ebars = [];
L = size(phase);
L = L(1);
 n= 1;
 while n<=L
     fit = polyfit(omega(c1:c2),(phase(n,:)),2);
     phi = omega.^2.*(fit(1))+omega.*fit(2)+fit(3);
     
     diff = mean(phasereal(c1:c2)-phi(c1:c2)).^2;
     phi = omega.^2.*(fit(1))+omega.*fit(2)+fit(3);
     
     phasefit(end+1,:) = (phi);
     plot(omega,phi);
     hold on
     plot(omega,phasereal,'g');
  
     ebars(end+1) = diff;
     v(end+1) = fit(2);
     n= n+1;
 end
 figure
plot(v,'.')