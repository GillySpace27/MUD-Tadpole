% This function weights the sum for the concatenation routine:

function [U1]=new_weight_sea(Ut,tw,H)

%H2=ones(size(Ut));
c=3e8;
N=size(Ut,2);
for k=1:N
        if k==1
            a1(1:round((N-1)/2*tw))=0;
            U1(:,k)=cat(1,a1',Ut(:,k));
            if ischar(H)==0
                H1(:,k)=cat(1,H(:,k),a1');
            end
        elseif k==N
            U1(:,k)=cat(1,Ut(:,k),a1');
            if ischar(H)==0
                H1(:,k)=cat(1,a1',H(:,k));
            end
            clear a2;
        else
            a3(1:x*(k-1))=0;
            a4(1:(N-k)*x)=0;
            U1(:,k)=cat(1,cat(1,a3',Ut(:,k)),a4');
            g1(k)=tw+(x1-tw)/2+g1(k-1);
            if ischar(H)==0
                H1(:,k)=cat(1,cat(1,a3',H(:,k)),a4');
            end
            clear a4 a3;
        end
end 

% %[phase0]=phase_offset((angle(U1)),tw,x1);
% % Executing the weighted sums routine:
% I_tot(1:size(Ut1,1)*N)=0;
% % For a chirped Double pulse:
% %g1=[682,1578,1984,2847];
% [phase0,offset]=phase_offset(U1,tw,round(g1),end1);
% U1new=abs(U1).*exp(i*phase0);
% U1new_end=abs(end1).*exp(i*(angle(end1)-offset(end)));
% amp1=amp_offset(U1,tw,round(g1));
% for k=1:size(U1,1)
%     amp2(k)=sum(H1(k,:).*abs(U1(k,:)))./(sum(H1(k,:)));
%     amp(k)=sum(H1(k,:).*(amp1(k,:)))./(sum(H1(k,:)));
%     phase(k)=sum(abs(H1(k,:)).*unwrap(angle(U1(k,:))))./(sum(abs(H1(k,:))));
%     phase2(k)=sum(H1(k,:).*(phase0(k,:)))./(sum(H1(k,:)));
% end
% % here each element is given equal weight:
% for k=1:size(U1,1)
%     B1(k)=(sum(H1(k,:).*U1new(k,:))./(sum(H1(k,:))));
% end
% for k=1:size(U1,1)
%     B2(k)=(sum(H1(k,:).*U1(k,:))./(sum(H1(k,:))));
% end
% 
% % Constructing the time axis:
%     Nt=length(amp);
%     t=(1:Nt)*delta_t;
%     [w]=ttow(t,2*pi*c/L_0);
%     [L]=wtol(w,'m/s');
% 
%       % Putting the pieces back together:
%     I_tot=(amp.*exp(1i*phase));
%      % Getting rid of the NaNs:
%     [B1]=(crop(B1));
%     phase1=phase_ready(U1);
%     B3=amp2.*exp(1i*unwrap(angle(B1)));
%     [I_tot]=crop(crop(I_tot));
  