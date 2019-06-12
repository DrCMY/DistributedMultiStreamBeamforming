function AI_v05M(MonteCarlo,MonteCarloT,K,M,N,d,R,B,PdBTxRx,PdBRRx,sigma2k1,sigma2k2,sigma2r,LPPdB,iterlimit,rhoF,rhocF,rhoU,rhocU,Delta,PDelta,Name1,Name2,faultlimit,wmin,wstep,wmax,InputFolder)
tgGlobal=tic;
PLinTxRx=10^(0.1*PdBTxRx);         % Maximum linear transmit power value between source and destination, i.e., transmitter power constraint        
PLinRRx=10^(0.1*PdBRRx);           % Maximum linear transmit power value between relay and destination, i.e., relay power constraint 
P_MC=zeros(B,1);                % Power vector stores power consumption values for each stream.
iter_MC=0;                     % Step scalar that stores the number of steps needed for the algorithm to converge
N2=N^2;                       % Squared value of N (number of antennas at a relay)
N2p1=N2+1;                    % Squared value of N (number of antennas at a relay) plus one
iter_Logger=zeros(1,MonteCarloT);

sinr_MC=zeros(K,d);              % sinr is a matrix variable that stores SINR values of each stream.
DeltaLogs=zeros(1,iterlimit);      % DeltaM is vector variable that stores the sum of $\Delta_{k,l}$ values (See step 6 in Algorithm 1) for each iteration. Algorithm is assumed to converge when $\Delta_{k,l}\leq\Delta_{k,l}^\text{max} \forall k,l$

%%
% Fault monitoring window parameters. For some channels, convergence can be too slow, for instance, due to high number of oscillations. To detect these channels earlier
% and to save time, a fault monitoring window is created. 
steprange=wmin:wstep:wmax;    
AverageDeltaLogs=zeros(length(steprange),1);
AverageDeltaLogs(1)=100;

%%
[cverSubFile_a,cverSubFile_b]=CodeVersion_v01(mfilename);             % Calling subfunction to detect the version of the current code
delete('*.bak');

%%
% Input/output file IDs are created along with their explanatory files
[fi1,fi2,fi3,fi4,fi5,fi6,fido1,fido2,fido2E,fido3,fido3E,fido4,fido5,fido5E,fido6,fido6E,fido7,fido7E,fido8,fido8E,fido9,fido9E,Name]=IOFiles_v03(Name1,Name2,cverSubFile_b);
ExplanatoryFiles_UFIterII_v02(fido2E,fido3E,fido5E,fido6E,fido7E,fido8E,fido9E,fido1,Name2,Delta,iterlimit,rhoF,rhocF,rhoU,rhocU,faultlimit,wmin,wstep,wmax)

%%
loaders=zeros(1,5); % Loaders (counters) for the random channel and beamforming vector input files. To read the next set of inputs from the saved textfiles, these counters are updated at each Monte Carlo run
mc=1;               % Monte Carlo counter
missed=zeros(1,5);  % This vector stores information about the missed channels. See UserManual.docx file for further info

%%
% Missed Channels
DataFolder=DataFolder_v01;     % Locations of the data folder 
AllMissedChannels=dir([DataFolder '*AllMissedChannels*']);
if AllMissedChannels.bytes==0
    mchannels=0;
else
    mchannels=dlmread(AllMissedChannels.name); % Missed channels
