function dat = GVDM(f, material)
%Finds the group velocity dispersion mismatch in units of (s/m)^2 GVM(f, material) where
%f is the center wavelength and material is something like 'BBO'.  See
%refindex for all of the supported materials.
% Units
	cm = 1e-2;
	mm = 1e-3;
	um = 1e-6;
	nm = 1e-9;
	fs = 1e-15;
	THz = 1e12; 
	% Constants
	c = 3e8; % speed of light
s = f/2;    
F = [ f-50:.1:f+50];
n1 = refindex(F, 'BBO');
theta = PhaseMatchAng(f, s, material);
n2 = refindex(F, material ,theta, 'nm');
ddn1 = diff(diff(n1)./diff(F))./diff(F(1:1000));
ddn2 = diff(diff(n2)./diff(F))./diff(F(1:1000));
ddn1o = (ddn1(f));
ddn2o = (ddn2(s));
dat = (f*nm).^3.*((ddn1o-.25*ddn2o)./nm.^2)./(c.^2*2*pi)
