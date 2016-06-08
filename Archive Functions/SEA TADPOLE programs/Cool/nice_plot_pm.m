function [] = nice_plot_pm()
% NICE_PLOT Changes the current figure properties to make it look nicer.
%

%   NICE_PLOT() changes the font size of all the children of the current
%   figure, the font size of the x and y labels, the line width of the
%   axis, and make the axis tight.

version = '$Id'; disp(version);

current_axis = gca;
axis tight;

%%% Options
axis_FontSize = [16]
label_FontSize = [16]
LineWidth = [1]
%%%

xlabel_handle = get(current_axis,'XLabel');
ylabel_handle = get(current_axis,'YLabel');
zlabel_handle = get(current_axis,'Zlabel');
title_handle = get(current_axis, 'Title');

set(current_axis,'FontSize', axis_FontSize);
set(xlabel_handle,'FontSize', label_FontSize);
set(ylabel_handle,'FontSize', label_FontSize);
set(zlabel_handle,'FontSize', label_FontSize);
set(title_handle, 'FontSize', label_FontSize);
set(current_axis,'LineWidth', LineWidth);

figure_hanlde = gcf;
children_handle = get(gcf, 'Children');
kids = length(children_handle);

fprintf(1, 'The current figure has %d child(ren).\n', kids);

for kid = [1:kids]
    current_handle = children_handle(kid);
    set(current_handle, 'FontSize', axis_FontSize);
   
end




