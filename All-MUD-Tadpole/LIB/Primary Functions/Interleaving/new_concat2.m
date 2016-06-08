% this function performs the concatenation without shifting
% U1 = temporally filtered slices
% Ht = the weighting functions
% tw = delay between reference pulses (in index points not fs)
% tsp = temporal length of each section (in index points not fs)
% offset = is the phase offset for phase concatenation

function [Ef]=new_concat2(U1,H,tw,tsp,offset)
Q=size(U1,2); %number of pulses

% The length of the final concatenated field will be:
L = (Q-1)*tw+tsp;


% Initializing the arrays to zero:
E=zeros([L,1]);
amp1=E;
phase1=E;
Htot=E;

for k=1:Q
    %Pull out the phase for each pulse
    phase2(:,k)=unwrap(angle(U1(:,k)));
end

for k=1:L
    %For every pixel in the final field
    
    % Find the first relevant segment index
    if k<tsp
        m0=1;
    else
        m0=ceil((k-tsp)/tw  +1);
    end
    % Find the last relevant segment index
    mf=ceil(k/tw);
    if mf>Q
        mf=Q;
    end
    
    for m=m0:mf
        %weighted average of relevant phases + amplitudes
        z=k-tw*(m-1);
        amp1(k)=amp1(k)+abs(U1(z,m))*H(z,m);
        phase1(k)=phase1(k)+(phase2(z,m)-offset(m))*H(z,m);    
        Htot(k)=Htot(k)+H(z,m);
    end
end
% divide out the weighting function
phase_tot=phase1./Htot;
amp_tot=amp1./Htot;
Ef=amp_tot.*exp(i*phase_tot);
