% this script takes the 6 colmn vector conatining the output from the frog
% reconstruction (this is a txt file)and makes the approriate vectors
%[t, temp_int, temp_phase, lam, sp_int, sp_phase] =
%load_frog(reconstructed_frog_data)

function [t, temp_int, temp_phase, lam, sp_int, sp_phase] = load_frog(frog_data);

t = frog_data(:,1);
temp_int = frog_data(:,2);
temp_phase = unwrap(frog_data(:,3)*2*pi);
lam = frog_data(:,4);
sp_int = frog_data(:,5);
sp_phase = unwrap(frog_data(:,6)*2*pi);

end