% this function finds the max values of a spectrum and then
% cuts off the surrounding region where the spectrum is zero
% L = length of spectral window
function [Ew1]=cut_spec(Ew,L)
Ew1=zeros(size(Ew));
x=round(L/2);
for k=1:size(Ew,2);
    [max1(k),index1(k)]=max(abs(Ew(:,k)));
end
for k=1:size(Ew,2)
    Ew1([index1(k)-x:index1(k)+x],k)=Ew([index1(k)-x:index1(k)+x],k);
end