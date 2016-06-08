function [phi,spec]= find_phi_scanning(bg,vid,pks)

%Given a 2d interference pattern a, this program finds the phase difference
%[phi,spec, cut1]= find_phi(a,bg,vid,real_spec) by taking two 1d fourier transforms.

a = fw_snap(vid);
b = (fftc(a-bg));

if length(pks)>1;
    c = pks(1);
    c2 = pks(2);
    d = round(abs(c2-c)/2);
    s1 = (c-d);
    s2 = c+d;
    cut = (ifftc(b(s1:s2,:)));  %I think that it does not matter if this is ifft or fft?
    refspeck = sum(bg); %refspeck = refspeck-refspeck(1)*.9;
    spec = sum(abs(cut).^2)./refspeck;
    m = size(cut); m = floor(m(1)/2);
    phi = -phase(cut(m,:)); %worse but faster
    %phi = -mean(unwrap(angle(cut))); %better but slower
else 
    phi = zeros(1,length(a));
    spec = zeros(1,length(a));
end
end