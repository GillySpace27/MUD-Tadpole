
function [a1,phase1]=pulse_train_phase(Et)
N=length(Et);
max1=max(unwrap(angle(Et)));
x1=[3.429e4,5.274e4,7.061e4,8.847e4,1.075e4,1.242e5,1.438e5];
phase1=unwrap(angle(Et));
m=1;
n=1;
for k=2:N-1
    if (phase1(k)==phase1(k-1) && phase1(k)~=phase1(k+1)) ||...
            (phase1(k)~=phase1(k-1) && phase1(k)==phase1(k+1))
        a1(m)=k;
        m=m+1;
    end
end
% taking care of the phases:
for k=1:length(a1)/2-1
    phase1(a1(2*k):a1(2*(k+1))-1)=phase1(a1(2*k):a1(2*(k+1))-1)+abs(phase1(a1(2*k)+1));
end
        
    