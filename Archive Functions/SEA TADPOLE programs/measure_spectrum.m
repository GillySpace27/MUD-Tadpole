function [spectrum,x] = measure_spectrum(s,vid, spotsize,axis,x);
 

preview(vid)
fclose(s{2})
fopen(s{2})

home = find_position(s,axis);
%home = 0;
if nargin == 4;
    x = [home-spotsize:spotsize/60:home+spotsize];
end
move_to_position(s,x(1),axis);


%preview(vid);   
spectrum = [];
pos = [];
da = abs(x(2)-x(1));    
n = 1;
while n <= (length(x));
    dat=fw_snap(vid);
    spec = sum(dat);
    spec = spec-spec(10);
    spectrum(n,:) = spec;
    %plot(spec)
    %title(find_position(s,axis));
    move_stage(s, da,axis);
    n = n+1;
end
move_to_position(s,home,axis);
close all
imagesc(spectrum);

end