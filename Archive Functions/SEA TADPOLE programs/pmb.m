function  dat = pmb(f, material, L)

%finds the phase matching bandwidth in nm pmb(f, material, L).  f is the
%center wavelength in nm, L is the length in um and material is something
%like 'BBO'.   SO see which materials are supported see refindex.
   cm = 1e-2;
    mm = 1e-3;
    um = 1e-6;
    nm = 1e-9;
    fs = 1e-15;
    THz = 1e12; 
	% Constants
    c = 3e8; % speed of light
    a = GVM(f, material)*(fs/mm);
dat = abs(.44*(f*nm).^2./(c.*L.*um*a)./nm);