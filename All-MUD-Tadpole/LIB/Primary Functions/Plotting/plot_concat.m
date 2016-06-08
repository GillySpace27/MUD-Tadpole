function plot_concat(Valid_unk,Valid_H,tw,tsp)
%This function plots the temporal information of each of the cross
%sections, superimposed on the same graph.

% Assign each slice to the correct timeslot
[Uindex,~]=index_temporal_slices(Valid_unk,Valid_H,tw,tsp);

    % makes an object where the first column is data from a single pulse, next
    % is index location where each part of the pulse should be located,
    % repeated for each pulse

% Getting the
[amp,t1]=field_ready(Uindex);

    % amp is the complex temporal amplitude of the concatinated pulses
    % t1 is the index at which each point in amp should be plotted


figure
subplot(1,2,1)
plot(t1,abs(amp).^2)
title('Temporal Intensity')
xlabel('Time (in points)')

subplot(1,2,2)
plot(t1,unwrap(angle(amp)))
title('Temporal Phase')
xlabel('Time (in points)')

end