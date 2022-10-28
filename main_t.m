%-------------------------------------------------------------------------%
% ASSIGNMENT 01
%-------------------------------------------------------------------------%
% Date: 21/02/2022
% Author/s: Younes Akhazzan i Ricard Arbat
%
clc;
clear;
close all;

%% INPUT DATA

F = 1000; %[N]
Young = 75e9 ; %[Pa]
Area = 120e-6 ; %[m2]
thermal_coeff =23e-6 ; %[1/K]
Inertia = 1400e-12; %[m4]
e=4;
deltaT=0;
L=1;

%% PREPROCESS

% Nodal coordinates matrix creation
%  x(a,j) = coordinate of node a in the dimension j
x = [0 0 0; 0 L 0;0 L L; 0 0 L; L L/2 L/2];

% Connectivities matrix ceation
%  Tn(e,a) = global nodal number associated to node a of element e
Tn = [1 5; 2 5; 3 5; 4 5];

% External force matrix creation
%  Fdata(k,1) = node at which the force is applied
%  Fdata(k,2) = DOF (direction) at which the force is applied
%  Fdata(k,3) = force magnitude in the corresponding DOF
Fdata = [5 3 -F]; %/ DOF_globals = NODE*DOF_locals

% Fix nodes matrix creation
%  fixNod(k,1) = node at which some DOF is prescribed
%  fixNod(k,2) = DOF prescribed
%  fixNod(k,3) = prescribed displacement in the corresponding DOF (0 for fixed)
fixNod = [1 1 0;1 2 0;1 3 0; 2 1 0;2 2 0;2 3 0;3 1 0;3 2 0;3 3 0;4 1 0;4 2 0;4 3 0;];

% Material data
%  mat(m,1) = Young modulus of material m
%  mat(m,2) = Section area of material m
%  --more columns can be added for additional material properties--
mat = [Young Area thermal_coeff Inertia];

% Material connectivities
%  Tmat(e) = Row in mat corresponding to the material associated to element e 
Tmat = ones(e,1);

%% SOLVER

% Dimensions
n_d = size(x,2);              % Number of dimensions
n_i = n_d;                    % Number of DOFs for each node
n = size(x,1);                % Total number of nodes
n_dof = n_i*n;                % Total number of degrees of freedom
n_el = size(Tn,1);            % Total number of elements
n_nod = size(Tn,2);           % Number of nodes for each element
n_el_dof = n_i*n_nod;         % Number of DOFs for each element 


% Computation of element stiffness matrices
[Kel,leb] = computeKelBar(n_d,n_el,x,Tn,mat,Tmat);

% Global matrix assembly
s = GlobalStiffnessMatrixComputer(Kel,Tn,n,n_dof);
Td=s.connectDOFS();
KG = s.assemblyKG(Td);

% Global force vector assembly
Fext = computeF(n_i,n_dof,Fdata);

% Apply conditions 
[vL,vR,uR] = applyCond(n_i,n_dof,fixNod);


% System resolution
[u,R] = solveSys_t(vL,vR,uR,KG,Fext);

% Compute strain and stresses
[eps,sig] = computeStrainStressBar_t(n_d,n_nod,n_el,u,Td,x,Tn,mat,Tmat);
%% POSTPROCESS

% Plot deformed structure with stress of each bar
scale = 100; % Adjust this parameter for properly visualizing the deformation
plotBarStress3D(x,Tn,u,sig,scale);

%% Buckling
sigbuck = buckling(leb,mat,Tmat,n_el);
