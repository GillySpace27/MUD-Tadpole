function [phasexw,spectrumxw] = process_datxzw(datxw,bg);

phasexzw = [];
spectrumxzw =[];

while n <= length(dat);
    [phi, spec] = find_phi(dat(n,:,:),bg);
   
    spectrum(1,:) = spec;
    phase(1,:) = phi;
    n =n+1;
    
  
end

