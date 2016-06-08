function [phi,spec,lam]= find_phi(a,bg,cal)

%Given a 2d interference pattern a, this program finds the phase difference
%[phi,spec, cut1]= find_phi(a,bg,vid,real_spec) by taking two 1d fourier transforms.

L = size(a);
L = L(1);
b = (fftc(a));
[pk,h] = max(a(round(L/2),:));

cent = h; %take vertical slice here to find the peaks and this 
%vertical slice should be at the maxima.

%using lclmax to find the interference term
B = (Norm(abs(b(:,cent))));
%plot(B)


[pks, h] = smart_lclmax(B);

pks  = [439 513 587]
c = pks(1);
c2 = pks(2);
d = round(abs(c2-c)/2);
s1 = (c-d);
s2 = c+d;

cut = (ifftc(b(s1:s2,:)));
spec = sum(abs(cut).^2)./sum(bg);


phi = -(unwrap(mean(unwrap(angle(cut)))));

lam = lam_axis(cal,length(phi));

end