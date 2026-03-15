% Copyright (c) 2001-2024, Andrea Micheletti
%
% Permission to use, copy, modify, and distribute this software for any
% purpose with or without fee is hereby granted, provided that the above
% copyright notice and this permission notice appear in all copies.

function f=firstpicture(nodes0,edges,etypes)
% this function draw a picture of the structure after data generation

Nnodes=(size(nodes0,1)*size(nodes0,2)/3);
nodes=zeros(3,Nnodes);
nodes(:)=nodes0(:);

f=figure;

p=zeros(size(edges,1));

for k=1:size(edges,1)
      
      if etypes(k)<=0
         p(k)=bar(nodes(:,edges(k,1)),nodes(:,edges(k,2)));
      elseif etypes(k)>0
         p(k)=cable(nodes(:,edges(k,1)),nodes(:,edges(k,2)));
      else
         p(k)=cable2(nodes(:,edges(k,1)),nodes(:,edges(k,2)));
      end
      
end


axis equal
axis on, grid off
set(gcf,'color','white')

br=1.1;
gap=0.1;
x1=br*min(nodes(1,:))-0.01; x2=br*max(nodes(1,:))+0.01;
x1=x1-gap*(x2-x1);       x2=x2+gap*(x2-x1);
y1=br*min(nodes(2,:))-0.01; y2=br*max(nodes(2,:))+0.01;
y1=y1-gap*(y2-y1);       y2=y2+gap*(y2-y1);
z1=br*min(nodes(3,:))-0.01; z2=br*max(nodes(3,:))+0.01;
z1=z1-gap*(z2-z1);       z2=z2+gap*(z2-z1);
set(gca,'Zlim',[z1 z2],'Xlim',[x1 x2],'Ylim',[y1 y2]);

X=text('string','X'); Y=text('string','Y'); Z=text('string','Z');
set(gca,'xlabel',X,'ylabel',Y,'zlabel',Z);





function l=bar(p1,p2)
a=[p1(1) p2(1)];
b=[p1(2) p2(2)];
c=[p1(3) p2(3)];
l=line(a,b,c,'color','black','LineWidth',2);

function l=cable(p1,p2)
a=[p1(1) p2(1)];
b=[p1(2) p2(2)];
c=[p1(3) p2(3)];
l=line(a,b,c,'color','blue','LineWidth',1);
   
function l=cable2(p1,p2)
a=[p1(1) p2(1)];
b=[p1(2) p2(2)];
c=[p1(3) p2(3)];
l=line(a,b,c,'color','red','LineWidth',1);
