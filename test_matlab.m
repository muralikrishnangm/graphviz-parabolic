clear all; clc;

nnodes = 5;
Xlim = [-5, 5];
Ylim = [-5, 5];

x = randi([Xlim(1), Xlim(2)], nnodes, 1);
y = randi([Ylim(1), Ylim(2)], nnodes, 1);
Adj = rand(nnodes);

f = figure(); clf; hold all;
plotgraph_parabola(x, y, Adj);