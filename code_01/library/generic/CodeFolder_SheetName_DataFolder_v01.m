function [CodeFolder,SheetName,DataFolder]=CodeFolder_SheetName_DataFolder_v01
CodeFolder=[pwd '\'];
cd '..\data\'
DataFolder=[pwd '\'];
SheetName=textscan(CodeFolder,'%s','delimiter','\');
SheetName=cellfun(@(v) v(end),SheetName);
SheetName=char(SheetName);