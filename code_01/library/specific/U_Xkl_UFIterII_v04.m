% U matrix stores the transmit beamforming vectors. See $\mathbf{U}_{i}$ in (1)
% XklM (XklMopt) matrix stores the (optimum) covariance matrices of transmit beamforming vectors. See $\mathbf{X}_{k,l}$ in (13a). 
function [U,Xkl]=U_Xkl_UFIterII_v04(K,M,d,Rdk,Rbkl,sinrt,sigma2kl,U,Uopt,Xkl,Xklopt,zetavU,stepi,Delta,PDelta,PlTxRx)
for k=0:K-1
    rangekM=k*M+1:k*M+M;
    Rdkx=Rdk(rangekM,:);
    for l=1:d
        rangeklMx=k*d*M+(l-1)*M;
        rangeklM=rangeklMx+1:rangeklMx+M;
        cvx_begin quiet
        variable Xklx(M,M) hermitian
        minimize(real(trace(Rdkx*Xklx)));   % Objective function, written in terms of transmit filters, is the minimization of total power consumption of transmitters and relays
        subject to        
        real(trace(Rbkl(rangeklM,k*M+1:k*M+M)*Xklx))-real(sinrt(k+1)*(zetavU(k+1,l)+sigma2kl(k+1,l)))>=0; % SINR constraint in (18c)
        real(trace(Xklx))>Delta;     % Positive power value constraint
        real(trace(Xklx))<=PlTxRx;   % Maximum power constraint        
        Xklx==hermitian_semidefinite(M);
        cvx_end
        PTx=real(trace(Xklx));
        condition=(sum(sum(Xklx))<Delta || sum(sum(isnan(Xklx)))>0 || PTx<PDelta || PTx>PlTxRx);
        if condition && stepi>1         % If near zero or NAN values are obtained after the first iteration, last optimum values are assigned
            Xkl(:,rangeklM)=Xklopt(:,rangeklM);
            U(:,k*d+l)=Uopt(:,k*d+l);
        elseif condition && stepi==1    % If near zero or NAN values are obtained at the first iteration, initial values are assigned
            % Do not update any variables
        else
            Xkl(:,rangeklM)=Xklx;
            [Ux,Sigma]=eig(Xklx);
            [xx,yy]=max(diag(Sigma));
            U(:,k*d+l)=Ux(:,yy)*sqrt(xx);
        end      
    end
end