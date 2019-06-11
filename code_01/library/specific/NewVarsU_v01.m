function [lambdavU,zetavU,zetanvU,muvU,munvU]=NewVarsU_v01(K,M,d,RbklM,XklM,sinrt,sigma2kl,lambdavU,zetavU,zetanvU,muvU,munvU,rho,rhocU)
%%
%%%%%%%%%%%%%%
% Obtaining the \zeta\xkl, \zeta^\backprime\xkl, \lambda\xkl, \mu\xkl, and \mu^\backprime\xkl values
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
                    sumx=sumx+trace(XklM(:,rangejmM)*RbklM(rangeklM,rangejM));
                end
            end
        end
        zetavU(k+1,l)=-(lambdavU(k+1,l)+muvU(k+1,l))/rho-zetanvU(k+1,l);
        zetanvU(k+1,l)=-(lambdavU(k+1,l)+munvU(k+1,l))/rho-zetavU(k+1,l);
        lambdavU(k+1,l)=lambdavU(k+1,l)+rho*(zetavU(k+1,l)+zetanvU(k+1,l));
        rangeklMx=k*d*M+(l-1)*M;
        rangeklM=rangeklMx+1:rangeklMx+M;
        muvU(k+1,l)=muvU(k+1,l)+rhocU*(zetavU(k+1,l)-(1/sinrt(k+1))*trace(XklM(:,rangeklM)*RbklM(rangeklM,rangekM))+sigma2kl(k+1,l));
        munvU(k+1,l)=munvU(k+1,l)+rhocU*(zetanvU(k+1,l)+sumx);
    end
end
zetavU=real(zetavU);
zetanvU=real(zetanvU);
lambdavU=real(lambdavU);
muvU=real(muvU);
munvU=real(munvU);
%%%%%%%%%%%%%%
%%