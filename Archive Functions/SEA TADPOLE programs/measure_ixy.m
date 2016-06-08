function [I] = measure_ixy(s,vid, spotsize);
 


fclose(s{1})
fopen(s{1})
fclose(s{2})
fopen(s{2})

homex = find_position(s,4);
homey = find_position(s,1);

x = [homex-spotsize:spotsize/60:homex+spotsize];
%y = [homey-spotsize:spotsize/10:homey+spotsize];
    
move_to_position(s,x(1),4);
move_to_position(s,x(1),1);
preview(vid);   
I = [];

dax = abs(x(2)-x(1));    

n = 1;
m =1;
length(x)
while m<=length(x);    
    while n <= (length(x));
        I(n,m)=sum(sum(fw_snap(vid)));
        move_stage(s, dax,4);
        n = n+1;
    end
move_stage(s,dax,1);
move_to_position(s,x(1),4);
n = 1;
m = m+1
end

move_to_position(s,homex,4);
move_to_position(s,homey,1);    
close all
imagesc(I);

end