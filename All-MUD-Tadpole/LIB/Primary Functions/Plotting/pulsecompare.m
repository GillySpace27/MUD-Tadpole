function pulsecompare(sim_pulse, pulse)
%Compares two pulses by plotting them on the same figure.

figure('Position', [100, 100, 2000, 2000]);
movegui('center') 

pulseplot(sim_pulse, 'b')
pulseplot(pulse, 'r')


end