function ExplanatoryFiles_UFIterII_v02(fido2E,fido3E,fido5E,fido6E,fido7E,fido8E,fido9E,fido1,Name2,Delta,iterlimit,rhoF,rhocF,rhoU,rhocU,faultlimit,wmin,wstep,wmax)

%_iter_iterav_PTot_PTotav_
fprintf(fido1,'%%%%%%%%%%\n');fprintf(fido1,'%%Parameters\n');
fprintf(fido1, 'SNR= %s\n', Name2);
fprintf(fido1,'Delta= %1.6f, iterlimit= %d, rhoF= %2.2f, rhocF= %1.2f, rhoU= %2.2f, rhocU= %1.2f, faultlimit=%d, wmin=%d, wstep=%d, wmax=%d\n',Delta,iterlimit,rhoF,rhocF,rhoU,rhocU,faultlimit,wmin,wstep,wmax);
fprintf(fido1,'Time= %s\n',datetime);
fprintf(fido1,'%%%%%%%%%%\n');

%_sinrt_sinr_PTot_iter_
fprintf(fido2E,'<SINR targets>\n');
fprintf(fido2E,'<achieved SINRs: SINR_{1,1} ... SINR_{1,d_1} ... SINR_{K,1} ... SINR_{K,d_K}> \n');
fprintf(fido2E,'<total power>\n');
fprintf(fido2E,'<iteration number>\n');

%_AllOutputs_Final
fprintf(fido3E,'<sum-SINR>\n');
fprintf(fido3E,'<total power>\n');
fprintf(fido3E,'<fairness index>\n');
fprintf(fido3E,'<iteration number>\n');
fprintf(fido3E,'<Monte Carlo target>\n');
fprintf(fido3E,'<SINR targets>\n');
fprintf(fido3E,'<achieved SINRs: SINR_{1,1} ... SINR_{1,d_1} ... SINR_{K,1} ... SINR_{K,d_K}> \n');
fprintf(fido3E,'<power per stream: P_{1,1} ... P_{1,d_1} ... P_{K,1} ... P_{K,d_K}>.\n');

%_sinrt_sinr_PTot_iter_wMissedChannels_
fprintf(fido5E,'This file gives detailed information for all Monte Carlo runs including the missed channels\n');
fprintf(fido5E,'<SINR targets>\n');
fprintf(fido5E,'<achieved SINRs: SINR_{1,1} ... SINR_{1,d_1} ... SINR_{K,1} ... SINR_{K,d_K}> \n');
fprintf(fido5E,'<total power>\n');
fprintf(fido5E,'<iteration number>\n');

%_NonConverging_
fprintf(fido6E,'This file gives detailed information about the non-convergence cases\n');
fprintf(fido6E,'<Monte Carlo number>\n');
fprintf(fido6E,'<SINR targets>\n');
fprintf(fido6E,'<achieved SINRs: SINR_{1,1} ... SINR_{1,d_1} ... SINR_{K,1} ... SINR_{K,d_K}>\n');
fprintf(fido6E,'<Delta logs>\n');

%_SlowConverging_
fprintf(fido7E,'This file gives detailed information about the slow-convergence cases\n');
fprintf(fido7E,'<Monte Carlo number>\n');
fprintf(fido7E,'<SINR targets>\n');
fprintf(fido7E,'<achieved SINRs: SINR_{1,1} ... SINR_{1,d_1} ... SINR_{K,1} ... SINR_{K,d_K}>\n');
fprintf(fido7E,'<Delta logs>\n');

%_ChannelsDetails_
fprintf(fido8E,'This file gives detailed information about each Monte Carlo run\n');
fprintf(fido8E,'<l: slow convergence>\n');
fprintf(fido8E,'<n: non-convergence (can be due to fluctuation or infeasibility)>\n');
fprintf(fido8E,'<s: success>\n');
fprintf(fido8E,'<U: maximum transmit filter power violation>\n');
fprintf(fido8E,'<F: maximum relay filter power violation>\n');

%_PowerViol_
fprintf(fido9E,'In case, there is a power violation at the transmitter or relay side, this file gives detailed information about these cases\n');
fprintf(fido9E,'<Monte Carlo number>\n');
fprintf(fido9E,'<U: Transmitter side power violation. F: Relay side power violation >\n');
fprintf(fido9E,'<Upper bounds>\n');
fprintf(fido9E,'<Lower bounds>\n');
fprintf(fido9E,'<SINR targets>\n');
fprintf(fido9E,'<Total transmitter power>\n');
fprintf(fido9E,'<Total relay power>\n');
fprintf(fido9E,'<iteration number>\n');