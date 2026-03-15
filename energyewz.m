function [en,engrad]=...
    energyewz(x,cplace,constrv,edges,wedges,zedges,...
    lf,thf,lzf,kav,ksv,kzv,forces)

xx=coordswhole(x,cplace,constrv);

%xx=xx;

Nnodes=size(xx,1)/3;
nodes=zeros(3,Nnodes);
nodes(:)=xx;

l=length0(nodes,edges);
dl=l-lf;
stress=kav.*dl;

th=theta(nodes,wedges);
dth=th-thf;
wstress=ksv.*(th-thf);

lz=zangles(nodes,zedges);
dlz=lz-lzf;
zstress=kzv.*dlz;

el_en=0.5*(sum(stress.*dl)+sum(wstress.*dth)+sum(zstress.*dlz));

en = el_en - sum(forces.*nodes(:));

if nargout>1
    engrad=(eqlmate(nodes,edges)*stress...
        +eqlmatw(nodes,wedges)*wstress...
        +eqlmatz(nodes,zedges)*zstress...
        -forces);
    engrad(constrv==1)=[];
end