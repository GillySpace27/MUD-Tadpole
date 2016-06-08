% this function performs the concatenation without shifting
% Uindex = temporally filtered slices with temporal indices
% tau = delay between reference pulses (in index points not fs)
% x = temporal length of each section (in index points not fs)

function [U_final,U2]=new_concat(Uindex,Ht,tau,x,offset)
N=size(Uindex,2)/2;
Utot=zeros([(N-1)*tau+x,1]);
amp1=Utot;
phase1=Utot;
% Getting the phase info:
for k=1:N
    phase2(:,k)=unwrap(angle(Uindex(:,2*k-1)));
end

Htot=Utot;
for k=1:(N-1)*tau+x
    for n=1:x
        for m=1:N
            % Checking the time value
            if Uindex(n,2*m)==k
                Utot(k)=Utot(k)+Uindex(n,2*m-1)*Ht(n,2*m-1);
                amp1(k)=amp1(k)+abs(Uindex(n,2*m-1))*Ht(n,2*m-1);
                % concatenating the phases, the offset value provides the
                % re-phasing
                phase1(k)=phase1(k)+(phase2(n,m)-offset(m))*Ht(n,2*m-1);    
                Htot(k)=Htot(k)+Ht(n,2*m-1);
            end
        end
    end
end
amp_final=amp1./Htot;
phase_final=phase1./Htot;
U2=amp_final.*exp(i*phase_final);
U_final=Utot./Htot;

