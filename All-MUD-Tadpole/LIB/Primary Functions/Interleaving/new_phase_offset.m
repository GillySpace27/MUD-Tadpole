% This function gets rid of the phase ambiguity by matching up the values
% of the phase to that of the previous window's retrieved phase:
% U1 = the retrieved temporal amplitude after filtering 
% but before indexing
% tau = the indexed delay between reference pulses


function [offset,g1]=new_phase_offset(U1,tw,tsp)
phase=unwrap(angle(U1));
N=size(phase,2);

% g1=round((tsp-tw)/2+tw);
g1=tw+1;
% for k=2:N-1
%     g2(k)=(tsp-tw)/2+tw*(k-1);
% end
offset=0;
for k=2:N
    % the offset of the initial phase value is:
    offset(k)=offset(k-1)+phase(1,k)-phase(g1,k-1);
end
