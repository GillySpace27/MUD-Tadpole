% This function filters out the noise

function [I1 bg Ref]=noise_filter_jake(I1,bg,Ref,n)
I1 = medfilt2(I1,[n,n]);
bg = medfilt2(bg,[n,n]);
Ref = medfilt2(Ref,[n,n]);