% this function makes the axes for a temporal plot

function []=temp_plot2(a9,k)
figure('Color','w');
plot(abs(a9),'linewidth',3);
ylim([0 1]);
xlim([0 (500)]);
xlabel('Time (ps)','fontsize',16);
ylabel('Amplitude','fontsize',16);
title('Temporal amplitude','fontsize',16);
set(gca,'fontsize',16);
set(gca,'box','on','linewidth',2.5)
set(gca,'Position',[.13 .15 .7 .73]);