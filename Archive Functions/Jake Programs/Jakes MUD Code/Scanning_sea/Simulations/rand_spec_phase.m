% this function gives each retrieved Ew a constant random spectral phase

function [Ew2]=rand_spec_phase(Ew,w)
N=size(Ew,2);
w0=median(w);
w1=w-w0;
for k=1:N
    Ew2(:,k)=Ew(:,k).*exp(i*pi/2*rand(1));
end
