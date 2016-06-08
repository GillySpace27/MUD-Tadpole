% this function gets the mud tadpole retrieved spectra
% ready for the concatenation routine:
% MUD_trace = the mud tadpole trace
% points =  indexed points in k-space for spatial filtering theAC terms
% Ref1 = reference pulse spectrum
% dl = wavelength calibration
% tau = delay between reference pulses
% x2 = the index x value where the Ew spectra are zero up until

function [Ew,w_eq]=mud_ready(MUD_trace,points,dl,Ref1,x2)
% retrieving the spectra
[Elam,lam]= find_phi_mud(MUD_trace,Ref1,dl,points);
% zeroing the initial arrays for speed:
seq1=zeros(size(Elam));
seq1_z=seq1;
phase1=seq1;
Ew=seq1;
w_eq=zeros(size(lam));
% getting the spectra equally spaced in w
for k=1:size(Elam,2)
    [seq1(:,k),w_eq]=equally_spaced_spectrum_w(lam,abs(Elam(:,k)));
    [phase1(:,k),w_eq]=equally_spaced_spectrum_w(lam,unwrap(angle(Elam(:,k))));
    % getting rid of the background:
    seq1_z(:,k)=seq1(:,k)-max(seq1(1:x2,k));
    % getting rid of the negative terms:
    a=find(seq1_z(:,k)<0);
    seq1_z(a,k)=0;
    Ew(:,k)=seq1_z(:,k).*exp(i*phase1(:,k));
end
