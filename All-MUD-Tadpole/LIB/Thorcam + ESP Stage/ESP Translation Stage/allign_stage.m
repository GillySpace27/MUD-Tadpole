function [x,v,phase]=allign_stage(s,vid,bg,cal,axis);
%this is to make sure that the scanning direction(in x or y) is perpendicular to the
%beam's propagation direction.
%[phase]=allign_stage(s,vid,bg,cal);
%%
%axis = 1;
dx = .3;
x = [-4:dx:4];
home = display_position(s,axis);
phase = [];
spectrum = [];
n = 1;
preview(vid)
%%

dat = fw_snap(vid);
b = (fftc(dat-bg));
B = (Norm(abs(mean(b'))));
[peaks, h] = smart_lclmax(B);

%%
move_to_position(s,x(1),axis);
while n<=length(x);
    dat = fw_snap(vid);
    [phi, spec] = find_phi_scanning(bg, vid,peaks);
    phase(n,:) = (phi);
    spectrum(n,:) = spec;
    move_stage(s,dx,axis);
    hold_on(1)   
    n =n+1;
end
[v,phasefit,ebars] = fit_phase(phase,cal);
close all;
plot(x,v,'.');
move_to_position(s,home,axis)

end