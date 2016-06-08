% this function finds the different sea tad traces from the MUD trace
% I1 = the retrieved mud tadpole trace
% Ref = the 2-D reference pulse trace
% Ref1 = the 1-D reference pulse spectra
% dl = the wavelength calibration (nm/pixel)
% pks = the pks in k-space for filtering
% lam0 = center wavelength
% tau = the delay spacing for the reference pulses
% x1 = the reference pulse index values


function [Et,E_lam,t_f,lam_eq,amp,t1,q]=single_mud_ret2(I1,Ref1,dl,N,lam0,tau,x1,pks)

%[x1,x2]=lclmax(Norm(sum(abs(Ref1),2)),100,.01)
% isloting the retrived SEA traces:
for k=1:N
    dx=floor(mean(abs(diff(x1)))/2)*2;
    SEA1(:,:,k)=I1([x1(k)-floor(dx/2):x1(k)+floor(dx/2)],:);
    Ref(:,:,k)=Ref1([x1(k)-floor(dx/2):x1(k)+floor(dx/2)],:);
    Ref2(:,k)=sum(abs(Ref(:,:,k)));
    [pks,x2]=smart_lclmax(Norm(sum(abs(fftc(SEA1(:,:,k))),2)),3);
    % retrieving the spectra:
    q(:,k)=pks;
    [Elam(:,k),lam]= find_phi_mud2(SEA1(:,:,k),Ref2(:,k),dl,pks,lam0);
end
% converting to equally spaced freq axis:
[Ew,w_eq]=convert_retrieved_spectra(Elam,dl,lam0);
% subtracting the background:
x_c1=1;x_c2=500;x2=40;ymax=.1;
[Ew1,w1]=sub_bg2(Ew,x_c1,x_c2,w_eq,x2,ymax);
% concatenating the retrieved spectra:
[Et,E_lam,t_f,lam_eq,amp,t1]=best_concat_mud(fliplr(Ew1),tau,w1,lam0);
    