% Updating the variables of relay beamforming filters
% Updating the $\dot{\lambda}_r^{k,l}$, $\dot{\zeta}_r^{k,l}$, $\dot{\zeta}_r^{k,l\backprime}$, $\dot{\mu}_r^{k,l}$, and $\dot{\mu}_r^{k,l\backprime}$ values
function [lambdavF,zetavF,zetanvF,muvF,munvF,zetavU,zetanvU,muvU,munvU]=NewVarsF_UFIterII_v01(K,R,d,tCklrin,hYrM,sinrt,rhoF,rhocF,lambdavF,zetavF,zetanvF,muvF,munvF,zetavU,zetanvU,muvU,munvU,zetavpF,zetanvpF,N2p1)
for r=0:R-1
    rangerN2p1=r*N2p1+1:r*N2p1+N2p1;
    for k=0:K-1
        for l=1:d
            pointkl=k*d+l;
            rangekl2N2p1x=k*d*2*N2p1+(l-1)*2*N2p1;
            rangekl2N2p1=rangekl2N2p1x+1:rangekl2N2p1x+N2p1;
            zetavF(r+1,pointkl)=-(lambdavF(r+1,pointkl)+muvF(r+1,pointkl))/rhoF-zetanvF(r+1,pointkl);
            zetanvF(r+1,pointkl)=-(lambdavF(r+1,pointkl)+munvF(r+1,pointkl))/rhoF-zetavF(r+1,pointkl);
            lambdavF(r+1,pointkl)=lambdavF(r+1,pointkl)+rhoF*(zetavF(r+1,pointkl)+zetanvF(r+1,pointkl));
            muvF(r+1,pointkl)=muvF(r+1,pointkl)+rhocF*(zetavF(r+1,pointkl)-(1/sinrt(k+1))*trace(hYrM(rangerN2p1,:)*tCklrin(rangerN2p1,rangekl2N2p1)));
            munvF(r+1,pointkl)=munvF(r+1,pointkl)+rhocF*(zetanvF(r+1,pointkl)+trace(hYrM(rangerN2p1,:)*tCklrin(rangerN2p1,rangekl2N2p1+N2p1)));
        end
    end
end
zetavF=real(zetavF);
zetanvF=real(zetanvF);

[x,y]=find(zetavF<1e-6); % If the signs of the variables (+-) are wrong, the last correct values are assigned
lx=length(x);
for c=1:lx
    zetavF(x(c),y(c))=zetavpF(x(c),y(c));
end

[x,y]=find(zetanvF>1e-6); % If the signs of the variables (+-) are wrong, the last correct values are assigned
lx=length(x);
for c=1:lx
    zetanvF(x(c),y(c))=zetanvpF(x(c),y(c));
end

lambdavF=real(lambdavF);
muvF=real(muvF);
munvF=real(munvF); 