% Updating the variables of transmit beamforming filters
% Updating the $\lambda_{k,l}$, $\zeta_{k,l}$, $\zeta^\backprime_{k,l}$, $\mu_{k,l}$, and $\mu^\backprime_{k,l}$ values
function [lambdavU,zetavU,zetanvU,muvU,munvU]=NewVarsU_v01(K,M,d,Rbkl,Xkl,sinrt,sigma2kl,lambdavU,zetavU,zetanvU,muvU,munvU,rho,rhocU)
for k=0:K-1
    rangekM=k*M+1:k*M+M;
    for l=1:d
        sumx=0;
        for j=0:K-1
            rangejM=j*M+1:j*M+M;
            for m=1:d
                rangejmMx=j*d*M+(m-1)*M;
                rangejmM=rangejmMx+1:rangejmMx+M;
                if j~=k || m~=l
                    rangeklMx=k*d*M+(l-1)*M;
                    rangeklM=rangeklMx+1:rangeklMx+M;
                    sumx=sumx+trace(Xkl(:,rangejmM)*Rbkl(rangeklM,rangejM));
                end
            end
        end
        zetavU(k+1,l)=-(lambdavU(k+1,l)+muvU(k+1,l))/rho-zetanvU(k+1,l);
        zetanvU(k+1,l)=-(lambdavU(k+1,l)+munvU(k+1,l))/rho-zetavU(k+1,l);
        lambdavU(k+1,l)=lambdavU(k+1,l)+rho*(zetavU(k+1,l)+zetanvU(k+1,l));
        rangeklMx=k*d*M+(l-1)*M;
        rangeklM=rangeklMx+1:rangeklMx+M;
        muvU(k+1,l)=muvU(k+1,l)+rhocU*(zetavU(k+1,l)-(1/sinrt(k+1))*trace(Xkl(:,rangeklM)*Rbkl(rangeklM,rangekM))+sigma2kl(k+1,l));
        munvU(k+1,l)=munvU(k+1,l)+rhocU*(zetanvU(k+1,l)+sumx);
    end
end
zetavU=real(zetavU);
zetanvU=real(zetanvU);
lambdavU=real(lambdavU);
muvU=real(muvU);
munvU=real(munvU);