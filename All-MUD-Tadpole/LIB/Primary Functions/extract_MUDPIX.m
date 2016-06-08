function [ MUDDAT ] = extract_MUDPIX( MUDPIX, REF )
%
%  Extract the spectrum and phase from each captured photo
%
printf('Analyzing Pictures')
tic

pics = 0;
worked = 0;
N_traces = length(MUDPIX);

%% Extract the spectrum and phase from each photo and store
for nn = 1:N_traces
   
    %Retrieve the Spectrum and Phase
    [phi, spectrum, success] = find_phi_jake2(MUDPIX(nn).data,((REF.data)),.1);
    
        % Plot the temporal and spectral phases of each retrieved pulse on a
        % single graph.
        
         %plotspecphi(spectrum, phi, MUDPIX{nn}.lam)
    
    %Increment Counters
        pics = pics + 1;
        worked = worked + success;
    
    %Store data in structure
    MUDDAT(nn).img = MUDPIX(nn).data;
    MUDDAT(nn).lam = MUDPIX(nn).lam;
    MUDDAT(nn).x = MUDPIX(nn).x;
    MUDDAT(nn).pos = MUDPIX(nn).pos;
    MUDDAT(nn).spec = spectrum;
    MUDDAT(nn).rawphi = unwrap(phi);  %Just the Tadpole Phase
    MUDDAT(nn).phi = (unwrap(phi) + REF.gPhi); %Tadpole + Gren Phase
    MUDDAT(nn).success = success; 
    
    if ~mod(nn,floor(N_traces/3))
        printf('.')
    end
    
end

    fprintf('Analyzed %d pictures, %d were successful. Took %0.2f seconds.\n', pics, worked, toc);

end





