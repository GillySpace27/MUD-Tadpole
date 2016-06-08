%This function takes a raw picture from the drive and formats it to be used
%by the sea tadpole program.

function trace = tadimport(filename)

pic =imread(filename); %import the jpg
dpic = double(pic(:,:,1)); %take the red channel and typcast to double
rpic = dpic; %imresize(dpic, [201, 1000]); %resize image
npic = rpic ./ max(max(rpic)); %normalizes it to one
trace = npic'; %transpose and export
end

