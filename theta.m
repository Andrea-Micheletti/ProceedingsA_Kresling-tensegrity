function th=theta(nodes,wedges)

Nwedges=size(wedges,1);

th=zeros(Nwedges,1);

for ii=1:Nwedges
    l1=norm(nodes(:,wedges(ii,1))-nodes(:,wedges(ii,2)));
    l2=norm(nodes(:,wedges(ii,1))-nodes(:,wedges(ii,3)));
    l3=norm(nodes(:,wedges(ii,2))-nodes(:,wedges(ii,3)));
    th(ii)=acos((l1^2+l2^2-l3^2)/(2*l1*l2));
end


