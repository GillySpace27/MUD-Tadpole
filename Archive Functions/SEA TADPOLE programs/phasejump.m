function dat = phasejump(phi)

%removes the phase jumps that result from the interpolation. phasejump(phi)
%where phi still has the wierd jumps

w = length(phi);
X = [1:w];

dphi = (diff(phi)./diff(X));

%use this plot to make sure that the lclmax command will find the phase
%jumps

plot(abs(Norm(dphi)),'r')

[pks,h] = lclmax(Norm(abs(dphi)),10,.7)
hold
plot(pks,h,'o')
%pks = pks(1);
k = length(pks);    %  The number of phase jumps that occur
  
m = [];

i = 1;
st = 1;
c1 = pks(1);
m(1:c1) = phi(1:c1);
%while  (i <  k)
    c = pks(i)
    m(st:c) = phi(st:c);
    c2 = c+1;
    diff1 = abs(m(c) -phi(c2));
    w1 = pks(i+1)
    m(c2:w1) = (phi(c2:w1)-diff1);
    st = c2;
    i = i+1;
    
%end

%c1 = pks((k));
%c3= c1+1;
%diff3 = m(c1) - phi(c3);
%m(c3:w) = (phi(c3:w)+diff3);


dat = m;