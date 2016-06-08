function [v,v2,v0,phasereal,ebars] = make_vector(v,v2,v0, phasereal,dat,ebars,bg, vid);

%[v,v2,m] = make_vector(v,v2,vid,bg,m)
%This function makes adds an element to the vectors v1(delay) and
%v2(chirp) which come from the funcion fit_phase.  
%This function will ask fit phase to try agian if the fit is not as good 
%as the tolerance which is specified under options.  


%%%
%Options
cal = .3418;
tolerance = .054;


%%%


if nargin == 4;
    bg = 0;
end

[fit,fit_fun,phi] = fit_phase(dat-bg,cal,2);
v(end+1) = fit(2);
v2(end+1) = fit(1);
v0(end+1) = fit(3);

phasereal(end+1,:) = find_phi(dat-bg);

%here I am making sure that the fit is good
%if length(v) > 1;
    %test = abs(v(end)-v(end-1));
   
    diff = mean((fit_fun-phi).^2)
    m = 0;
ebars(end+1) = diff;  
    %Diff determines how good the fit to the phase has to be .5
    while diff > tolerance & m < 3;
        display('A bad fit.  Trying agian')
        dat=fw_snap(vid);
        [fit,fit_fun,phi] = fit_phase(dat-bg,cal,2);
        v(end) = fit(2);
        v2(end) = fit(1);
        phasereal(end,:) = find_phi(dat-bg);
        
        diff = mean(abs(fit_fun-phi).^2)
        ebars(end) = diff;
        m = m+1;
    end
if m==10;
    display('Impossible to do the fit.  The fringes are probobabily missing')
end
end