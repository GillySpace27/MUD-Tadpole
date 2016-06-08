% this function mulitplies the retrieved temporal amplitude by:
% a window function 

function [U_win,g,H]=window(Uw,tw,N,Ht)
U1=fftc(Uw,[],1);
Nt=size(U1,1);
U_win=zeros(size(U1));
H=U_win;
for k=1:N
    t1(k)=tw*(k-1-N/2);
end
for k=1:N
    z(k+1)=round(Nt/2)+t1(k);
end
z(1)=1;
z(N+1)=Nt;
z=round(z);
% the amount of overlap is
x = round(tw/10); 
for k=1:N
    if k==1
        U_win([z(k):z(k+1)+x],k)=U1([z(k):z(k+1)+x],k);
        H([z(k):z(k+1)+x],k)=Ht([z(k):z(k+1)+x],k);
    elseif k==N
        U_win([z(k)-x:z(k+1)],k)=U1([z(k)-x:z(k+1)],k);
        H([z(k)-x:z(k+1)],k)=Ht([z(k)-x:z(k+1)],k);
    else
        U_win([z(k)-x:z(k+1)+x],k)=U1([z(k)-x:z(k+1)+x],k);
        H([z(k)-x:z(k+1)+x],k)=Ht([z(k)-x:z(k+1)+x],k);
    end
end
% for the offset program:
g=(z(2:end-1));