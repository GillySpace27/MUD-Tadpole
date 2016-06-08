% this function gets everything reayd to take scanning data
% for 300mm lens and 600 grating
%dl=.0186;
% for 150mm lens and 600 grating
dl=.0373;
% for a 200 lens and a 600 grating:
dl=.0317;
% for a 100 and 600:
dl=.0567;
home1=0;
pks=[1031,1105];
lam0=805;
axis_num=1;
vid=videoinput('dcam',1,'F7_Y8_2208x3000');
src=getselectedsource(vid);
s = serial_init;
turn_on_stage_v2(s,1);
src.shuttermode='manual';
src.shutter=1;
