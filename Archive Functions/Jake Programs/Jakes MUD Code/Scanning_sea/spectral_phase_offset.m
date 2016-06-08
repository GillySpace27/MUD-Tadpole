% This function gets rid of the spectral phase ambiguity by matching up the values
% of the phase to that of the previous window's retrieved phase:
% g1 = the beginning point


function [Ew_new]=spectral_phase_offset(Ew,g1)
phase1=unwrap(angle(Ew));
phase0=phase1(g1,1);
phase2=phase1;
N=size(Ew,2);
for k=2:N
    % the offset of the initial phase value is:
    offset=phase0-phase1(g1,k);
    phase2(:,k)=phase1(:,k)+offset;
end
Ew_new=abs(Ew).*exp(i*phase2);