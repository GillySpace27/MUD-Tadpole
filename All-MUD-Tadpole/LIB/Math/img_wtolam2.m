function [img_l, lam_eq] = img_wtolam2(img, w)
%Take in a trace in the w domain and convert it to lam domain

H = size(img,1);
Hvec = 1:H;

c=300;
lam=2*pi*c./w;
lam_eq = equally_spaced_lam(w);

img_l =interp2(lam, Hvec', img, lam_eq, Hvec', 'spline');
end

