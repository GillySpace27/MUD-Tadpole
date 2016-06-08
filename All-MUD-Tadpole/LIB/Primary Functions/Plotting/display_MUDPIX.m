function display_MUDPIX( MUDPIX )
%Displays all of the pictures in the MUDPIX file

L = length(MUDPIX);

figure()
for n = 1:L
    %Display the image
    h = imagesc(MUDPIX(n).lam, MUDPIX(n).x , MUDPIX(n).data);
    set(gca,'YDir','normal')
    xlabel('Wavelength (nm)')
    ylabel('Position (nm)')
    title(sprintf('Picture %d/%d, Position: %0.3f mm',n,L, MUDPIX(n).pos))
    hold_on(0.3)
end

end

