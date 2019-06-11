function InputFolder=InputFolder_v01(MonteCarlo,K,R,Name1,DataFolder)
InputFolderx=['MC' num2str(MonteCarlo) '\K' num2str(K) '\R' num2str(R) '\'];
InputFolder=[DataFolder 'Inputs\' InputFolderx Name1 '.zip'];