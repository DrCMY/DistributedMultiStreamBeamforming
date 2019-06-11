function [sinr_MC,P_MC,missed,iter_Logger,iter_MC]=Logging_v03(K,R,B,PTot,PTx,PR,P_MC,PLinTxRx,PLinRRx,sinr_MC,sinrt,sinr,checkwhilei,iter,iter_MC,PDelta,DeltaLogs,missed,mc,fault,faultlimit,iter_Logger,fido1,fido2,fido4,fido5,fido7,fido11,fido14)
sc=sum(checkwhilei)==K; 
sPt=sum(PTx,2);
spUa=sPt<=PLinTxRx;
spUb=PDelta<sPt;
spU=sum(spUa&spUb)==K;
spFa=PR<=PLinRRx;
spFb=PDelta<PR;
spF=sum(spFa&spFb)==R;
iterm1=iter-1;
mcmmissed1=mc-missed(1);
if sc==1 
    if spF==1 && spU==1
        sinr_MC=sinr_MC+sinr;
        fprintf(fido2,'%6.4f\t',sinrt'); fprintf(fido2,'\n');
        fprintf(fido2,'%6.4f\t',sinr'); fprintf(fido2,'\n');
        PMx=sum(sum(PTot));
        P_MC=P_MC+reshape(PTot',B,1);         % Power matrix that stores the power of each stream
        iter_MC=iter_MC+iterm1;
        fprintf(fido1,'mc= %2d\n',mcmmissed1);
        fprintf(fido1,'iter = '); fprintf(fido1,'%2.2f,\t',iterm1);
        fprintf(fido1,'iter average= '); fprintf(fido1,'%2.2f\t',iter_MC/(mcmmissed1)); fprintf(fido1,'\n');
        fprintf(fido1,'Sum power= '); fprintf(fido1,'%6.4f,\t',PMx);
        fprintf(fido1,'Sum power average= '); fprintf(fido1,'%6.4f\t',sum(P_MC)/(mcmmissed1)); fprintf(fido1,'\n');
        fprintf(fido2,'%6.4f\t',PMx); fprintf(fido2,'\n');
        fprintf(fido2,'%d\n',iterm1);
        fprintf(fido11,'%s ',"s"); fprintf(fido11,'\n'); % success
        iter_Logger(mcmmissed1)=iterm1;
    elseif spF~=1
        fprintf(fido4,'%d ', mc); fprintf(fido4,'\n');
        fprintf(fido11,'%s ',"F"); fprintf(fido11,'\n'); % relay power violation
        fprintf(fido14,'%d\n',mc);
        fprintf(fido14,'%s ',"F"); fprintf(fido14,'\n'); % relay power violation
        fprintf(fido14,'%d\t',spFa'); fprintf(fido14,'Upper bounds\n');
        fprintf(fido14,'%d\t',spFb'); fprintf(fido14,'Lower bounds\n');
        fprintf(fido14,'%6.4f\t',sinrt'); fprintf(fido14,'\n');
        fprintf(fido14,'%6.4f\t',PTx'); fprintf(fido14,'\n');
        fprintf(fido14,'%6.4f\t',PR'); fprintf(fido14,'\n');
        fprintf(fido14,'%d\n',iter);
        missed(1)=missed(1)+1;
        missed(4)=missed(4)+1;
    elseif spU~=1
        fprintf(fido4,'%d ', mc); fprintf(fido4,'\n');
        fprintf(fido11,'%s ',"U"); fprintf(fido11,'\n'); % transmit power violation
        fprintf(fido14,'%d\n',mc);
        fprintf(fido14,'%s ',"U"); fprintf(fido14,'\n'); % transmit power violation
        fprintf(fido14,'%d\t',spUa'); fprintf(fido14,'Upper bounds\n');
        fprintf(fido14,'%d\t',spUb'); fprintf(fido14,'Lower bounds\n');
        fprintf(fido14,'%6.4f\t',sinrt'); fprintf(fido14,'\n');
        fprintf(fido14,'%6.4f\t',PTx'); fprintf(fido14,'\n');
        fprintf(fido14,'%6.4f\t',PR'); fprintf(fido14,'\n');
        fprintf(fido14,'%d\n',iter);
        missed(1)=missed(1)+1;
        missed(5)=missed(5)+1;
    end
else
    fprintf(fido4,'%d ', mc); fprintf(fido4,'\n');
    missed(1)=missed(1)+1;
    if fault~=faultlimit
        fprintf(fido7,'%d\n', mc);
        fprintf(fido7,'%6.4f\t',sinrt'); fprintf(fido7,'\n');
        fprintf(fido7,'%6.4f\t',sinr'); fprintf(fido7,'\n');
        fprintf(fido7,'%2.4f\t',DeltaLogs(1:iterm1)); fprintf(fido7,'\n');
        missed(3)=missed(3)+1;
        fprintf(fido11,'%s ',"l"); fprintf(fido11,'\n'); % slow-convergence
    end
end
fprintf(fido5,'%6.4f\t',sinrt'); fprintf(fido5,'\n');
fprintf(fido5,'%6.4f\t',sinr'); fprintf(fido5,'\n');
fprintf(fido5,'%6.4f\n',sum(sum(PTot)));
fprintf(fido5,'%d\n',iterm1);