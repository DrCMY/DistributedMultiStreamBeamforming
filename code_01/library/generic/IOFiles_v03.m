function [fi1,fi2,fi3,fi4,fi5,fi6,fido1,fido2,fido2E,fido3,fido3E,fido4,fido5,fido5E,fido6,fido6E,fido7,fido7E,fido8,fido8E,fido9,fido9E,Name]=IOFiles_v03(Name1,Name2,cverSubFile_b)
% Input files
fi1=sprintf([Name1 '_J.tex']);     % Pre-saved S-D channels
fi2=sprintf([Name1 '_H.tex']);     % Pre-saved S-R channels
fi3=sprintf([Name1 '_G.tex']);     % Pre-saved R-D channels
fi4=sprintf([Name1 '_U.tex']);     % Transmit beamforming matrices
fi5=sprintf([Name1 '_F.tex']);     % Relay beamforming matrices
fi6=sprintf([Name1 '_V.tex']);     % Receive beamforming matrices
Name=[Name1 '_' Name2 ];

% Output files
fo1=sprintf([Name '_iter_iterav_PTot_PTotav_' cverSubFile_b '.log']);      % Logging some details for each Monte Carlo run
fo2=sprintf([Name '_sinrt_sinr_PTot_iter_' cverSubFile_b '.log']);         % Logging some details for each Monte Carlo run
fo2E=sprintf([Name '_sinrt_sinr_PTot_iter_' cverSubFile_b '_ReadMe.log']); % Explanatory file
fo3=sprintf([Name '_AllOutputs_Final_' cverSubFile_b '.log']);              % Logging some details at the end of all Monte Carlo runs
fo3E=sprintf([Name '_AllOutputs_Final_' cverSubFile_b '_ReadMe.log']);      % Explanatory file
fo4=sprintf([Name '_MissedChannels_' cverSubFile_b '.log']);               % Logging Monte Carlo numbers of all missed channels
fo5=sprintf([Name '_sinrt_sinr_PTot_iter_wMissedChannels_' cverSubFile_b '.log']);         % Logging some details for each Monte Carlo run including the missed channels
fo5E=sprintf([Name '_sinrt_sinr_PTot_iter_wMissedChannels_' cverSubFile_b '_ReadMe.log']); % Explanatory file
fo6=sprintf([Name '_NonConverging_' cverSubFile_b '.log']);                % Logging some details of missed channels due to non-convergence, i.e., missed(2)
fo6E=sprintf([Name '_NonConverging_' cverSubFile_b '_ReadMe.log']);        % Explanatory file
fo7=sprintf([Name '_SlowConverging_' cverSubFile_b '.log']);               % Logging some details of missed channels due to slow-convergence, i.e., missed(3)
fo7E=sprintf([Name '_SlowConverging_' cverSubFile_b '_ReadMe.log']);       % Explanatory file
fo11=sprintf([Name '_ChannelsDetails_' cverSubFile_b '.log']);             % Logging the results of all Monte Carlo runs, i.e, success, non-convergence, slow-convergence, transmit/relay power violations
fo11E=sprintf([Name '_ChannelsDetails_' cverSubFile_b '_ReadMe.log']);     % Explanatory file
fo14=sprintf([Name '_PowerViol_' cverSubFile_b '.log']);                   % Logging some details of missed channels due to the transmit or relay power violations
fo14E=sprintf([Name '_PowerViol_' cverSubFile_b '_ReadMe.log']);           % Explanatory file  

% IDs of the output files
fido1 = fopen(fo1,'w'); fido2 = fopen(fo2,'w'); fido2E = fopen(fo2E,'w'); fido3 = fopen(fo3,'w'); fido3E = fopen(fo3E,'w');
fido4 = fopen(fo4,'w'); fido5 = fopen(fo5,'w'); fido5E = fopen(fo5E,'w'); fido6 = fopen(fo6,'w'); fido6E = fopen(fo6E,'w'); fido7 = fopen(fo7,'w'); fido7E = fopen(fo7E,'w');
fido8 = fopen(fo11,'w'); fido8E = fopen(fo11E,'w'); fido9 = fopen(fo14,'w'); fido9E = fopen(fo14E,'w'); 