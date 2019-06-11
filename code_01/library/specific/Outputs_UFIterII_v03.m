function Outputs_UFIterII_v03(MonteCarlo,MonteCarloT,K,M,N,d,R,B,PdBTxRx,PdBRRx,LPPdB,Name,sinr_MC,P_MC,fido1,fido3,cverSubFile_a,cverSubFile_b,Delta,PDelta,iterlimit,rhoF,rhocF,rhoU,rhocU,faultlimit,wmin,wstep,wmax,iter_MC,missed,tgGlobal,InputFolder,sinrt,datetime,maxofiters)
%%
ucolor=['b' 'g' 'r' 'm' 'c' 'k' 'y' 'b' 'g' 'r' 'b' 'g' 'r' 'm' 'c' 'b' 'g' 'r' 'm' 'c' 'b' 'g' 'r' 'm' 'c'];                       % User colors for plotting
ucolor=[ucolor ucolor];
ssyms=['.' 'o' 'x' 'd' '*' 's' '>' '<' 'p' '^' 'h' 'v' '.' 'o' 'x' 'd' '*' 's' '>' '<' '.' 'o' 'x' 'd' '*' 's' '>' '<' 'p' '^' '.' 'o' 'x' 'd' '*' 's' '>' '<' 'p' '^' '.' 'o' 'x' 'd' '*' 's' '>' '<' 'p' '^'];    % Stream symbols for plotting
ssyms=[ssyms ssyms];
xlabeltag=sprintf('SNR');
titletag=sprintf([' (K=' int2str(K) ', M=' int2str(M) ', N=' int2str(N) ', and B=' int2str(B) ')']);

%%
% sum-x plotting

%%%%
% sum-SINR plotting 
sumsinrM=zeros(1,LPPdB);
for iter=1:LPPdB
    sumsinrM(iter)=sumsinrM(iter)+sum(sum(sinr_MC(:,(iter-1)*d+1:(iter-1)*d+d)));
end
figure
hold
y=real(sumsinrM)/MonteCarloT;
plot(PdBTxRx, y,'bp--');
str=cell(LPPdB,1);
for iter=1:LPPdB
    str{iter}=num2str(y(iter), '%1.3f');
end
text(PdBTxRx,y,str);
grid
title(titletag)
xlabel(xlabeltag)
set(gca,'XTick',PdBTxRx);
ylabel('Sum-SINR')
figname=sprintf([Name '_SumSINR_' cverSubFile_b '.fig']);
saveas(gcf,figname)
fprintf(fido3,'%6.4f\t',y); fprintf(fido3,'\n');

%%%%
% sum-power plotting 
PMt=sum(P_MC./MonteCarloT,1);                    % Total power consumption matrix for all SNRs   
figure,hold
plot(PdBTxRx,PMt,[ucolor(2) ssyms(2) '--'])
for iter=1:LPPdB
    str{iter}=num2str(PMt(iter), '%5.2f');
end
text(PdBTxRx,PMt,str);
grid
title(titletag)
xlabel(xlabeltag)
set(gca,'XTick',PdBTxRx);
ylabel('Total power')
figname=sprintf([Name '_TotalPower_' cverSubFile_b '.fig']);
saveas(gcf,figname)
fprintf(fido3,'%6.4f\t',PMt); fprintf(fido3,'\n');

%%
% Detailed plotting

%%%%
% SINR achieved per stream
figure,hold
for k=1:K
    for l=1:d
        plot(PdBTxRx,(reshape(sinr_MC(k,l:d:d*LPPdB),[1 LPPdB])./MonteCarloT),[ucolor(k) ssyms((k-1)*d+l) '--']);
    end
