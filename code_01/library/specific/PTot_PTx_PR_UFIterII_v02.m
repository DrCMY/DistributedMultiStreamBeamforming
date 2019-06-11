% PTot matrix stores the total power consumption of transmitters and relays per stream $\text{tr}\mathbf{X}_{k,l}\mathbf{R}_{.k}$ in (13a) written in terms of transmit filters
% PTx matrix stores the power consumption of transmitters per stream $\text{tr}\mathbf{X}_{k,l}$ 
function [PTot,PTx,PR]=PTot_PTx_PR_UFIterII_v02(K,R,M,N,d,Hpp,Xkl,Rdk,U,F,sigma2r)
PTot=zeros(K,d);            
PTx=zeros(K,d);  
PR=zeros(R,1);
for k=0:K-1
    rangekM=k*M+1:k*M+M;
    for l=1:d
        rangeklMx=k*d*M+(l-1)*M;
        rangeklM=rangeklMx+1:rangeklMx+M;
        Xklx=Xkl(:,rangeklM);
        PTot(k+1,l)=trace(Xklx*Rdk(rangekM,:));   
        PTx(k+1,l)=trace(Xklx);                  
    end
end
PTot=real(PTot);   
PTx=real(PTx); 

for r=0:R-1 
    rangerN=r*N+1:r*N+N; 
    FF=F(rangerN,:)'*F(rangerN,:);
    x=0;
    for k=0:K-1
        Hppx=Hpp(rangerN,k*M+1:k*M+M);
        Ux=U(:,k*d+1:k*d+d);
        x=x+trace((Ux'*Hppx')*(FF*Hppx*Ux));
    end
    PR(r+1)=real(x)+sigma2r*real(trace(FF));
end
PR=real(PR); 