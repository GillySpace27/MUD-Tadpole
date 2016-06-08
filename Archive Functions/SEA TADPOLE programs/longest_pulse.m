function longest_pulse = fun(lam, N)

%determines the time of the pulse that can be seen with a certian spectral
%resolution where lam is the center wavelength in nm and N is the number of
%grooves of the grating that are illuminated.

% Units
	cm = 1e-2;
	mm = 1e-3;
	um = 1e-6;
	nm = 1e-9;
	fs = 1e-15;
	THz = 1e12; 
    ps = 1e-12
% Constants
	c = 3e8; % speed of light
    
dellam = spres(lam, N);
delnu = (c*dellam*nm)/((lam*nm).^2);

T = (1/delnu)/ps;
longest_pulse = T;
