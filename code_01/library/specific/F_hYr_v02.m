function [F,hYr]=F_hYr_v02(K,R,M,N,d,Hpp,U,F,PlRRx,sigma2r)
tc=(1+1i)/sqrt(2);
N2=N^2;
N2p1=N2+1; % Pay attention to "r*N2+1". Do not replace r*N2+1<-r*N2p1. They are not the same!
hYr=zeros(R*N2p1,N2p1);
%%%%%%%%%%%%%%
% Setting the relay power
for r=0:R-1 % Number of relays in each cluster
    rangerN=r*N+1:r*N+N; % Relay index
    rangerN2p1=r*N2p1+1:r*N2p1+N2p1;    
    FF=F(rangerN,:)'*F(rangerN,:);
    x=0;
    for k=0:K-1
        Hppx=Hpp(rangerN,k*M+1:k*M+M);
        Ux=U(:,k*d+1:k*d+d);
        x=x+trace((Ux'*Hppx')*(FF*Hppx*Ux));
    end
    x=real(x);
    pR=x+sigma2r*real(trace(FF));
    F(rangerN,:)=F(rangerN,:)*sqrt(PlRRx/pR); % Relay transmit power is set to PlRRx. Test by running lines between (inclusive) rangerN=... and pR=... again.
    bvF=[vec(F(rangerN,:));tc];
    hYr(rangerN2p1,:)=bvF*bvF';
end