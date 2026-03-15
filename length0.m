function l=length0(nodes,edges)
Nedges=size(edges,1);
l=zeros(Nedges,1);
for j=1:Nedges
N1=edges(j,1);
N2=edges(j,2);
J1=nodes(:,N1);
J2=nodes(:,N2);
l(j)=norm(J2-J1);
end

