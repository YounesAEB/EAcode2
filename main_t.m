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

cParams.F = 1000; %[N]
cParams.Young = 75e9 ; %[Pa]
cParams.Area = 120e-6 ; %[m2]
cParams.Inertia = 1400e-12; %[m4]
cParams.e=4;
cParams.L=1;

%% PREPROCESS

% Nodal coordinates matrix creation
%  x(a,j) = coordinate of node a in the dimension j
g=Geometry(cParams);
x=g.creationMatrixNodalCoordinates();

% Connectivities matrix ceation
%  Tn(e,a) = global nodal number associated to node a of element e
Tnod = g.creationConnectivityMatrix;

% External force matrix creation
%  Fdata(k,1) = node at which the force is applied
%  Fdata(k,2) = DOF (direction) at which the force is applied
%  Fdata(k,3) = force magnitude in the corresponding DOF
%/ DOF_globals = NODE*DOF_locals
Fdata= g.ExternalForceMatrixCreation(cParams.F);

% Fix nodes matrix creation
%  fixNod(k,1) = node at which some DOF is prescribed
%  fixNod(k,2) = DOF prescribed
%  fixNod(k,3) = prescribed displacement in the corresponding DOF (0 for fixed)
fixNod = g.creationFixNodesMatrix();

% Material data
%  mat(m,1) = Young modulus of material m
%  mat(m,2) = Section area of material m
%  --more columns can be added for additional material properties--
mat = Material(cParams);

% Material connectivities
%  Tmat(e) = Row in mat corresponding to the material associated to element e 
Tmat = mat.creationMaterialConnectivity(g.numElements);

%% SOLVER

% Dimensions
n_d = size(x,2);              % Number of dimensions
n_i = n_d;                    % Number of DOFs for each node
n = size(x,1);                % Total number of nodes
n_dof = n_i*n;                % Total number of degrees of freedom
n_el = size(Tnod,1);          % Total number of elements
n_nod = size(Tnod,2);         % Number of nodes for each element
n_el_dof = n_i*n_nod;         % Number of DOFs for each element 


% Computation of element stiffness matrices
[Kel,leb] = mat.computeKelBar(n_el,n_el_dof,x,Tnod,mat,Tmat);

% Global matrix assembly
k = GlobalStiffnessMatrixComputer(Kel,Tnod,n,n_dof);
Td=k.connectDOFS();
KG =k.assemblyKG(Td);

% Global force vector assembly
f=GlobalForceVectorAssembly();
Fext=f.computeF(n_i,n_dof,Fdata);

% Apply conditions 
[vL,vR,uR]=Solver.applyCond(n_dof,fixNod);


% System resolution
[cParams.KRR,cParams.KRL,cParams.KLR,cParams.KLL,cParams.FL,cParams.FR]=Solver.partitionK(vL,vR,KG,Fext);
cParams.type='direct';
cParams.uR=uR;

t=Solver.create(cParams);
uL=t.resolution();
[u,R]=Solver.displacementObtention(cParams,uR,vL,vR,uL);

% Compute strain and stresses
[eps,sig]= Solver.computeStrainStressBar(n_d,n_nod,n_el,u,Td,x,Tnod,mat,Tmat);
%% POSTPROCESS

% Plot deformed structure with stress of each bar
scale = 100; % Adjust this parameter for properly visualizing the deformation
plotBarStress3D(x,Tnod,u,sig,scale);

%% Buckling
sigbuck = Solver.buckling(leb,mat,Tmat,n_el);
