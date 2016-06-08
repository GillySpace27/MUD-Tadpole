function s =  serial_init(com)

%This function initilaizes the serial port with the correct settings for
%the ESP 300 motion controller.  It returns s which is the object
%representing the serial port.  It also opens the port.
%s =  serial_init;
s = {};
s{1} = serial(com);
%s{2} = serial('COM8');
    
set(s{1},'BaudRate',19200);
set(s{1},'FlowControl','hardware');
set(s{1}, 'Terminator', 'CR');
 
fopen(s{1});
get(s{1});

% set(s{2},'BaudRate',19200);
% set(s{2},'FlowControl','hardware');
% set(s{2}, 'Terminator', 'CR');
% fopen(s{2});
%get(s{2})

end