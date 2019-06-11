% DrklM matrix stores the $\mathbf{D}_{rkl}$ matrices. See the second equality in (44)
function Drkl=Drkl_v02(K,R,M,N,B,d,Hpp,U,F,sigma2r)
Pr=zeros(R,1);
Drkl=zeros(R*N,B*N);
for r=0:R-1 
    rangerN=r*N+1:r*N+N; 
    FF=F(rangerN,:)'*F(rangerN,:);
    x=0;
    for k=0:K-1
        Hppx=Hpp(rangerN,k*M+1:k*M+M);
        Ux=U(:,k*d+1:k*d+d);
        x=x+trace((Ux'*Hppx')*(FF*Hppx*Ux));
        for l=1:d
            rangeklNx=k*d*N+(l-1)*N;
            rangeklN=rangeklNx+1:rangeklNx+N;
            Drkl(rangerN,rangeklN)=Hppx*(Ux*Ux')*Hppx';
        end
    end
    Pr(r+1)=real(x)+sigma2r*real(trace(FF));
end