% This function finds the peaks and plots only the peak values:
% Ew is matrix representing a bunch of gaussian fcns in each column
function [x,y]=find_peaks(Ew)
N=size(Ew,2);
for k=1:N
    [y(k),x(k)]=max(Ew(:,k));
end
plot(x,y,'.')