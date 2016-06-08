
% this script simulates grazing angle grating

% function graze_ang_gr

d = 1200; % grooves per mm
lam = unitconvert(800, 'nm', 'm');
L = unitconvert(30, 'mm', 'm'); % grating length
dx = unitconvert(6.7, 'um', 'm'); % camera pixel size
Np = 1280; % number of pixels in the camera 

a = unitconvert(1/d, 'mm', 'm'); % groove spacing

ang = pi/2; % incidence angle
step = 1e-2;
m = 1; % diffraction order
k = 0;
t_m = 0;

while imag(t_m) == 0;
    k = k + 1;
    ang = ang - step;
    t_in(k) = ang;
    t_m(k) = asin( (m * lam / a) - sin(t_in(k)) );
end

t_in(k) = NaN;
t_m(k) = NaN;

t_gr = pi/2 - t_in;
w_in = 0.5 * L * cos(t_in);
w_out = 0.5 * L * cos(t_m);

w_out_n_f = dx / 2; % required focused beam diameter that fills one pixel
f = pi * w_out .* w_out_n_f ./ lam;

f_mm = unitconvert ( f, 'm', 'mm');
w_in_mm = unitconvert ( w_in, 'm', 'mm');
w_out_mm = unitconvert ( w_out, 'm', 'mm');

N = L / a;
res = unitconvert ( 4 * lam ./ ( m * pi * N), 'm' , 'nm');
lam_range = Np * res;

t_in_d = radtodeg(t_in);
t_m_d = radtodeg(t_m);

plot(t_in_d, t_m_d)


xlabel('input angle')
ylabel('output angle')