end
FI=zeros(1,LPPdB); % Fairness index
sinrMa=sinr_MC./MonteCarloT;
for iter=1:LPPdB
    FI(iter)=sum(abs(sinrMa(:,(iter-1)*d+1)-sinrMa(:,(iter-1)*d+2)))/sum((sinrMa(:,(iter-1)*d+1)+sinrMa(:,(iter-1)*d+2))/2)*100;
    str{iter}=num2str(FI(iter), '%2.2f');
end
strx=['Fairness Index= ',num2str(FI, '%2.2f%% ')];
text(.35,.85,strx,'units','normalized');
stry = ['Average Fairness Index= ',num2str(mean(FI), '%2.2f'), '%'];
text(.35,.75,stry,'units','normalized');

grid
title(titletag)
xlabel(xlabeltag)
set(gca,'XTick',PdBTxRx);
ylabel('SINR per stream')
legend('User-1, stream-1', 'User-1, stream-2', 'User-2, stream-1', 'User-2, stream-2', 'User-3, stream-1', 'User-3, stream-2', 'Location','NorthWest')
figname=sprintf([Name '_SINRperStream_' cverSubFile_b '.fig']);
saveas(gcf,figname)

%% Output files
fprintf(fido1,'Total Run Time= %s',secs2hms(toc(tgGlobal)));
[~,computername] = system('hostname');     % Computer name
computername=strtrim(computername);
fprintf(fido1,'Computer name is %s\n',computername);

