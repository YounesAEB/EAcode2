%-------------------------------------------------------------------------%
% ASSIGNMENT 02: OBJECT-ORIENTED PROGRAMMING
%-------------------------------------------------------------------------%
% Author/s: Younes Akhazzan
clc;
clear;
close all;

%% INPUT DATA
load('testData.mat');
cParams = testData;

%% MAIN
t = TestClass(cParams);
t.check();
