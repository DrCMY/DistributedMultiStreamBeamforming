% Variable initializations
function [lambdavF,zetavF,zetanvF,muvF,munvF,lambdavU,zetavU,zetanvU,muvU,munvU]= VarInits_UFIterII_v01(K,R,B,d)
load lambdav; 
load zetav;   
load zetanv;  
load muv;     
load munv;    

lambdavF=lambdav(1:R,1:B); % Lagrangian dual variable vector of the sum of auxiliary variables for the design of relay beamforming filters. See $\dot{\lambda}_r^{k,l}$ in (47)
zetavF=zetav(1:R,1:B);     % Auxiliary variables of the desired SINR plus noise terms for the design of relay beamforming filters. See $\dot{\zeta}_r^{k,l}$ in (46c)
zetanvF=-zetanv(1:R,1:B);  % Auxiliary variables of the interference SINR terms for the design of relay beamforming filters. See $\dot{\zeta}_r^{k,l\backprime}$ in (46d)
muvF=muv(1:R,1:B);         % ADMM dual variable of the zetavF auxiliary variable for the design of relay beamforming filters, i.e., $\dot{\mu}_r^{k,l}$ 
munvF=munv(1:R,1:B);       % ADMM dual variable of the zetanvF auxiliary variable for the design of relay beamforming filters, i.e., $\dot{\mu}_r^{k,l\backprime}$ 

lambdavU=lambdav(1:K,1:d); % Lagrangian dual variable vector of the sum of auxiliary variables for the design of transmit beamforming filters. See $\lambda_{k,l}$ in (19)
zetavU=zetav(1:K,1:d);     % Auxiliary variables of the desired SINR plus noise terms for the design of transmit beamforming filters. See $\zeta_{k,l}$ in (17)
zetanvU=zetanv(1:K,1:d);   % Auxiliary variables of the interference SINR terms for the design of transmit beamforming filters. See $\zeta_{k,l}^\backprime$ in (17)
muvU=muv(1:K,1:d);         % ADMM dual variable of the zetavU auxiliary variable for the design of transmit beamforming filters. See $\mu_{k,l}$ in (24b)
munvU=munv(1:K,1:d);       % ADMM dual variable of the zetanvU auxiliary variable for the design of transmit beamforming filters. See $\mu_{k,l}^\backprime$ in (24c)