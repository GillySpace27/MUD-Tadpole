function export_MUDPIX( MUDPIX, REF , filename, type)
% This will export the MUDPIX file as a series of bmp or as an
% animated gif. type should be a string, any of {'gif', 'bmp', 'both'}.
% Probably not as useful as save_MUDDAT, which allows you to re-run the
% experiment without taking new data.

%Time between each picture of the gif in seconds.
gifdelay = 0.2;



% Parses mode selection
bmp = false;
gif = false;
switch type
    case 'bmp'
        bmp = true;
    case 'gif'
        gif = true;
    case 'both'
        gif = true;
        bmp = true;
    otherwise
        error('Not a valid type. Type should be one of {''gif'', ''bmp'', ''both''}.');
end

% Save the Reference Trace
    h = imagesc(REF.data);
    saveas(h,sprintf('%s_REF.bmp', filename))
%     save(sprintf('%s_REF',filename), REF)

for n = 1:length(MUDPIX)
    %Display the image
    h = imagesc(MUDPIX(n).data);
    if bmp
        %Save as a bitmap
        saveas(h,sprintf('%s_%d.bmp', filename, n))
    end
    
    frame = getframe(1);
    im = frame2im(frame);
    [A,map] = rgb2ind(im,256);
    
    if gif
        %Save as a gif
        if n == 1
            imwrite(A, map, sprintf('%s.gif', filename), 'gif','LoopCount',Inf,'DelayTime',gifdelay);
        else
            imwrite(A, map, sprintf('%s.gif', filename), 'WriteMode', 'append', 'DelayTime', gifdelay);
        end
    end
    
    
end

end

