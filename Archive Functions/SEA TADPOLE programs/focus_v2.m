function [Ef,Et,time,Lam,x2] = focus_v2(z,dx2,skip2);

%A lens simulation using a gaussian spatial distribution.  The equations 
%are taken from the Optics Communications paper by Horvath and Bor from 
%1993 P.6-12 vol. 100.   
%The z that is to be passed in is the distance from the focal length of the
%lens.

version = '$Id: focus_v2.m,v 1.1 2007-06-12 19:34:56 pam Exp $'; 

if nargin ==2;
    skip2 = true;
end

%vectors
dw =.004;
omega = [ltow(860):dw:ltow(750)];
omegac = omega-ltow(800);
Lam = wtol(omega);
dx1 = .06;
x1 = [-6:dx1:6];
if nargin == 1;
    dx2 = .002;
end
    %x2 = [-.02:dx2:.02];
x2 =[-1:.04:1]*dx2;
%parameters units are mm, nm and fs
material = 'BK7';
c = 300;
a = 3; %was 3.5
do = .0049;  %lens thickness 
omegao = ltow(800); % in 1/fs
bandwidth = dl2dw(28.1517,800); %in nm
ko = omegao/c*1e6;
fo = 50;  %50mm focal length
lambda = [700:900];
n = refindex(lambda,material);
no = refindex(800,material);
dndlam = diff(n)./diff(lambda);
s = length(dndlam);
dndlamo = dndlam(100);
A = (ko)*(no^2*(no^2-4)+2*no+4)/(8*no*(no-1)^2*(no+2))*1/fo^3;
tau = ((-800)*dndlamo)/(2*(c*1e-6*fo*(no-1)))*(a/2).^2;

chirp = gdn(800e-9,material,do,2)*1e30/2;

%trasform limited pulse duration
t =time_axis(dw2dl(dw,800),length(omega));
deltat=FWHM(abs(fftc(exp(-((omegac)/bandwidth).^2))).^2,t);
Exi = exp(-(x1/a).^2);

%Grid
[Omega,X2,X1] = meshgrid(omega,x2,x1);
lam =  wtol(Omega);
omegac = Omega-ltow(800);
omegao = ltow(800);
k = 2*pi./lam*1e6;
ko = 2*pi./800*1e6;
f = fo-fo./(no-1).*dndlamo.*(lam-800); 
L = fo/(no-1)*((-800)*dndlamo); 
u = (1/fo-1/z);

%the field
Ew =exp(-((omegac)/bandwidth).^2).*exp(i.*omegac.^2.*chirp);
Ei = exp(-(X1/a).^2);
K = exp(i*k/(2*z).*(X2-X1).^2);
theta = exp(-i.*k.*X1.^2./(2.*f)).*(exp(i*(no.*do*k)*0)).*exp(-i*A*X1.^4);
Ef = sum((K.*Ew.*theta.*Ei),3);
Sw = sum(abs(Ef).^2);
l =size(Ew);
l = round(l(1)/2);
Sw_local = abs(Ef(l,:).^2);

%fourier transform to the time domain
skip = false;
if skip == false;
    s = size(Ef);
    s = s(1);
    n = 450; %number of zeros to fill with
    m = 447;
    E = [zeros(s,n) Ef zeros(s,n)];
    Et = fftc(E');
    s2 = size(Et);
    time =time_axis(dw2dl(dw,800),s2(1));
    Et = Et(m:end-m,:);
    Et = Et';
    It = sum(abs(Et).^2);  
    It_local =abs(Et(l,:).^2);
    time = time(m:end-m);
end

%Figures and messages

if skip2 == false;
    figure(1)
    imagesc(Lam,x2,abs(Ef).^2) 
    figure(2)
    imagesc(time,x2,abs(Et).^2)
    display(['the pulse front should be flat ' num2str(L) 'mm after the focus'])
    display(['the bandwidth is ' num2str(dw2dl(bandwidth,800)) 'nm'])
    display(['the transform limted pulse duration is ' num2str(deltat) 'fs'])
    display(['A is ' num2str(A.*a.^4)])
    display(['tau is ' num2str(tau) 'fs'])
    display(['the final global bandwidth is ' num2str(rms(Sw,Lam)) 'nm'])
    display(['the local bandwidth is ' num2str(rms(Sw_local,Lam)) 'nm'])
    display(['the global pulse width is ' num2str(rms(It,time)) 'fs'])
    display(['the local pulse width is ' num2str(rms(It_local,time)) 'fs'])
    display(['the final spot size is ' num2str(rms(sum(abs(Ef.^2),2),x2')) 'mm']);
    display(['the initial spot size is ' num2str(rms(abs(Exi.^2),x1)) 'mm']);
end


end
        