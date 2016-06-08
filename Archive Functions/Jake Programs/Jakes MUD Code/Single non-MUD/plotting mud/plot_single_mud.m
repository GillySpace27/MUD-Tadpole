% this function plots all the necesary MUD TADPOLE plots

plot(t1,(abs(amp).^2),'linewidth',3);
temp_plot1('Concatenating the amplitudes');
saveas(gcf,'Concat.fig');
saveas(gcf,'Concat.png');
plot5yy(t_f*1e-3,abs(Et).^2,unwrap(angle(Et)),'time')
saveas(gcf,'temp.fig');
saveas(gcf,'temp.png');
plot5yy(lam_eq,Norm(abs(E_lam).^2),unwrap(angle(E_lam)),'wave')
saveas(gcf,'spectrum.fig');
saveas(gcf,'spectrum.png');
Single_MUD_trace(I1,dl,3.5e-3,lam0);
saveas(gcf,'trace with background.fig');
saveas(gcf,'trace with background.png');
Single_MUD_trace(abs(I1-Ref-bg),dl,3.5e-3,lam0);
saveas(gcf,'trace no background.fig');
saveas(gcf,'trace no background.png');
Single_MUD_spectrogram(Ew1',w1,tau);
saveas(gcf,'spectrogram.fig');
saveas(gcf,'spectrogram.png');
Single_MUD_fft(log(abs(fftc(I1-Ref-bg))).^2,dl,3.5e-3,lam0);
saveas(gcf,'FFT no background.fig');
saveas(gcf,'FFT no background.png');
% saving the workspace
save set.mat