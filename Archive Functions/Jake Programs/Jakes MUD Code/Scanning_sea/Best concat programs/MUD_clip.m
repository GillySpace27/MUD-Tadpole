% this function gets the retrieved spectra ready by
% clipping off some the the unused spectrum:
% x1 = first value of the spectrum to clip
% x2 = last value of the spectrum to clip:
% Ew = retrieved spectra
% w_eq = equally spaced spectrum axis corresponding to the 
% retrieved spectra

function [Ew1,w1]=MUD_clip(Ew,w_eq,x1,x2)
Ew1=Ew(x1:x2,:);
w1=w_eq(x1:x2);