clc, clear,close all;
initCobraToolbox(false);

%load model
model_add = 'F:\drtefagh\Recon3D.mat';
model = readCbModel(model_add);
S = model.S;
spy(S)

%remove biomass
checkObjective(model)
rxns = model.rxns;
index1 = find(strcmp(rxns, 'BIOMASS_maintenance'))
S(: ,2877 )=[];

%square
[nMets, nRxns] = size(S)
S = [zeros(nMets,nMets) S; S' zeros(nRxns,nRxns)];
spy(S)
[m , n] = size(S)

%label

W = compose('head%d', 1:n)';
lables = {};
lables = cellstr(W);

%reordering & spy
m = symamd(S);
Snew = S(m,m);
spy(S)
spy(S(m,m))
title('Approximate Minimum Degree')

%before-after tables
before = array2table(S, 'VariableNames', lables, 'RowNames', lables.');
after = array2table(S(m, m), 'VariableNames', lables(m), 'RowNames', lables(m).');

%numerical analysis
Snew = S(m,m);

nElem = numel(S);
nNz = nnz(S);
sparsityRatio = (1 - nNz / nElem) * 100.0

nElem_new = numel(Snew);
nNz_new = nnz(Snew);
sparsityRatio_new = (1 - nNz_new / nElem_new) * 100.0


colDensityAv = 0;
for j = 1:nRxns
colDensityAv = colDensityAv + nnz(S(:, j));
end
colDensityAv = colDensityAv / nRxns

colDensityRel = colDensityAv / nMets * 100


colDensityAv_new = 0;
for j = 1:nRxns
colDensityAv_new = colDensityAv_new + nnz(Snew(:, j));
end
colDensityAv_new = colDensityAv_new / nRxns

colDensityRel_new = colDensityAv_new / nMets * 100


spyc(S, colormap(advancedColormap('cobratoolbox')));
set(gca, 'fontsize', 14);

spyc(Snew, colormap(advancedColormap('cobratoolbox')));
set(gca, 'fontsize', 14);
spyc

