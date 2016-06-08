function dat = GVM(f, material)
%Finds the group velocity mismatch in units of fs/cm GVM(f, material) where
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
n2 = refindex(F, material ,degtorad(29.23), 'nm');
dn1 = diff(n1)./diff(F);
dn2 = diff(n2)./diff(F);
dn1o = (dn1(800));
dn2o = (dn2(400));
dat = abs((f.*nm./c*(dn1o - .5*dn2o)./nm)./2).*cm/fs;