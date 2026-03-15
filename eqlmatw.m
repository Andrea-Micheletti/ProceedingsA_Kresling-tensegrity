function Aw=eqlmatw(nodesv,wedges)

Nnodes=prod(size(nodesv))/3;
Nwedges=size(wedges,1);
lw=zeros(Nwedges,3);

Aw=zeros(3*Nnodes,Nwedges);
nodes=zeros(3,Nnodes);
nodes(:)=nodesv(:);

for k=1:Nwedges
    n1=wedges(k,1);
    n2=wedges(k,2);
    n3=wedges(k,3);
    av=nodes(:,n1)-nodes(:,n2);
    bv=nodes(:,n1)-nodes(:,n3);
    cv=nodes(:,n2)-nodes(:,n3);
    a=norm(av); b=norm(bv); c=norm(cv); 
    th=acos((a^2+b^2-c^2)/(2*a*b));   
    
   Aw(3*n1-2:3*n1,k)=(b*cos(th)/a-1)*av+(a*cos(th)/b-1)*bv;
   Aw(3*n2-2:3*n2,k)=cv+(b*cos(th)/a-1)*(-av);
   Aw(3*n3-2:3*n3,k)=-cv+(a*cos(th)/b-1)*(-bv);
   Aw(:,k)=Aw(:,k)/(a*b*sin(th));

end