end
mccounter=1;  % missed channels counter
%%
while mc-missed(1)<=MonteCarloT && mc<=MonteCarlo % Due to the missed channels MonteCarlo variable is set to be a higher value than the MonteCarloT (Monte Carlo target) variable. For instance, if you want to test 20 Monte Carlo channels, you should set MonteCarloT=20 and a safe MonteCarlo>MonteCarloT value, such as MonteCarlo=30. Therefore, in case, 10 channels are missed, 20 channels can still be tested
    if ismember(mccounter,mchannels)==0
        checkwhilei=zeros(K,1);           % While loop is (Iterations are) terminated when each stream achieves the SINR target, i.e., when $\Delta_{k,l}\leq\Delta_{k,l}^\text{max}, \forall k,l$                      
        counter=2;                        % Counter used for DeltaM vector        
        DeltaMin=1e2;                     % Initialization of average value of deltas. Optimum beamforming vectors are updated when smaller average value of deltas (SINR target deviations) is obtained
        fault=0;                          % Counter for testing whether maximum number of faults (i.e., faultlimit) is reached or not        
        iter=1;                          % Total number of steps (iterations) needed by the algorithm to converge
        Uopt=zeros(K,B);
        Xklopt=zeros(M,B*M);        
        
        [J,Hpp,G,U,F,V,V1,V2,loaders]=Channels_v01(K,R,M,N,B,d,loaders,PLinTxRx,fi1,fi2,fi3,fi4,fi5,fi6); % Loading channel and beamforming matrices
        [F,hYr]=F_hYr_v02(K,R,M,N,d,Hpp,U,F,PLinRRx,sigma2r); % Rescaling the relay filter powers to their maximum power values. hYrM matrix stores the \mathbf{Y}_r matrices in (43)
        [Xkl,sinr]=Xkl_sinrx_v02(K,R,M,N,B,d,J,Hpp,G,U,F,V,sigma2k1,sigma2k2,sigma2r); % Calling a subfunction to obtain the initial SINR values of each stream (sinrx variable) and covariances of transmit beamforming vectors (XklMp)
        sinrt=mean(sinr,2);                                    % Setting the SINR targets based on SINRs that are evaluated via random inputs
        [lambdavF,zetavF,zetanvF,muvF,munvF,lambdavU,zetavU,zetanvU,muvU,munvU]=VarInits_UFIterII_v01(K,R,B,d);  % Initializations of Lagrange multipliers
        
        %%
        while sum(checkwhilei)<K && iter<=iterlimit              % Algorithm is terminated either when all SINR targets are achieved or maximum number of iterations is achieved 
            %%
            %%%%%%%%%%%%%%
            % Distributed optimization of transmit filters - start         
            [Rdk,Rbkl,sigma2kl]=Rdk_Rbkl_sigma2kl_UFIterII_v02(K,R,M,N,B,d,J,Hpp,G,F,V,sigma2k1,sigma2k2,sigma2r); % See the subfunction for the details
            [U,Xkl]=U_Xkl_UFIterII_v04(K,M,d,Rdk,Rbkl,sinrt,sigma2kl,U,Uopt,Xkl,Xklopt,zetavU,iter,Delta,PDelta,PLinTxRx);      % See the subfunction for the details
            sinr=sinrxNew_v01(K,M,d,Rbkl,Xkl,sigma2kl);                                                              % New SINR values of streams are evaluated after the updates of beamforming vectors
            [Deltax,iter,counter,checkwhilei,missed,fault,DeltaLogs,AverageDeltaLogs]=Delta_Logging_v02(K,sinr,sinrt,Delta,DeltaLogs,AverageDeltaLogs,counter,iter,steprange,missed,fault,faultlimit,iterlimit,wmin,mc,fido6,fido8); % See the subfunction for the details           
            if Deltax<DeltaMin    %If smaller average of deltas is obtained in this iteration, the optimum beamforming vectors are updated
                DeltaMin=Deltax;
                Xklopt=Xkl;
                hYropt=hYr;
                Fopt=F; 
                Uopt=U;
            end         
            [lambdavU,zetavU,zetanvU,muvU,munvU]=NewVarsU_v01(K,M,d,Rbkl,Xkl,sinrt,sigma2kl,lambdavU,zetavU,zetanvU,muvU,munvU,rhoU,rhocU); % See the subfunction for the details
            % Distributed optimization of transmit filters - end
            %%%%%%%%%%%%%%            
            
            %%
            %%%%%%%%%%%%%%
            % Distributed optimization of relay filters - start
            tCklrin=tCklrin_v01(K,R,M,N,B,d,J,Hpp,G,U,F,V1,V2,sigma2k1,sigma2k2,sigma2r,N2,N2p1); % See the subfunction for the details    
            Drkl=Drkl_v02(K,R,M,N,B,d,Hpp,U,F,sigma2r); 
            zetavpF=zetavF;     % Previous values are stored
            zetanvpF=zetanvF;   % Previous values are stored         
            [F,hYr]=F_hYr_UFIterII_v03(K,N,d,R,sinrt,sigma2r,N2,N2p1,Drkl,tCklrin,zetavF,zetanvF,PLinRRx,Delta,PDelta,iter,F,Fopt,hYr,hYropt); % Relay beamforming F and covariance hYrM matrices are updated
            [lambdavF,zetavF,zetanvF,muvF,munvF,zetavU,zetanvU,muvU,munvU]=NewVarsF_UFIterII_v01(K,R,d,tCklrin,hYr,sinrt,rhoF,rhocF,lambdavF,zetavF,zetanvF,muvF,munvF,zetavU,zetanvU,muvU,munvU,zetavpF,zetanvpF,N2p1); % See the subfunction for the details
            % Distributed optimization of relay filters - end
            %%%%%%%%%%%%%%
%             if mc<3 % test
%                 iter=iterlimit;
%             end
            iter=iter+1; 
        end      
        [PTot,PTx,PR]=PTot_PTx_PR_UFIterII_v02(K,R,M,N,d,Hpp,Xkl,Rdk,U,Fopt,sigma2r); % Evaluating total power consumption (PTot) and power consumption of transmitters (PTx)
        [sinr_MC,P_MC,missed,iter_Logger,iter_MC]=Logging_v04(K,R,B,PTot,PTx,PR,P_MC,PLinTxRx,PLinRRx,sinr_MC,sinrt,sinr,checkwhilei,iter,iter_MC,PDelta,DeltaLogs,missed,mc,fault,faultlimit,iter_Logger,fido1,fido2,fido4,fido5,fido7,fido8,fido9);        
        if missed(1)>MonteCarlo-MonteCarloT % Because of break, this if statement cannot be placed in a subfunction
            for i=1:3
                disp(newline)
                disp(['[' 8 '-->> WARNING: Cannot meet the Monte Carlo target! <<--]' 8])
            end
            break
        end
        mc=mc+1;
    else
        loaders=IncreaseLoaders_v01(K,R,M,N,loaders);
    end    
    mccounter=mccounter+1;
end
maxofiters=max(iter_Logger);
Outputs_UFIterII_v03(MonteCarlo,MonteCarloT,K,M,N,d,R,B,PdBTxRx,PdBRRx,LPPdB,Name,sinr_MC,P_MC,fido1,fido3,cverSubFile_a,cverSubFile_b,Delta,PDelta,iterlimit,rhoF,rhocF,rhoU,rhocU,faultlimit,wmin,wstep,wmax,iter_MC,missed,tgGlobal,InputFolder,sinrt,datetime,maxofiters);           
