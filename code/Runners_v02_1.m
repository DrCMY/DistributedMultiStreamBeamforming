% Matlab codes for the proposed distributed joint transmit and relay beamforming filter optimization in Section VI. of the following paper:
% C. M. Yetis and R. Y. Chang, “Distributed multi-stream beamforming in MIMO multi-relay interference networks,” IEEE Access, vol. 7, pp. 7535–7554, Jan. 2019.
% These codes can be modified to obtain the proposed distributed transmit beamforming filter optimization in the same paper.
% The codes are written by C. M. Yetis
clc; close all; fclose('all'); dbstop if error; % dbclear if error;
totaltime=tic;
folder=fileparts(which(mfilename));
cd(folder)                                      % Change Matlab directory to the "code" folder
set(0,'DefaultFigureVisible','off');            % Comment here for the detailed figure outputs
%set(0,'DefaultFigureVisible','on');            % Uncomment here for the detailed figure outputs
%set(findobj(0,'type','figure'),'visible','on') % If the figures still do not open, run this line
%warnings
%pause(3)
[CodeFolder,DataFolder]=Code_Data_Folders_v01;  % Locations of code and data folders
datar=xlsread([DataFolder 'NetworkList.xlsx'],'A2:Z200'); % Read the NetworkList.xlsx file which contains the network parameters to be tested
Alphabet='ABCDEFGHIJKLMNOPQRSTUVWXYZ';
Kr=find(Alphabet=='A');                         % K: Number of users (Number of transmitter and receiver pairs) - NL
Mr=find(Alphabet=='B');                         % M: Number of antennas at each transmitter and receiver - NL
Nr=find(Alphabet=='C');                         % N: Number of antennas at each relay - NL
Rr=find(Alphabet=='D');                         % R: Number of relays - NL
TxdB=find(Alphabet=='E');                       % SNR between a transmitter and a receiver in dB - NL
RdB=find(Alphabet=='F');                        % SNR between a relay and a receiver in dB - NL
MC=find(Alphabet=='G');                         % The number of Monte Carlo runs - NL
MCT=find(Alphabet=='H');                        % The number of Monte Carlo runs-target - NL
Runners=find(Alphabet=='I');
version=textscan(mfilename, '%s %s %d', 'delimiter','__');
selected=find(datar(:,Runners)==version{3});
if isempty(selected)
    display(version{2}, 'There is no Runner_X.m call in the NetworkList.xlsx file: X')
end    
for iter=1:length(selected)
    iter
    x=selected(iter);
    cd(DataFolder)
    fname=dir('*runme*');    
    xlswrite(fname.name,[datar(x,Kr),datar(x,Mr),datar(x,Nr)]','A3:A5'),    
    xlswrite(fname.name,[datar(x,Rr),datar(x,TxdB),datar(x,RdB)]','A7:A9'),
    xlswrite(fname.name,[datar(x,MC),datar(x,MCT)]','A1:A2'),
    cd(CodeFolder)
    clearvars -except datar Kr Mr Nr Rr TxdB RdB MC MCT Runners selected lselected iter totaltime tic; 
    fname=dir('Main*.m');
    run(fname.name)
end
