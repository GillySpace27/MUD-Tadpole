% this function is used to plot the pre-concatenation amplitudes in time

[Et1]=new_concat2(Valid_unk,Valid_H,tw,x,offset);
% the length of each vector will be
L=size(Et1,1);
% the sampled vectors will be:
N=25;
dx=floor(L/N);
x=1:dx:L;
% the size of each vector is:
n=size(amp,1);
% getting the samples
for (k=1:N)
    a1(:,k)=amp(:,k*dx);
    % making the sampled terms fit the entire window
    % the number to add to the left is:
    left=(k-1)*n;
    % the number to add to the right is:
    right=L-left;
    a2(:,k)=cat(1,cat(1,[(1:left)*0],a1),(1:right)*0);
end
