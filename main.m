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

%% PREPROCESS
data=Data.setData(cParams);

%% SOLVER
% Dimensions
dimensions=Dimensions.setDimensions(data);

% Global matrix assembly
k = GlobalStiffnessMatrixComputer(data,dimensions);
k.compute();

% Global force vector assembly
f=GlobalForceVectorAssembly(data,dimensions);
f.computeF();
 
% System resolution
s=Solver(cParams,data,dimensions,k,f);
s.computeSolver();

%Obtention of displacements and reactions
d=DisplacementReactionObtention(s);
d.compute();

% Compute strain and stresses + buckling stress
ss=StrainStressComputer(data,dimensions,k,d);
%ss.compute();
ss.compute();

%% POSTPROCESS
% Plot deformed structure with stress of each bar
p=PlotStress3D(cParams, dimensions, data, d, ss);
p.plot();
