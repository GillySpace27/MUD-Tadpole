% this program makes sound to indicate that the scan is done

function []=scan_end()
q=(1:1000)*2*pi;
sound(sin(q/10),4040);