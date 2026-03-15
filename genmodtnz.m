% Copyright (c) 2001-2011, Andrea Micheletti
%
% Permission to use, copy, modify, and distribute this software for any
% purpose with or without fee is hereby granted, provided that the above
% copyright notice and this permission notice appear in all copies.

function [nodes,edges,wedges,zedges,stypes,wtypes,ztypes]=...
    genmodtnz(n,a,b,h,dth,or)

%Data generation for the T-n structure.
%'Nnodes' total number of nodes
%'Nedges' total number of edges
%'nodes' (3,Nnodes)-array that contains nodes coordinates
%'edges' (Nedges,2)-array that contains pair of nodes connected by edges
%'etypes' (Nedges)-vector that contains edge type specification (0 strut, 1 tendon)
%'stypes' (Nedges)-vector that contains additional edge type specification (<0 strut, >0 tendon)
%'genmodtn(n,a,b,h,or)' produce the above data for a T-n modulus with:
%'a' lower base circumscribed radius
%'b' upper base circumscribed radius
%'h' modulus height
%'or' specifies modulus orientation (1 ccw,-1 cw) 

%constants
p=2*pi/n;%cyclic symmetry period
tw=pi/n+pi/2+dth;% relative rotation of the upper polygon (twist, zero when struts are vertical)

%nodes generation
Nnodes=2*n;
nodes=zeros(3,Nnodes);
for k=1:n
   % 1:3 lower nodes
   nodes(1,k)=a*cos(or*((k-1)*p));
   nodes(2,k)=a*sin(or*((k-1)*p));
   nodes(3,k)=0;
   % 4:6 upper nodes
   nodes(1,k+n)=b*cos(or*(tw+(k-1)*p));
   nodes(2,k+n)=b*sin(or*(tw+(k-1)*p));
   nodes(3,k+n)=h;  
end

%edges generation
Nedges=n+3*n;
edges=zeros(Nedges,2);
stypes=zeros(Nedges,1);
%Nwedges=2*n;
wedges=[];
wtypes=[];
Nzedges=2*n;
zedges=zeros(Nzedges,4);
ztypes=zeros(Nzedges,1);
for k=1:n
   edges(k,1)=k;edges(k,2)=1+mod(k,n); 			   % lower cables
   stypes(k)=1;
   edges(k+n,1)=k;edges(k+n,2)=k+n; 					% bars
   stypes(k+n)=-1;
   edges(k+2*n,1)=1+mod(k,n);edges(k+2*n,2)=k+n; 	% diagonal cables
   stypes(k+2*n)=2;
   edges(k+3*n,1)=k+n;edges(k+3*n,2)=1+n+mod(k,n); % upper cables
   stypes(k+3*n)=3;
   zedges(k,:)=[n+1+mod(k+n-2,n) k n+1+mod(k+n-1,n) 1+mod(k,n)];
   ztypes(k)=1;
   zedges(n+k,:)=[k n+1+mod(k+n-1,n) 1+mod(k,n) n+1+mod(k+n,n)];
   ztypes(n+k)=2;
end

% %assign edge types
% etypes=ones(size(edges,1),1);
% for k=n+1:2*n
%    etypes(k)=0;
% end
% 
% %particular case of n=2
% if n==2
%    Nedges=Nedges-2;
%    edges(1:Nedges,:)=edges(2:Nedges+1,:);
%    etypes(1:Nedges)=etypes(2:Nedges+1);
%    edges(Nedges+1:Nedges+2,:)=[];
%    etypes(Nedges+1:Nedges+2)=[];
% end

