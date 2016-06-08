% this function plots the MUD tadpole data for me:

plot5yy(t_f*1e-3,Norm(abs(Et).^2),unwrap(angle(Et)),'time');
% dt=mean(abs(diff(t_f)));
% N=size(amp,2);
plot(t1,abs(amp),'linewidth',3)
temp_plot1('Concatenating the amplitudes','Amplitude')
