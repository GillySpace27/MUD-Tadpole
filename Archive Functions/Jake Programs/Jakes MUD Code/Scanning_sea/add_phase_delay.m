% This function adds a phase delay to each retrieved spectrum to 
% make them concatenate easier:

function [U1,Ht]=add_phase_delay(Unk,tau,w,H)
w_0=median(w);
N=size(Unk,2);
H1=zeros(size(Unk));
U1=H1;
for k=1:N
    U1(:,k)=Unk(:,k).*exp(-i*(w'-w_0)*((N-1)/2-(k-1))*tau);
    if ischar(H)==0
        H1(:,k)=H.*exp(i*(w'-w_0)*((N-1)/2-(k-1))*tau);
        Ht(:,k)=nmlz(abs(fftc(H1(:,k))));
    else
        Ht(:,k)=ones(size(U1(:,k)));
    end
end

