% this function is used to plot the pre-concatenation amplitudes in time
function [a2]=plotting_the_concatenation(Et,amp)
% the length of each vector will be
L=size(Et,1);
% the sampled vectors will be:
N=50;
dx=floor(L/N);
x=1:dx:L;
% the size of each vector is:
n=size(amp,1);
m1=max(max(abs(amp)));
% getting the samples
N=12;
for (k=1:N)
    a1(:,k)=amp(:,k*dx);
    % making the sampled terms fit the entire window
    % the number to add to the left is:
    left=(k-1)*n;
    % the number to add to the right is:
    right=L-left;
    if k==1
        a2(:,k)=cat(1,a1(:,k),(1:right)'*0);
    else
        L1=(1:left)'*0;
        R1=(1:right)'*0;
        a2(:,k)=cat(1,cat(1,L1,a1(:,k)),R1);
    end
end
% Now the zero values are set to Inf for plotting purposes
q=a2;
g=find(abs(q)==0);q(g)=NaN;
for(k=1:N)
    temp_plot2(abs(q(:,k))/m1,'y');
    saveas(gcf,['Concat',num2str(k)],'emf');
    saveas(gcf,['Concat',num2str(k)],'fig');
end
    

