function Generator_v02
rng('shuffle') 
tgGlobal=tic;
delete('*.log','*.tex'); 

dTxR=1e3;                      % Distance between a transmitter and relay in meters
dRRx=1e3;                      % Distance between a relay and a receiver in meters
dTxRx=dTxR+dRRx;               % Distance between a transmitter and a receiver in meters
lns=8;                         % Log-normal shadowing in dB

Mean=0;                        % Mean of the channel
SqrtVarpD=sqrt(.5);            % Variance of the channel per dimension

a=dir('*runme*');
C=xlsread(a.name,'A1:A25');
CCell = num2cell(C);
[MonteCarlo, ~, K, M, N, d, R]=CCell{:};

B=d*K;                         % Total number of streams in the network
U_norm=zeros(M,B);             % Normalized transmit beamforming vectors
V_norm=zeros(2*M,B);           % Normalized receive beamforming vectors

Name=sprintf('K%dM%dN%dB%dR%d_MC%d',K,M,N,B,R,MonteCarlo); 

filename1=[Name '_J.tex'];  % Channels between the transmitters and receivers
filename2=[Name '_H.tex'];  % Channels between the transmitters and relays
filename3=[Name '_G.tex'];  % Channels between the relays and receivers

% Random generation of filters depend on the iterative algorithm to be
% proposed.
filename4=[Name '_U.tex']; % Transmit beamforming file
filename5=[Name '_F.tex']; % Relay beamforming file
filename6=[Name '_V.tex']; % Receive beamforming file

J=zeros(K*M,K*M);
H=zeros(R*N,K*M);
G=zeros(K*M,R*N);
for mc=1:MonteCarlo
    L=10.^(normrnd(0,lns,[K,K])/10);
    for k=0:K-1
        for i=0:K-1            
            stddv=SqrtVarpD*sqrt(L(k+1,i+1)*(200/dTxRx)^3);
            Jx=normrnd(Mean,stddv,M,M)+1j*normrnd(Mean,stddv,M,M);
            J(k*M+1:k*M+M,i*M+1:i*M+M)=Jx;
        end
    end
    dlmwrite(filename1,J,'-append','delimiter','\t','precision','%3.6f');
    
    L=10.^(normrnd(0,lns,[R,K])/10);
    for r=0:R-1
        for i=0:K-1           
            stddv=SqrtVarpD*sqrt(L(r+1,i+1)*(200/dTxR)^3);
            Hx=normrnd(Mean,stddv,N,M)+1j*normrnd(Mean,stddv,N,M);
            H(r*N+1:r*N+N,i*M+1:i*M+M)=Hx;
        end
    end
    dlmwrite(filename2,H,'-append','delimiter','\t','precision','%3.6f');
    
    L=10.^(normrnd(0,lns,[K,R])/10);
    for k=0:K-1
        for r=0:R-1            
            stddv=SqrtVarpD*sqrt(L(k+1,r+1)*(200/dRRx)^3);
            Gx=normrnd(Mean,stddv,M,N)+1j*normrnd(Mean,stddv,M,N);
            G(k*M+1:k*M+M,r*N+1:r*N+N)=Gx;
        end
    end
    dlmwrite(filename3,G,'-append','delimiter','\t','precision','%3.6f');
    
    U=normrnd(Mean,SqrtVarpD,M,B)+1j*normrnd(Mean,SqrtVarpD,M,B);
    for i=1:B
        U_norm(:,i)=U(:,i)/norm(U(:,i));
    end
    dlmwrite(filename4,U_norm,'-append','delimiter','\t','precision','%3.6f');
    F=normrnd(Mean,SqrtVarpD,R*N,N)+1j*normrnd(Mean,SqrtVarpD,R*N,N);
    dlmwrite(filename5,F,'-append','delimiter','\t','precision','%3.6f');
    V=normrnd(Mean,SqrtVarpD,2*M,B)+1j*normrnd(Mean,SqrtVarpD,2*M,B);
    for i=1:B
        V_norm(1:M,i)=V(1:M,i)*(sqrt(0.5)/norm(V(1:M,i)));
        V_norm(M+1:end,i)=V(M+1:end,i)*(sqrt(0.5)/norm(V(M+1:end,i)));
    end
    dlmwrite(filename6,V_norm,'-append','delimiter','\t','precision','%3.6f');
end
totaltime=secs2hms(toc(tgGlobal));
fprintf('Total time to generate the input files is %s.\n',totaltime)
destination=['./Inputs/MC' num2str(MonteCarlo) '/K' num2str(K) '/R' num2str(R)];
zip(Name,'*.tex');
delete('*.tex')
movefile('*.zip', destination), 
