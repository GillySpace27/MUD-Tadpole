function [newcolor]= plot_extz(ez, X,t,Z, newcolor);

 

%options 
width = .075;
find_new_color = false;
%

s  =size(ez);
r =s(2); 
dt = abs(t(1)-t(2));
n = 1;

%reduce the size of extz
reduce_size = false;
if reduce_size == true;    
    ez_new = {};
    X_new = {};
    n = 1;
    while n<=8;
        ez_new{n} = ez{2*n};
        X_new{n} = X{2*n};
        n = n+1;
    end
    X  = X_new;
    ez = ez_new;
    %Z = [ -1.75 -1.25 -0.75 -.25 .25 .75 1.25 1.75];
    %Z = [2 -1.5 -1 -0.5 0 .5 1 1.5 2];
    s  =size(ez);
    r =s(2); 

end


dx =[];
deltax = [];
n = 1;
while n <=r;
   X{n}; 
    dx(n) = abs(X{n}(1)-X{n}(2));
    deltax(n) = abs(X{n}(1)-X{n}(end));
    n = n+1;
end
smallest = min(dx);
largest = max(deltax);

%this part makes each image the same size in the position dimension.
n = 1;
ez2 = {};
pos2 =[];
X2 = {};
if  find_new_color == true;
    newcolor ={};
end
while n<=r;
m  =size(ez{n});
missing = largest - deltax(n); 
p = missing/dx(n);
p = round(p/2);
   
    
    if find_new_color == true;
        t_int = meshgrid(t,X{n});
        phi_temp = unwrap(angle(ez{n}),[],2);
        w_int = -diff(phi_temp,1,2)./diff(t_int,1,2)+ltow(800);
        color = (ltow(w_int))-8+5.3;
        color = new_colormap(ez{n},color);
        newcolor{n} = color;
        newcolor{n} = cat(1,zeros(p,m(2)-1,3),newcolor{n},zeros(p,m(2)-1,3));
    end
    
  
    
    ez2{n} = cat(1,zeros(p, m(2)), ez{n}, zeros(p,m(2)));
    ez2{n} =   ez2{n}/max(max(ez2{n}));
    
    m =size(ez2{n});
    X2{n} = [1:m(1)]*dx(n);
    X2{n} = X2{n}-mean(X2{n});
    n = n+1;
end   
n = 1;
while n <=r;
    m = size(ez2{n}); 
    size_ez2(n) = m(1);
    n= n+1;
end
   largest = max(size_ez2);

   
%resizes the images by changeing the resolution so that they are all the same size.
n = 1;



while n<=r;
    q = size(ez2);
    n
    %these lines change the widths of the subplots
    h = subplot(1,q(2),n);
    test = get(h,'position');
    test(3) = width;
    set(h, 'position',test);
    
    %find the pulse front
    m = size(ez2{n});
    E = ez2{n};
    pf = [];
    [p1,middle]=max(ez2{n}(:,floor(m(2)/2)));
    L = size(ez{n});
    L  = L(1);
    s = floor(L/2);
    s =15;
   
    
   %middle = middle+2 ;
    q = 1;
    if n==4;
        s = 23;
        
        middle  = middle;
    end
    if n == 9;
        middle = middle ;
        s = 15;
         
    end
    if n == 6;
        s = 24;
         %s = 10
        %middle = middle-1;
    end
    if n == 5;
        s = 12;
        %middle = middle-2;
    end
    l = middle-s;
     lo = l;
    while l<middle+s;
        [h,p] = max(abs(E(l,:)).^2);
        pf(q) = t(p);
        q = q+1;
        l =l+1;
    end
    x2 =X2{n}(lo:l-1);
    z = 1.3*ones(size(x2));
    
         
   
    %h = surf(t,X2{n},abs(ez2{n}.^2), newcolor{n});   
    %set(h,'Meshstyle', 'row')
    if nargin == 4;
        imagesc(t,X2{n},abs(ez2{n}.^2))
    else
        imagesc(t,X2{n},newcolor{n})
    end
    %[c,g] = contour(t,X2{n},abs(ez2{n}.^2));
    %contour_handle =get(g,'children'); 
    %set( contour_handle,'LineWidth', 3);

    %plot3(pf,X2{n},z,'.g')
   
    hold on
   
    plot3(pf,x2,z,'.w')
   
    if n>1
        axis off
    end
    title(['z = ' num2str(round(Z(n)*100)/100) ' mm'])
  
    
  n = n+1;
end

%ezfinal = (cat(2,ez4{:}));
%s = size(ezfinal);
%t =[1:s(2)]*dt;
%t = t-mean(t);
%xnew = [X{end}(1):min(dx):X{end}(end)];

%imagesc(t,xnew,abs(ezfinal).^2)


