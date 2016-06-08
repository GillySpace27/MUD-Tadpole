
function [U1,H1,g1]=add_phase_delay1(Ut1,tw,H2,x1)
H=abs(H2);
clear H2
N=size(Ut1,2);
z0=0;
x=round(tw)-z0;
x2=x1-(x1-tw)/2;

for k=1:N
        if k==1
            a1(1:(N-k)*(x))=0;
            U1(:,k)=cat(1,Ut1(:,k),a1');
            %phase1(:,k)=cat(1,a1',phase0(:,k));
            g1(k)=x2;
            if ischar(H)==0
                H1(:,k)=cat(1,H(:,k),a1');
            end
            clear a1;
        elseif k==N
            a2(1:x*(N-1))=0;
            U1(:,k)=cat(1,a2',Ut1(:,k));
            %phase1(:,k)=cat(1,phase0(:,k),a2');
            g1(k)=tw+(x1-tw)/2+g1(k-1);
            if ischar(H)==0
                H1(:,k)=cat(1,a2',H(:,k));
            end
            clear a2;
        else
            a3(1:x*(k-1))=0;
            a4(1:(N-k)*x)=0;
            U1(:,k)=cat(1,cat(1,a3',Ut1(:,k)),a4');
            %phase1(:,k)=cat(1,cat(1,a4',phase0(:,k)),a3');
            g1(k)=tw+(x1-tw)/2+g1(k-1);
            if ischar(H)==0
                H1(:,k)=cat(1,cat(1,a3',H(:,k)),a4');
            end
            clear a4 a3;
        end
end 
g1=round(g1);
for(k=1:size(U1,2))
    d1=floor(size(U1,1)/size(U1,2));
    g1(k)=d1*k;
end