fprintf(fido3,'%2.2f\t',FI); fprintf(fido3,'\n');
fprintf(fido3,'%d\n',MonteCarloT);
fprintf(fido3,'%6.4f\t',sinrt'); fprintf(fido3,'\n');
fprintf(fido3,'%6.4f\t',sinrMa'); fprintf(fido3,'\n');
fprintf(fido3,'%6.4f\t',(P_MC./MonteCarloT)'); fprintf(fido3,'\n');

Outputfilename=[Name '_' cverSubFile_b '.zip'];
Outputfolder=['\Results\MC' num2str(MonteCarlo) '_MCT' num2str(MonteCarloT) '\' cverSubFile_a '\' cverSubFile_b];
Outputfile=[pwd Outputfolder '\' Outputfilename];
fclose('all');
closexlsxfiles  % Closing all excel files

%%%%
% Writing the header row in the excel file
[excelfile1,excelfile2]=OutputExcelFiles_v02;
Sheet=['MC' num2str(MonteCarlo) 'MCT' num2str(MonteCarloT)];
Row1={'K','M', 'N', 'R',['Total #' newline 'of Ant.'],'Network', 'Tx dB', 'R dB','Tx-R dB','Alg.', ['Power' newline '(dB)'],['Power' newline '(dBm)'],['Av. Iter.' newline '(rounded)'],'Av. Iter.','Max. of Iters.','SINR',['SINR' newline '(dBm)'],['Total' newline 'Missed'],'Slow-Conv.','Non-Conv.','U Viol.', 'F Viol.',['Data Input' newline 'Location'],['Data Output' newline 'Location'],'Total Time'};
xlswrite(excelfile1,Row1,Sheet,'A1');

%%%%
% Writing the properties column in the excel file
Alphabet='ABCDEFGHIJKLMNOPQRSTUVWXYZ';
AlphabetL='AAABACADAEAFAGAHAIAJAKALAMANAO'; % end-1: Until where data is written. end: Where you want Delta, iterlimit, etc. be written.
lrow1=length(Row1);
if lrow1<26 % There are 26 characters in the English alphabet
    xlswrite(excelfile1,{'Delta',Delta},Sheet,[Alphabet(lrow1) '1']),
    xlswrite(excelfile1,{'PDelta',PDelta},Sheet,[Alphabet(lrow1) '2']),
    xlswrite(excelfile1,{'iterlimit',iterlimit},Sheet,[Alphabet(lrow1) '3']),
    xlswrite(excelfile1,{'rhoF',rhoF},Sheet,[Alphabet(lrow1) '4']),
    xlswrite(excelfile1,{'rhocF',rhocF},Sheet,[Alphabet(lrow1) '5']),
    xlswrite(excelfile1,{'rhoU',rhoU},Sheet,[Alphabet(lrow1) '6']),
    xlswrite(excelfile1,{'rhocU',rhocU},Sheet,[Alphabet(lrow1) '7']),
    xlswrite(excelfile1,{'faultlimit',faultlimit},Sheet,[Alphabet(lrow1) '8']),
    xlswrite(excelfile1,{'wmin',wmin},Sheet,[Alphabet(lrow1) '9']),
    xlswrite(excelfile1,{'wstep',wstep},Sheet,[Alphabet(lrow1) '10']),
    xlswrite(excelfile1,{'wmax',wmax},Sheet,[Alphabet(lrow1) '11']),    
else
    lrow1b=lrow1+1-26;
    rangel=(lrow1b-1)*2+1:(lrow1b-1)*2+2;
    xlswrite(excelfile1,{'Delta',Delta},Sheet,[AlphabetL(rangel) '1']),
    xlswrite(excelfile1,{'PDelta',PDelta},Sheet,[AlphabetL(rangel) '2']),
    xlswrite(excelfile1,{'iterlimit',iterlimit},Sheet,[AlphabetL(rangel) '3']),
    xlswrite(excelfile1,{'rhoF',rhoF},Sheet,[AlphabetL(rangel) '4']),
    xlswrite(excelfile1,{'rhocF',rhocF},Sheet,[AlphabetL(rangel) '5']),
    xlswrite(excelfile1,{'rhoU',rhoU},Sheet,[AlphabetL(rangel) '6']),
    xlswrite(excelfile1,{'rhocU',rhocU},Sheet,[AlphabetL(rangel) '7']),
    xlswrite(excelfile1,{'faultlimit',faultlimit},Sheet,[AlphabetL(rangel) '8']),
    xlswrite(excelfile1,{'wmin',wmin},Sheet,[AlphabetL(rangel) '9']),
    xlswrite(excelfile1,{'wstep',wstep},Sheet,[AlphabetL(rangel) '10']),
    xlswrite(excelfile1,{'wmax',wmax},Sheet,[AlphabetL(rangel) '11']),    
end

%%%%
% Writing the output data in the excel file
Network=['K' num2str(K) '-M' num2str(M) '-N' num2str(N) '-R' num2str(R)];
PMt=sum(P_MC/MonteCarloT);
PMtdBm=10*log10(PMt)+30;
data=xlsread(excelfile1,Sheet,'A2:A200');  
lcolumn=length(data)+1; 
sumSINR=sum(sum(sinr_MC))/MonteCarloT;
sumSINRdBm=10*log10(sumSINR)+30;
xlswrite(excelfile1,{K,M,N,R,2*K*M+N*R,Network,PdBTxRx,PdBRRx,[num2str(PdBTxRx) '-' num2str(PdBRRx)],'U F opt.',PMt,PMtdBm,round(iter_MC/MonteCarloT),iter_MC/MonteCarloT,maxofiters,sumSINR,sumSINRdBm,missed(1),missed(3),missed(2),missed(5),missed(4),InputFolder,Outputfile,secs2hms(toc(tgGlobal)),datestr(datetime)},Sheet,['A' num2str(lcolumn+1)]),

%%%%
mkdir('.\Results\ExcelFiles')
copyfile(excelfile1,['.\Results\ExcelFiles\' excelfile2])
copyfile('../data/*.m',pwd)
copyfile('../data/*.xlsx',pwd)
zip(Outputfilename,{'*.fig','*.log','*.ltx','*.m','*.mat','*.xlsx','./library/*.*'});
movefile('*.zip',['.' Outputfolder])
delete('*.fig','*.log','*.tex','*.bak')
delete('Gene*.m','Netw*.xlsx','Runme*.xlsx')
close all
secs2hms(toc(tgGlobal))