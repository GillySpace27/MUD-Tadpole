% this program interferes two beams:

c=300;
K0=eye(4);
% the k-matrix for the imaging system is constructed:
grating_pft;
% the first beam is constructed:
% the beam radius is:
wo = 50;
pulse_duration = 150;
[ext,x,t] = prop_q_jake(wo,pulse_duration,K,0);
exw=fftc(ext);
% the second k-matrix is constructed:
[ext0,x,t] = prop_q_jake(wo,pulse_duration,K0,0);
w1=ttow(t(:,1),lam0);
lam1=wtol(w1);
[w,x] = ndgrid(w1, x(1,:));
% giving the second beam a crossing angle:
k=c./w;
exw0=fftc(ext);
% giving this pulse a delay:
tau=0;
exw0=exw0.*exp(i*(w).*tau);
% Crossing the beams at the camera:
I1=Norm(abs(exw+exw0).^2);
% plotting the results:
imlabel(I1,x(1,:),lam1(:,1),'The interferogram')
ylabel('Wavelength (nm)','fontsize',16);
xlabel('Position (mm)','fontsize',16);