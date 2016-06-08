function [pf,newcolor] = pulse_front(et, time,x)

%%%Options
skip_surface_plot = false;
skip_new_color = true;
%time is probabily in ps so I am putting it into fs here
time = time*1000;
%%%
close(figure(1))
delt = (max(time)-min(time))./length(time);
m = size(et);
w = m(1);
n =1;
x = x-mean(x);

pf= [];
n = 1;
    %fig = (imrotate(abs(et).^2,ang,'bicubic'));
    %fignew = fig(10:end-10,2:end-1);

while n <= w;
    [h, pk] =max((et(n,:).^2));
     pf(end+1) = time(pk);
n = n+1;
end
length(x)

%To make color represent phase

t_int = [];
n = 1;

while n<=length(x);
    t_int(n,:) = time;
    n = n+1;
end
%c2 = 520;
c2 =700;
c1 =450;
%c1 = 500;
phi_temp = unwrap(angle(et),[],2);
w_int = diff(phi_temp,1,2)./diff(t_int,1,2)+ltow(800);
color = (ltow(w_int(:,c1:c2)));
%%%change color map here

if skip_new_color == false;
    newcolor = new_colormap(et(:,c1:c2),color);
else
    newcolor = color;
end

h = surf(time(c1:c2),x,(abs(et(:,c1:c2)).^2)./max(max((abs(et(:,c1:c2)).^2))),newcolor);
if skip_surface_plot == true;
    imagesc(time(c1:c2),x,(abs(et(:,c1:c2)).^2)./max(max((abs(et(:,c1:c2)).^2))));
end

hold on

z = 1.1*ones(size(x));
plot3(pf,x,z,'.g')
colormap jet

skip = false;
if skip == false;


%For the plot
current_axis = gca;
axis_FontSize = [16];
label_FontSize = [16];
LineWidth = [1];
%xlabel('Time (fs)')
%ylabel('Transverse Positon (mm)')
%title('Temporal Intensity as a Fuction of Transverse Position')
xlabel_handle = get(current_axis,'XLabel');
ylabel_handle = get(current_axis,'YLabel');
title_handle = get(current_axis, 'Title');
set(current_axis,'LineWidth', LineWidth);
set(current_axis,'FontSize', axis_FontSize);
set(xlabel_handle,'FontSize', label_FontSize);
set(ylabel_handle,'FontSize', label_FontSize);
if skip_surface_plot == false;
    set(h, 'MeshStyle','row'); 
end
    axis tight
%colorbar
set(title_handle, 'FontSize', label_FontSize);
end
