function [Etxz,t] = find_Etxz(phasexzw, xz, spectrumxzw, cal, phi_ref);

%this funcion just runs find_ext for every z and makes the results into a
%cell array.  Use it like this: 
%[Etxz,t] = find_Etxz(phasexzw, xz, spectrumxzw, cal)




n = 1;
m = size(phasexzw);
m = m(1);
Etxz = {};

if nargin == 5;
    lam = lam_axis(cal,1024,810);
    omega = ltow(lam)-ltow(800);
    phi_ref  = phi_ref*omega.^2;
    phasexzw_new = {};
    while n<=m;
        phi_ref_new = meshgrid(phi_ref,xz{n})';
        phasexzw_new{n} = phasexzw{n}+phi_ref_new;
        n = n+1;
    end
   phasexzw = phasexzw_new;
end

 

n = 1;        
while n<=m;
     [ext,t]=find_Etx(spectrumxzw{n}, phasexzw{n},cal);
     Etxz{n} = ext';
     n = n+1;
end
