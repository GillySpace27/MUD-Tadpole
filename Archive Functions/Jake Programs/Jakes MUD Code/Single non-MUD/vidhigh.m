% this gets the camera set up for a low-resolution screen 640x480

%vid = videoinput('dcam',1,'F7_Y8_2208x3000');
%src=getselectedsource(vid);
%src.shutter=30;

vid = videoinput('winvideo',1,'F7_Y8_2208x3000');
src=getselectedsource(vid);
src.shutter=30;