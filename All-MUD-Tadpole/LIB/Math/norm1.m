% this function normalizes the images:

function [a]=norm1(a)
a = double(a);
a=a./max(max(abs(a)));