% this program divides each delay by the reference pulse spectrum:
% Ref_spec = 2-D reference spectrum
% AC = retrieved AC term

function [Unk1,w]=divide_spec(Ref_spec,AC,lam)
phase1=unwrap(angle(AC),[],2);
for k=1:size(AC,1)
    Unk(k,:)=abs(AC(k,:))./(sqrt(mean(Ref_spec,1)));
end
% % resizing the reference spectrum:
% Ref=sqrt(imresize(Ref_spec,size(AC)));
% Unk=AC./Ref;
Unk=Unk.*exp(i*phase1);
% converting the retrieved spectrum into equally spaced frequencies:
[Unk1,w]=equally_spaced_spectrum_w(lam,Unk');
Unk1=Unk1';