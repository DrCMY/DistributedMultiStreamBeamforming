function [excelfile1,excelfile2]=OutputExcelFiles_v02
excelfile1x=dir('*Output*.xlsx');
excelfile1=excelfile1x.name;
ef=textscan(excelfile1, '%s %s', 'delimiter','.');  
t=char(datetime('now','Format','yyMMdd''_''HHmm'));
excelfile2=[char(ef{1}) '_' t '.xlsx'];