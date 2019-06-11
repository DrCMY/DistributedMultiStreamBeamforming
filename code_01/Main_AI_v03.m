% clc; clear variables; 
close all; fclose('all'); delete('*.log','*.bak'); % dbstop if error; dbclear if error;
warning('off','all'); %warning
%%%%%%%%%%%%%%
[CodeFolder,DataFolder]=Code_Data_Folders_v01;
fname=dir('*runme*.xlsx');
x=xlsread(fname.name,'A1:A200');
C=xlsread(fname.name,['A1:A2' num2str(length(x))]);
CCell = num2cell(C);

[MonteCarlo, MonteCarloT, K, M, N, d, R, PdBTxRx, PdBRRx, sigma2k1, sigma2k2, sigma2r, iterlimit, rhoF, rhocF, rhoU, rhocU, Delta, PDelta, faultlimit, wmin, wstep, wmax]=CCell{:};
LPPdB=length(PdBTxRx);

B=K*d;                      % Total number of streams in the network
Name1=sprintf('K%dM%dN%dB%dR%d_MC%d',K,M,N,B,R,MonteCarlo); 
Name2=['T' mat2str(PdBTxRx) 'R'  mat2str(PdBRRx)]; 

% Checking the input files
InputFolder=InputFolder_v01(MonteCarlo,K,R,Name1,DataFolder);
[status,list]=system(['dir ' InputFolder ' /b']); 
if status==1
    disp('The input files are missing. They are now being generated. Please wait.')
    %pause(3);
    TempFolder=[DataFolder 'Temp\' Name1 '\' ]; 
    mkdir(TempFolder)
    copyfile(fname.name,TempFolder);
    [~,list]=system('dir G*.m /b');
    runner=textscan(list, '%s %s', 'delimiter','.');    
    copyfile([char(runner{1}) '.m'],TempFolder);
    cd(TempFolder)
    run(char(runner{1}))  
    copyfile('Inputs',[DataFolder 'Inputs\'])
    cd ..
    rmdir(Name1,'s')  
end
cd(CodeFolder)
%%
% The random channel and beamforming vector input files are copied to the current directory 
copyfile(InputFolder,pwd);
unzip(InputFolder);
delete('*.zip');
%%
disp('Now the code is being executed.')
AI_v03(MonteCarlo,MonteCarloT,K,M,N,d,R,B,PdBTxRx,PdBRRx,sigma2k1,sigma2k2,sigma2r,LPPdB,iterlimit,rhoF,rhocF,rhoU,rhocU,Delta,PDelta,Name1,Name2,faultlimit,wmin,wstep,wmax,InputFolder)
