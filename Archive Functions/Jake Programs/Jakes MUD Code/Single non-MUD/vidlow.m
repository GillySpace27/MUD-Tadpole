% this gets the camera set up for a low-resolution screen 640x480

vid = videoinput('dcam',1,'Y8_640x480');
src=getselectedsource(vid);
src.shutter=30;
