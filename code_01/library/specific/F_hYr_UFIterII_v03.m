function [F,hYr]=F_hYr_UFIterII_v03(K,N,d,R,sinrt,sigma2r,N2,N2p1,DrklM,tCklrin,zetavF,zetanvF,PlRRx,Delta,PDelta,iter,F,Fopt,hYr,hYropt) 
Gamma=zeros(N2p1);
Gamma(N2p1,N2p1)=1;
for r=0:R-1
    rangerN=r*N+1:r*N+N;
    rangerN2p1=r*N2p1+1:r*N2p1+N2p1;
    SumDrklp=zeros(N);
    for k=0:K-1
        for l=1:d
            rangeklN=k*d*N+(l-1)*N+1:k*d*N+(l-1)*N+N;
            SumDrklp=SumDrklp+DrklM(rangerN,rangeklN);
        end
    end
    SumDrklp=kron((SumDrklp+sigma2r*eye(N)).',eye(N));
    bSumDrklp=[SumDrklp zeros(N2,1); zeros(1,N2p1)];
    
    cvx_begin quiet
    variable hYrx(N2p1,N2p1) hermitian
    minimize(real(trace(hYrx*bSumDrklp))); % Objective function, written in terms of relay filters, is the minimization of total power consumption of transmitters and relays
    subject to
    for k=0:K-1
        for l=1:d
            pointkl=k*d+l;
            rangekl2N2p1x=k*d*2*N2p1+(l-1)*2*N2p1;
            rangekl2N2p1=rangekl2N2p1x+1:rangekl2N2p1x+N2p1;
            real(trace(tCklrin(rangerN2p1,rangekl2N2p1)*hYrx))-sinrt(k+1)*zetavF(r+1,pointkl)>=0;  % SINR constraint in (46c)
            real(trace(tCklrin(rangerN2p1,rangekl2N2p1+N2p1)*hYrx))+zetanvF(r+1,pointkl)>=0;       % SINR constraint in (46d)         
        end
    end
    trace(Gamma*hYrx)==1;
    real(trace(hYrx*bSumDrklp))>Delta;     % Positive power value constraint
    real(trace(hYrx*bSumDrklp))<=PlRRx;    % Maximum power constraint
    hYrx==hermitian_semidefinite(N2p1);
    cvx_end    
    PR=real(trace(hYrx*bSumDrklp));
    condition=(sum(sum(abs(hYrx)<Delta))>N2p1*N2p1-10 || sum(sum(isnan(hYrx)))>0 || issparse(hYrx) || PR<PDelta || PR>PlRRx);
    if condition && iter>1        % If near zero or NAN values are obtained after the first iteration, last optimum values are assigned
        hYr(rangerN2p1,:)=hYropt(rangerN2p1,:);        
        F(rangerN,:)=Fopt(rangerN,:);
    elseif condition && iter==1   % If near zero or NAN values are obtained at the first iteration, initial values are assigned
        % Do not update any variables
    else
        hYr(rangerN2p1,:)=hYrx;
        [Uu,Sigma]=eig(hYrx);
        [xx,yy]=max(diag(Sigma));
        f=sqrt(xx)*Uu(:,yy);     
        F(rangerN,:)=reshape(f(1:end-1)/f(end),N,N); 
    end
end


