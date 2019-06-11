function [Xkl,sinrx]=Xkl_sinrx_v02(K,R,M,N,B,d,J,Hpp,G,U,F,V,sigma2k1,sigma2k2,sigma2r)
sinrx=zeros(K,d);
Xkl=zeros(M,B*M);
for k=0:K-1                                              % For receiver k
    rangekM=k*M+1:k*M+M;
    for l=1:d
        pointkl=k*d+l;
        sumGFFG=zeros(M);
        for r=0:R-1
            rangerN=r*N+1:r*N+N;
            Gkr=G(rangekM,rangerN);
            Fr=F(rangerN,:);
            sumGFFG=sumGFFG+Gkr*(Fr*Fr')*Gkr';
        end
        CN=[sigma2k1*eye(M) zeros(M); zeros(M) sigma2r*sumGFFG+sigma2k2*eye(M)]; % Noise covariance matrix at receiver k
        IS=0;
        for i=0:K-1
            rangeiM=i*M+1:i*M+M;
            Hpki=zeros(M);
            for r=0:R-1 % number of relays in each cluster
                rangerN=r*N+1:r*N+N;
                Hpki=Hpki+G(rangekM,rangerN)*F(rangerN,:)*Hpp(rangerN,rangeiM);
            end
            Hki=[J(rangekM,rangeiM);Hpki];    % Compound channel from transmitter i to receiver k
            for n=1:d
                pointin=i*d+n;
                x=U(:,pointin)'*Hki'*(V(:,pointkl)*V(:,pointkl)')*Hki*U(:,pointin);
                if i~=k || n~=l
                    IS=IS+x;
                else
                    DS=x; % Covariance matrix of the desired signal
                end
            end
        end
        sinrx(k+1,l)=DS/(IS+real(V(:,pointkl)'*CN*V(:,pointkl))); % Desired signal/(Interference+Noise)
        rangeklMx=k*d*M+(l-1)*M;
        rangeklM=rangeklMx+1:rangeklMx+M;
        Xkl(:,rangeklM)=U(:,pointkl)*U(:,pointkl)';
    end
end
sinrx=real(sinrx);