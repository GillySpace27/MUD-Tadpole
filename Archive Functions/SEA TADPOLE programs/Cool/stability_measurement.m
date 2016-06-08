function [Phi1,Phi2,Phi0,T]= stability_measurement(bg,vid,cal);

%this funcion is for checking the stability of the interferometer

%options
c1 = 450;
c2 = 600;
%
omega  = ltow(lam_axis(cal,length(sum(bg))))-ltow(800);
omega = omega(:,c1:c2);

tic;
t = toc;
Phi0 = [];
Phi1 = [];
Phi2 = [];
T = [];
n =1;
figure(1);
hold on;
while toc <1000;
    [phi,spec] =  find_phi_scanning(bg,vid);
    t = toc;
    Phi0(n) = phi(512);
    phi = unwrap(phi);
    phi = phi(:,c1:c2);
    fitcoefs = polyfit(omega,phi,2);
    phifit = fitcoefs(3)+fitcoefs(2).*omega+fitcoefs(1).*omega.^2;
    %clf reset
    %plot(omega,phifit,'g');
    %hold on
    plot(omega,phi);
    %Phi0(n) = fitcoefs(3);
    Phi1(n) = fitcoefs(2);
    Phi2(n) = fitcoefs(1);
    T(n) = t;
    n = n+1;
end
figure(2);
subplot(1,3,1)
plot(T,(Phi0));
xlabel('t(s)')
ylabel('absolute phase (radians)')

subplot(1,3,2)
plot(T,Phi1);
xlabel('t(s)')
ylabel('delay (fs)')

subplot(1,3,3);
plot(T,Phi2);
xlabel('t(s)')
ylabel('GDD (fs^2/rad)')
    