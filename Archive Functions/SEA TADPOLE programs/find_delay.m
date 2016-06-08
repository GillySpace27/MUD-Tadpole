function  delay = find_delay(bg,vid,cal);
%this funcion finds the delay between the reference and unknown pulse given
%the video object vid when there is an interferogram at the camera
%%
[phi,spec]=find_phi_scanning(bg,vid);

c1 = 500;
c2 = 600;

lam = lam_axis(cal, length(phi), 800);
omega = ltow(lam)-ltow(800);
phi = unwrap(phi(c1:c2));
omega = omega(c1:c2);
fit = polyfit(omega,phi,3);
phi_fit = omega.^3.*(fit(1))+omega.^2.*(fit(2))+omega.*fit(3)+fit(4);
hold off
plot(omega,phi_fit);
hold on
plot(omega,phi,'g');
display(['the delay is ' num2str(fit(3))])
delay = fit(3);