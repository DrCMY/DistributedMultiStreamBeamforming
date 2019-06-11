% tCklrin matrix stores the $\tilde{\mathbf{C}}_{klrin}$ matrixes in (43). See Appendix B of the IEEE Access paper. tCklrin matrix stores both the desired $\tilde{C}_{klrkl}$ and interference $\tilde{C}_{klrjm}$ terms 
% Cklrin matrix stores the $\mathbf{C}_{klrin}$ matrixes in (58). See Appendix B of the IEEE Access paper. 
function tCklrin=tCklrin_v01(K,R,M,N,B,d,J,Hpp,G,U,F,V1,V2,sigma2k1,sigma2k2,sigma2r,N2,N2p1)
tCklrin=zeros(R*N2p1,2*B*N2p1);
Cklrkl=zeros(R*N2,N2);
%%%%%%%%%%%%%%
% Obtaining tCklrin matrix
for k=0:K-1                                              % For receiver k
    rangekM=k*M+1:k*M+M;
    sumGFFG=zeros(M);
    for r=0:R-1
        rangerN=r*N+1:r*N+N;
        Gkr=G(rangekM,rangerN);
        Fr=F(rangerN,:);
        sumGFFG=sumGFFG+Gkr*(Fr*Fr')*Gkr';
    end
    for l=1:d
        rangekl2N2p1x=k*d*2*N2p1+(l-1)*2*N2p1;
        rangekl2N2p1=rangekl2N2p1x+1:rangekl2N2p1x+N2p1;
        pointkl=k*d+l;
        bCklrjm=zeros(R*N2,N2);
        bdklrjm=zeros(N2,R);
        dklrkl=zeros(N2,R);
        absrklskl2=zeros(R,1);
        r2klrjm=zeros(R,1);
        Oklrx=zeros(N^2);
        tzetakljm=0;
        for i=0:K-1
            rangeiM=i*M+1:i*M+M;
            sumGFH=zeros(M);
            for r=0:R-1
                rangerN=r*N+1:r*N+N;
                sumGFH=sumGFH+G(rangekM,rangerN)*F(rangerN,:)*Hpp(rangerN,rangeiM); %Gkr=G(rangekM,rangerN); Fr=F(rangerN,:);
            end
            for n=1:d
                pointin=i*d+n;
                x=V2(:,pointkl)'*sumGFH*U(:,pointin); %abs(x)^2 % test
                for r=0:R-1
                    rangerN=r*N+1:r*N+N;
                    rangerN2=r*N2+1:r*N2+N2;
                    Gkr=G(rangekM,rangerN);
                    vF=vec(F(rangerN,:));
                    Hppri=Hpp(rangerN,rangeiM);
                    cklrin=kron(Hppri*U(:,pointin),conj(Gkr'*V2(:,pointkl)));
                    rklsin=x-vF.'*cklrin;
                    Cklrin=conj(cklrin)*cklrin.';
                    dklrin=rklsin*conj(cklrin);
                    if i~=k || n~=l
                        bCklrjm(rangerN2,:)=bCklrjm(rangerN2,:)+Cklrin;
                        bdklrjm(:,r+1)=bdklrjm(:,r+1)+dklrin;
                        r2klrjm(r+1)=r2klrjm(r+1)+abs(rklsin)^2;
                    else
                        Cklrkl(rangerN2,:)=Cklrin;
                        dklrkl(:,r+1)=dklrin;
                        absrklskl2(r+1)=abs(rklsin)^2;
                    end
                end
                x=V1(:,pointkl)'*J(rangekM,rangeiM)*(U(:,pointin)*U(:,pointin)')*J(rangekM,rangeiM)'*V1(:,pointkl);
                if i~=k || n~=l
                    tzetakljm=tzetakljm+x;
                else
                    tzetaklkl=x;
                end
            end
        end
        noisex=sigma2k1*V1(:,pointkl)'*V1(:,pointkl)+sigma2k2*V2(:,pointkl)'*V2(:,pointkl);
        for r=0:R-1
            rangerN=r*N+1:r*N+N;
            rangerN2=r*N2+1:r*N2+N2;
            rangerN2p1=r*N2p1+1:r*N2p1+N2p1;
            Gkr=G(rangekM,rangerN);
            caklr=conj(Gkr'*V2(:,pointkl));
            vF=vec(F(rangerN,:));
            for nr=1:N
                en=zeros(N,1);
                en(nr)=1;
                oklrn=kron(en,caklr);
                Oklrx=Oklrx+conj(oklrn)*oklrn.';
            end
            tkls=V2(:,pointkl)'*sumGFFG*V2(:,pointkl)-vF'*Oklrx*vF;
            Oklr=sigma2r*Oklrx;
            bCklrjm(rangerN2,:)=bCklrjm(rangerN2,:)+Oklr; %test
            r1klrkl=tzetaklkl+absrklskl2(r+1);
            r2klrjm(r+1)=r2klrjm(r+1)+tzetakljm+sigma2r*tkls+noisex;
            tCklrin(rangerN2p1,rangekl2N2p1)=[Cklrkl(rangerN2,:) dklrkl(:,r+1); dklrkl(:,r+1)' r1klrkl]; % desired
            tCklrin(rangerN2p1,rangekl2N2p1+N2p1)=[bCklrjm(rangerN2,:) bdklrjm(:,r+1); bdklrjm(:,r+1)' r2klrjm(r+1)]; % interference
        end
    end
end