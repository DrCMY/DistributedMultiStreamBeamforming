% RdkM matrix stores the $\mathbf{R}_{.k}$ matrices in (13a)
% RbklM matrix stores the $\mathbf{R}_{k,l}^i$ matrices in (13b). RbklM matrix stores both the desired $\mathbf{R}_{k,l}^k$ and interference $\mathbf{R}_{k,l}^j$
% terms
% sigma2kl is the noise vector. See $\sigma_{n_{k,l}}^2$ two lines above (9)
function [Rdk,Rbkl,sigma2kl]=Rdk_Rbkl_sigma2kl_UFIterII_v02(K,R,M,N,B,d,J,Hpp,G,F,V,sigma2k1,sigma2k2,sigma2r)
hc=2;                   % The number of hop counts. Varying the hc parameter doesn't indicate this code will work. However, it indicates that the matrix structures are due to the 2-hop network.
HkiM=zeros(hc*K*M,K*M); % Aggregate compound channel from transmitter i to receiver k. See $\mathbf{H}_{ki}$ in (6)
Rdk=zeros(K*M,M);
Rbkl=zeros(B*M,K*M);
sigma2kl=zeros(K,d);
for k=0:K-1                                              % For receiver k
    rangekM=k*M+1:k*M+M;
    rangekK=hc*k*M+1:hc*(k*M+M);                           % Equivalent to k*hc*M+1:k*hc*M+hc*M;
    sumGFFG=zeros(M);
    for r=0:R-1
        rangerN=r*N+1:r*N+N;
        Gkr=G(rangekM,rangerN);
        Fr=F(rangerN,:);
        sumGFFG=sumGFFG+Gkr*(Fr*Fr')*Gkr';
        Hpprk=Hpp(rangerN,rangekM);
        Rdk(rangekM,:)=Rdk(rangekM,:)+Hpprk'*(Fr'*Fr)*Hpprk;
    end
    Rdk(rangekM,:)=Rdk(rangekM,:)+eye(M);
    
    CN=[sigma2k1*eye(M) zeros(M); zeros(M) sigma2r*sumGFFG+sigma2k2*eye(M)];         % Noise covariance matrix at receiver k. See \mathbf{R}_{n_k} in (9)
    for l=1:d
        pointkl=k*d+l;
        for i=0:K-1
            rangei=i*M+1:i*M+M;
            Hpki=zeros(M);
            for r=0:R-1 % number of relays in each cluster
                rangerN=r*N+1:r*N+N;
                Hpki=Hpki+G(rangekM,rangerN)*F(rangerN,:)*Hpp(rangerN,rangei);
            end
            Hki=[J(rangekM,rangei);Hpki];    % Compound channel from transmitter i to receiver k
            HkiM(rangekK,rangei)=Hki;
        end
        sigma2kl(k+1,l)=real(V(:,pointkl)'*CN*V(:,pointkl));
    end
end

for k=0:K-1
    rangekM=k*M+1:k*M+M;
    rangekK=hc*k*M+1:hc*(k*M+M);
    for l=1:d
        pointkl=k*d+l;
        rangeklMx=k*d*M+(l-1)*M;
        rangeklM=rangeklMx+1:rangeklMx+M;
        Rbkl(rangeklM,rangekM)=HkiM(rangekK,rangekM)'*(V(:,pointkl)*V(:,pointkl)')*HkiM(rangekK,rangekM); % This is the \mathbf{R}_{k,l}^k matrix in (13b)
        for j=0:K-1
            if j~=k
                rangejM=j*M+1:j*M+M;
                Rbkl(rangeklM,rangejM)=HkiM(rangekK,rangejM)'*(V(:,pointkl)*V(:,pointkl)')*HkiM(rangekK,rangejM); % This is the \mathbf{R}_{k,l}^j matrix in (13b)
            end
        end
    end
end