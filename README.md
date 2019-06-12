# Distributed Multi-Stream Beamforming in MIMO Multi-Relay Interference Networks
This repository contains the Matlab codes for the proposed distributed joint transmit and relay beamforming filter optimization in Section VI. of the following paper:
C. M. Yetis and R. Y. Chang, “Distributed multi-stream beamforming in MIMO multi-relay interference networks,” IEEE Access, vol. 7, pp. 7535 - 7554, Jan. 2019.
The codes can be modified to obtain the proposed distributed transmit beamforming filter optimization in the same paper.

# Abstract 
In this paper, multi-stream transmission in interference networks aided by multiple amplify-and-forward (AF) relays in the presence of direct links is considered. The objective is to minimize the sum power of transmitters and relays by beamforming optimization under the stream signal-to-interference-plus-noise-ratio (SINR) constraints. For transmit beamforming optimization, the problem is a well-known non-convex quadratically constrained quadratic program (QCQP) that is NP-hard to solve. After semi-de nite relaxation (SDR), the problem can be optimally solved via alternating direction method of multipliers (ADMM) algorithm for distributed implementation. Analytical and extensive numerical analyses demonstrate that the proposed ADMM solution converges to the optimal centralized solution. The convergence rate, computational complexity, and message exchange load of the proposed algorithm outperforms the existing solutions. Furthermore, by SINR approximation at the relay side, distributed joint transmit and relay beamforming optimization is also proposed that further improves the total power saving at the cost of increased complexity. 

# Contents of the Repository
This repository contains about 30 Matlab files. Please see the UserManual_v04.docx file for the detailed information. The outputs of the Matlab executions are gathered in the output_v03.xlsx file. For plotting the figures, the data in this excel file can be processed by using Excel software. For scrutinizing purposes, the outputs are also logged in text files with the ".log" extensions.

# Acknowledgement
This work was supported by the Ministry of Science and Technology, Taiwan, under Grant MOST 106-2628-E-001-001-MY3.

# License and Referencing
This code package is licensed under the GPLv3 license. If you in any way use these codes or get inspired by these codes for research that results in publications, please cite our original article listed above.
