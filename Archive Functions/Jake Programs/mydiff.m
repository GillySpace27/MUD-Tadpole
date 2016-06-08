function [derivative] = mydiff(func, stepsize)

[asdf, fsize] = size(func);

derivative(fsize) = 0;

for n = 1:fsize-1
derivative(n) = (func(n+1) - func(n))/ stepsize;
end
