% This function performs the concatenation routuine for 
% scanning sea tadpole
% t = array of times scanned in sec
% Ew = retrieved spectrum in equally spaced w
% w = equally spaced freq axis

c=300;
% Generating the time window:
[tw,delta_t]=time_window(w,tau);
% Making the temporal response function
Unk_of_t=fftc(Ew);
N=size(Ew,2);
%%
% Filtering out only retrieved regions in the time window:
% Find the center of each section;
for (k=1:N)
    center(k)=round(size(Unk_of_t,1)/2);
end
a=25;
% The width of the temporal response function is:
x1=round((a*tw));
% taking the valid data ponts:
for (k=1:N)
    if k==1
        Valid_unk(:,k)=(Unk_of_t([center(k)-round(x1/2):center(k)+(round(x1/2)-1)],k));
    else
        Valid_unk(:,k)=(Unk_of_t([center(k)-round(x1/2):center(k)+(round(x1/2)-1)],k));
    end
end
clear N center Unk_of_t
%%

%%
% making the weighting function:
% The number of points in each time window is:
N=size(Valid_unk,1);
t=(1:N)-round(N/2);
H1=exp(-(t/(tw)).^2);
Valid_H=zeros(size(Valid_unk));
for k=1:size(Valid_unk,2)
    Valid_H(:,k)=H1;
end
clear N H1
%%


%%
% Getting the retrieved amplitudes ready for concatenation by shifting them
% in time
N=size(Valid_unk,2);
z0=0;
x=round(tw)-z0;
x2=x1-(x1-tw)/2;

for k=1:N
        if k==1
            a1(1:(N-k)*(x))=0;
            U1(:,k)=cat(1,Valid_unk(:,k),a1');
            g1(k)=x2;
            H1(:,k)=cat(1,Valid_H(:,k),a1');
            clear a1;
        elseif k==N
            a2(1:x*(N-1))=0;
            U1(:,k)=cat(1,a2',Valid_unk(:,k));
            g1(k)=tw+(x1-tw)/2+g1(k-1);
            H1(:,k)=cat(1,a2',Valid_H(:,k));
            clear a2;
        else
            a3(1:x*(k-1))=0;
            a4(1:(N-k)*x)=0;
            U1(:,k)=cat(1,cat(1,a3',Valid_unk(:,k)),a4');
            g1(k)=tw+(x1-tw)/2+g1(k-1);
            H1(:,k)=cat(1,cat(1,a3',Valid_H(:,k)),a4');
            clear a4 a3;
        end
end 
g1=round(g1);
for(k=1:size(U1,2))
    d1=floor(size(U1,1)/size(U1,2));
    g1(k)=d1*k;
end
clear Valid_unk Valid_H
%%



%%

% taking care of the phase constants for plotting purposes:

phase=(angle(U1));
N=size(phase,2);
% the size of each window is:
z=length(phase(:,1));
for k=1:N-1
    % the offset of the initial phase value is:
    offset(k)=phase(g1(k),k+1)-phase(g1(k),k);
    phase(:,k+1)=phase(:,k+1)-offset(k);
end
U1new=abs(U1).*exp(i*phase);
clear U1 
%%

%%
% performing a weighted sum:
for k=1:size(U1new,1)
    amp(k)=sum(H1(k,:).*abs(U1new(k,:)))./(sum(H1(k,:)));
    phase(k)=sum(abs(H1(k,:)).*unwrap(angle(U1new(k,:))))./(sum(abs(H1(k,:))));
    %B1(k)=(sum(H1(k,:).*U1new(k,:))./(sum(H1(k,:))));
    %B2(k)=(sum(H1(k,:).*U1(k,:))./(sum(H1(k,:))));
end
C1=amp.*exp(i*phase);
clear H1
%%


%%
% making the time axis:
Nt=length(C1);
C1=crop(C1);

[t_f]=[-Nt/2*delta_t:delta_t:(Nt-1)/2*delta_t];
w_f=ttow(t_f,2*pi*c/lam0);
% getting rid of the zero terms:
z1=1;
%z1=4200;
%z2=2.539e4;
z2=length(C1)-1;
C1(1,[1:z1,z2:end])=0;
%%

[E_lam,lam_eq]=equally_spaced_spectrum_lam(w_f,fftc(C1),lam0);
x=390;
E_lam=E_lam([x:end-x]);
lam_eq=lam_eq(x:end-x);
[amp2,phase2]=Nan_value(phase1,abs(U1));
