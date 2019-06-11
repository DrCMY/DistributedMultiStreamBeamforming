% This function a) generates random channels, b) transmit, relay, and receive beamforming vectors and saves them in separate text files
function [J,Hpp,G,U,F,V,V1,V2,loaders]=Channels_v01(K,R,M,N,B,d,loaders,PlTxRx,fi1,fi2,fi3,fi4,fi5,fi6)
KM=K*M;
RN=R*N;
TM=2*M;  % Relay network operates in two time slots. Therefore, there is a receive beamforming vector for each time slot of the communication.
V1=zeros(M,B);
V2=zeros(M,B);
J=dlmread(fi1,'\t',[loaders(1) 0 loaders(1)+KM-1 KM-1]);        % Channels between the transmitters and receivers. See \mathbf{J}_{ki} in (2)
Hpp=dlmread(fi2,'\t',[loaders(2) 0 loaders(2)+RN-1 KM-1]);     % Channels between the transmitters and relays. See \mathbf{H}^{\prime\prime}_{ri} in (2)
loaders(2)=loaders(2)+RN;
G=dlmread(fi3,'\t',[loaders(1) 0 loaders(1)+KM-1 RN-1]);        % Channels between the relays and receivers. See \mathbf{G}_{kr} in (2)
loaders(1)=loaders(1)+KM;
U=dlmread(fi4,'\t',[loaders(3) 0 loaders(3)+M-1 B-1]);          % Transmit beamforming vectors. See \mathbf{U}_i in (1)
loaders(3)=loaders(3)+M;
F=dlmread(fi5,'\t',[loaders(4) 0 loaders(4)+RN-1 N-1]);         % Relay beamforming matrices. See \mathbf{F}_r in (3)
loaders(4)=loaders(4)+RN;
V=dlmread(fi6,'\t',[loaders(5) 0 loaders(5)+TM-1 B-1]);         % Concatenated receive beamforming vectors of the two time slots. See \bar{\mathbf{V}}_k\in\mathbb{C}^{2M_k\times d_k} above (8)
for i=1:B  % Because independent decoding is done at the receiver.
    V1(:,i)=V(1:M,i);                                           % Receive beamforming vectors of the first time slot
    V2(:,i)=V(M+1:end,i);                                       % Receive beamforming vectors of the second time slot  
end
loaders(5)=loaders(5)+TM;

PldTxRx=PlTxRx/d;                                               % Maximum linear power value per stream (equal share among streams)
PDTxRx=diag(PldTxRx*ones(1,d));
for k=0:K-1
    U(:,k*d+1:k*d+d)=U(:,k*d+1:k*d+d)*sqrt(PDTxRx);             % Transmit beamforming vector powers are normalized to their maximum power values
end