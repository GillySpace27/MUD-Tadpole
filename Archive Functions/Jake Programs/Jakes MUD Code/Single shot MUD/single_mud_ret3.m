% this function finds the different sea tad traces from the MUD trace
% I1 = the retrieved mud tadpole trace
% Ref = the 2-D reference pulse trace
% Ref1 = the 1-D reference pulse spectra
% dl = the wavelength calibration (nm/pixel)
% pks = the pks in k-space for filtering
% dpks = the range in k-space to do the filtering
% lam0 = center wavelength
% tau = the delay spacing for the reference pulses
% x1 = the reference pulse index values


function [Et,E_lam,t_f,lam_eq,amp,t1]=single_mud_ret3(I1,Ref1,dl,N,lam0,tau,pks,dpks)

% first the AC terms of the traces are retrieved:
% the trace is FFT'd
Fint=fftc(I1);
[pks,x2]=lclmax(Norm(sum(abs(Fint),2)),10,.05);
dpks=round(mean(abs(diff(pks)))/2);
ret=ifftc(Fint([pks(1)-dpks:pks(1)+dpks],:));
% for the AC term filtering:
[x1,x2]=lclmax(Norm(sum(abs(ret),2)),10,.3);
dx=floor(mean(abs(diff(x1))));
% for the reference pulse filtering
[y1,x2]=lclmax(Norm(sum(abs(Ref1),2)),100,.3);
dy=floor(mean(abs(diff(y1))));
% isloting the retrived SEA traces:
for k=1:N

    % next the AC terms are cut in x-space
    AC(:,:,k)=ret([x1(k)-floor(dx/2):x1(k)+floor(dx/2)],:);
    % the reference terms are also cut in x-space
    Ref(:,:,k)=Ref1([y1(k)-floor(dy/2):y1(k)+floor(dy/2)],:);
    % summing the reference terms
    Ref2(:,k)=sum(abs(Ref(:,:,k)));
    % summing over x- to get the spectral phase:
    phi(:,k) = mean(unwrap(angle(AC(2:end-1,:,k)),[],2)); 
    % dividing out the reference to retrieve the spectrum:
    spectrum(:,k) = sum(abs(AC(2:end-1,:,k)),1).^2./Ref2(:,k)';
    Elam(:,k)=sqrt(spectrum(:,k)).*exp(i*phi(:,k));
end
% converting to equally spaced freq axis:
[Ew,w_eq]=convert_retrieved_spectra(Elam,dl,lam0);
% subtracting the background:
x_c1=1;x_c2=800;x2=10;ymax=.1;
[Ew1,w1]=sub_bg2(Ew,x_c1,x_c2,w_eq,x2,ymax);
% concatenating the retrieved spectra:
[Et,E_lam,t_f,lam_eq,amp,t1]=best_concat_mud(fliplr(Ew1),tau,w1,lam0);
    