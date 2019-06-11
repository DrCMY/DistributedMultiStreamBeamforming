function sinrx=sinrxNew_v01(K,M,d,Rbkl,Xkl,sigma2kl)
sinrx=zeros(K,d);
%%
% SINR evaluation
%sinrMax=0;
for k=0:K-1
    for l=1:d
        rangeklMx=k*d*M+(l-1)*M;
        rangeklM=rangeklMx+1:rangeklMx+M;
        IS=0;
        for i=0:K-1
            rangeiM=i*M+1:i*M+M;
            for n=1:d
                rangeinMx=i*d*M+(n-1)*M;
                rangeinM=rangeinMx+1:rangeinMx+M;
                x=trace(Rbkl(rangeklM,rangeiM)*Xkl(:,rangeinM));
                if i~=k || n~=l
                    IS=IS+x;
                else
                    DS=x;
                end
            end
        end
        IS=IS+sigma2kl(k+1,l);
        sinrx(k+1,l)=DS/IS;
    end
end
sinrx=real(sinrx);