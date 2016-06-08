% this function performs the concatenation without shifting
% U1 = temporally filtered slices
% Ht = the weighting functions
% tau = delay between reference pulses (in index points not fs)
% x = temporal length of each section (in index points not fs)
% offset = is the phase offset for phase concatenation

function [Ef]=new_concat2_no_rephase_fields(U1,H,tau,x)
Q=size(U1,2);
% the length of the final concatenated field will be:
L = (Q-1)*tau+x;
% setting the intial arrays to zero:
E=zeros([L,1]);
E1=E;
real_field1=E;
imag_field1=E;
Htot=E;

% Getting the phase info:
for k=1:Q
    phase2(:,k)=unwrap(angle(U1(:,k)));
end

for k=1:L
    % the starting segment value
    if k<x
        m0=1;
    else
        m0=ceil((k-x)/tau+1);
    end
    % the final segment value
    mf=ceil(k/tau);
    if mf>Q
        mf=Q;
    end
    
    for m=m0:mf
        z=k-tau*(m-1);
%       amp1(k)=amp1(k)+abs(U1(z,m))*H(z,m);
%       phase1(k)=phase1(k)+(phase2(z,m)-0*offset(m))*H(z,m); 
        E1(k)=E1(k)+U1(z,m)*H(z,m);
%         real_field1(k)=real_field1(k)+real(U1(z,m))*H(z,m);
%         imag_field1(k)=imag_field1(k)+imag(U1(z,m));%*H(z,m);
        Htot(k)=Htot(k)+H(z,m);
    end
end

% Ef=real_field1+i*imag_field1;
Ef=E1;