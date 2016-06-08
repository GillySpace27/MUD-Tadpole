function [] = plot_ew(lam,S,phi);
% plot_ew plots the spectrum and phase and puts the labels in in the
% specified font.  The two parameters to give the function are the time
% axis and the electric field in the time domain. If any fourth argument is given, then the title will be left out   
%[] = plot_ew(lam,S,phi);

%if isempty(figure) == 1;
%figure
%else clf reset
%end

FontSize = [16];

%plotting e(w)

phi = phi(Norm(S)>.05);
lam2 = lam(Norm(S)>.05);
[AX,H1,H2] =plotyy(lam, Norm(S), lam2, ((phi)));

%Axis titles

set(get(AX(1),'Ylabel'),'String','Intensity (a.u)'); 
set(get(AX(1),'Xlabel'),'String','Wavelength(nm)'); 
set(get(AX(2),'Ylabel'),'String','Phase (radians)');

notitle = true;
if notitle == false;
title('Spectrum and Phase') 
end

%setting fonts

x1label_handle = get(AX(1),'XLabel');
y1label_handle = get(AX(1),'YLabel');
x2label_handle = get(AX(2),'Ylabel');
title_handle = get(gca, 'Title');

set(x1label_handle,'FontSize', FontSize);
set(y1label_handle,'FontSize', FontSize);
set(x2label_handle,'FontSize', FontSize);
set(title_handle, 'FontSize', FontSize);

if nargin ~= 3
    axes(AX(1));
    axis tight;
    axes(AX(2));
    axis tight;
end

set(gca,'FontSize', FontSize);

figure_hanlde = gcf;
children_handle = get(gcf, 'Children');
kids = length(children_handle);

%sets the font size for all of the axes.  I do not understand it, but it
%works

for kid = [1:kids]
    current_handle = children_handle(kid);
    set(current_handle, 'FontSize', FontSize);
end
