function prepare_scan(cam,s,stageStartP)
%Sends the stage to the start position and runs the camera until S is
%pressed

move_to_position(s,1,stageStartP);
figure();
movegui('northeast');
fprintf('Press S when ready to Take Measurement...\n');
vidcap_thorcam(cam);

end

