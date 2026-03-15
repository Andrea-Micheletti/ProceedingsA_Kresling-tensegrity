% Copyright (c) 2001-2011, Andrea Micheletti
%
% Permission to use, copy, modify, and distribute this software for any
% purpose with or without fee is hereby granted, provided that the above
% copyright notice and this permission notice appear in all copies.

function A=eqlmat(nodes,edges)
% This function produces the equilibrium matrix
% for a given topology and a given 3*Nnodes vector
% it considers all nodes and all edges
%'edges' contains the end nodes of the elements
%'nodes' is a (3*'Nnodes')-dimensional vector or equivalently is a (3*'Nnodes') matrix
%'Nnodes is the number of nodes
%'Nedges is the number of edges

Nnodes=prod(size(nodes))/3;
Nedges=size(edges,1);
A=zeros(3*Nnodes,Nedges);
%iteration on the columns of the equilibrium matrix 
for k=1:Nedges
    n1=edges(k,1);
    n2=edges(k,2);
   %assigns to entries corresponding to first joint of edge k
   %the difference between first and second joint's coordinates
   a=(nodes(3*n1-2:3*n1)-...
      nodes(3*n2-2:3*n2));
   A(3*n1-2:3*n1,k)=a(:);
   %assigns to entries corresponding to second joint of edge k
   %the difference between second and first joint's coordinates
   A(3*n2-2:3*n2,k)=-a(:);
end


