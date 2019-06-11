function [Deltax,iter,counter,checkwhilei,missed,fault,DeltaLogs,AverageDeltaLogs]=Delta_Logging_v01(K,sinr,sinrt,Delta,DeltaLogs,AverageDeltaLogs,counter,iter,steprange,missed,fault,faultlimit,iterlimit,wmin,mc,fido6,fido11)
Deltaxx=mean(abs(bsxfun(@minus,sinr,sinrt)),2); % Evaluating the average deviation of each user’s streams from the SINR targets
checkwhilei= Deltaxx<=Delta;                     % checkwhile(k)=1 is set if the average deviation of kth user’s streams is less than a threshold                     
Deltax=sum(Deltaxx)/K;                           % If smaller average of deltas is obtained in this iteration, the optimum beamforming vectors are updated
DeltaLogs(iter)=Deltax;                            % Logging Deltax value of each iteration

c=find(iter==steprange); % fault monitoring window
if c~=0                   % Checking whether the step number is within the fault monitoring window
    AverageDeltaLogs(counter)=mean(DeltaLogs(1,wmin:iter));       % Checking whether algorithm is oscillating
    if AverageDeltaLogs(counter)>=AverageDeltaLogs(counter-1) || (DeltaLogs(iter)-DeltaLogs(1))>0
        fault=fault+1;
    end
    if fault==faultlimit                                    % If the number of oscillations reach to maximum, the channel is declared to be non-converging
        fprintf(fido6,'%d\n',mc);
        fprintf(fido6,'%6.4f\t',sinrt'); fprintf(fido6,'\n');
        fprintf(fido6,'%6.4f\t',sinr'); fprintf(fido6,'\n');
        fprintf(fido6,'%2.4f\t',DeltaLogs(1:iter-1)); fprintf(fido6,'\n');
        fprintf(fido6,'%d\n',iter);
        iter=iterlimit;
        missed(2)=missed(2)+1;
        fprintf(fido11,'%s ',"n"); fprintf(fido11,'\n'); % non-converging (can be due to fluctuation or infeasibility)
    end
    counter=counter+1;
end