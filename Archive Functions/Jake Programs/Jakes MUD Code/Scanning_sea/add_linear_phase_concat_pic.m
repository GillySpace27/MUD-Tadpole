% this function adds a linear phase term to the 
% the phase terms for concatenating and making a nice
% picture

% phase1 = the input phases before concatenation
% term = linear phase term
% t_f = time axis

function [phase_new]=add_linear_phase_concat_pic(phase1,term,t_f)

N=size(phase1,2);
for k=1:N
    phase_new(:,k)=phase1(:,k)-t_f'*term;
end
