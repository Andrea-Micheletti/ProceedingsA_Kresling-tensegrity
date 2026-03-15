function [place,cplace]=coordsreduced(nodes,constrv)
%This function produces two vectors: 'place' and 'cplace'
%'place' contains unconstrained entries of nodes (nodal coordinates)
%'cplace' contains constrained entries
%'constrv' is the contraints vector

Nnodes=size(nodes,1)*size(nodes,2)/3;
place=nodes(:);
k=0;
cplace=zeros(sum(constrv),1);
for ii=3*Nnodes:-1:1
   if constrv(ii)==1
      place(ii)=[];
      k=k+1;
      cplace(k)=nodes(ii);
   end
end
cplace(:)=cplace(end:-1:1);
cplace=cplace';
