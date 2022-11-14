%-------------------------------------------------------------------------%
% ASSIGNMENT 02: OBJECT-ORIENTED PROGRAMMING
%-------------------------------------------------------------------------%
% Author/s: Younes Akhazzan
clc;
clear;
close all;

%% INPUT DATA
cParams = load('exactSolution.mat');

%% MAIN
t = TestClass(cParams);
t.check();
