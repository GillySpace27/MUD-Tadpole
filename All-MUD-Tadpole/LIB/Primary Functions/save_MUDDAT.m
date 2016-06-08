function save_MUDDAT(MUDDAT, filename, keep_data)
% This function allows you to save your MUDDAT file so that you can run the
% extraction multiple times without having to resimulate/recapture your
% traces.


if keep_data
    save(filename, 'MUDDAT')
else
    MUDDAT = rmfield(MUDDAT,'img'); %Dramatically decreases file size
    save(filename, 'MUDDAT')
end