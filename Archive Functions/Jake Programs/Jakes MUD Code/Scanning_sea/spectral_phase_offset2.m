function [Ew_new]=spectral_phase_offset2(Ew,g1)
phase1=unwrap(angle(Ew));
phase0=phase1(g1,1);
phase2=phase1;
N=size(Ew,2);
for k=2:N
    % the offset of the initial phase value is:
    offset=rand(1)*pi/2;
    phase2(:,k)=phase1(:,k)+offset;
end
Ew_new=abs(Ew).*exp(i*phase2);