function refphase = make_refphase(pulse_freq);

phi = pulse_freq(:,4);

phinew =imresize(phi, 16, 'bicubic');

refphase = phinew;

end