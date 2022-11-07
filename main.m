%-------------------------------------------------------------------------%
% ASSIGNMENT 02: OBJECT-ORIENTED PROGRAMMING
%-------------------------------------------------------------------------%
% Author/s: Younes Akhazzan
clc;
clear;
close all;

%% INPUT DATA
cParams.F = 1000; %[N]
cParams.Young = 75e9 ; %[Pa]
cParams.Area = 120e-6 ; %[m2]
cParams.Inertia = 1400e-12; %[m4]
cParams.type='direct'; 
cParams.scale=100; % Adjust this parameter for properly visualizing the deformation

%% MAIN
c=StructuralComputer(cParams);
c.globalComputer();