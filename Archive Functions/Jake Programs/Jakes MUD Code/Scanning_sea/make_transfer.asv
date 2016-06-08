% this function makes a transfer function:

function [Hw]=make_transfer(x,tau)

Ht=exp(-(t/tau).^2).*exp(i*(w-w_0).*tau);
Hw=ifftc(Ht);