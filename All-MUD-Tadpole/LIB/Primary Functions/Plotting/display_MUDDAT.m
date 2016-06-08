function display_MUDDAT( MUDDAT )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


figure();
N_traces = length(MUDDAT);

for nn = 1:N_traces
    
    if ~isfield(MUDDAT,'img')
        % If using a stored MUDDAT without images
        MUDDAT(nn).img = zeros( [length(MUDDAT(nn).x) length(MUDDAT(nn).lam)] );
    end
    
subplot(1,3,1)
plot(MUDDAT(nn).lam, norm1(MUDDAT(nn).spec))
title('Spectrum')

subplot(1,3,2)
imagesc(MUDDAT(nn).lam, MUDDAT(nn).x, MUDDAT(nn).img)
title(sprintf('Trace %d / %d', nn, N_traces))

subplot(1,3,3)

goodpsi = norm1(MUDDAT(nn).spec) > 0.1;
plot(MUDDAT(nn).lam(goodpsi), MUDDAT(nn).phi(goodpsi))
title('Spectral Phase')
    
waitforbuttonpress;
    
end


end

