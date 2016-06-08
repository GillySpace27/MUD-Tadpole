% this function performs a weighted sum:

function [C1]=weighted_sum(U1new,H1)
%amp=zeros(size(U1new,1));
%phase=amp;
for k=1:size(U1new,1)
    amp(k)=sum(H1(k,:).*abs(U1new(k,:)))./(sum(H1(k,:)));
    phase(k)=sum(abs(H1(k,:)).*unwrap(angle(U1new(k,:))))./(sum(abs(H1(k,:))));
    %B1(k)=(sum(H1(k,:).*U1new(k,:))./(sum(H1(k,:))));
    %B2(k)=(sum(H1(k,:).*U1(k,:))./(sum(H1(k,:))));
end
C1=amp.*exp(i*phase);