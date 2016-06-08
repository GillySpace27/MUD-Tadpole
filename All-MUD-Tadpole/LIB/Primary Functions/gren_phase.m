function [ gPhi ] = gren_phase( grenfile, lam )
%GREN_PHASE Retrieves the Spectral Phase from a "speck.dat" file
%   This is used to get the reference phase from a grenoullie.

delimiter = '\t';
formatSpec = '%f%f%f%*s%*s%[^\n\r]';
fileID = fopen(grenfile,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter,  'ReturnOnError', false);
fclose(fileID);

refLam = flipud(dataArray{:, 1})' .* 10^-9;
refSpec = flipud(dataArray{:, 2})';
refPhase = flipud(dataArray{:, 3})';

%Generate a longer refPhase interpolation with the right number of points
gPhi = spline(refLam, refPhase, lam);

% refSpec = spline(refLam, refSpec, lam);

end

