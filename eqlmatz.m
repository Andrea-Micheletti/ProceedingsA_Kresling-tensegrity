function Az=eqlmatz(nodesv,zedges)

Nnodes=numel(nodesv)/3;
Nzedges=size(zedges,1);

Az=zeros(3*Nnodes,Nzedges);
nodes=zeros(3,Nnodes);
nodes(:)=nodesv(:);

for k=1:Nzedges
    nh = zedges(k,1);
    ni = zedges(k,2);
    nj = zedges(k,3);
    nk = zedges(k,4);
    rh = nodes(:,nh);
    ri = nodes(:,ni);
    rj = nodes(:,nj);
    rk = nodes(:,nk);
    rhi = ri-rh;
    rij = rj-ri;
    rjk = rk-rj;
    nijh = cross( rij , -rhi );
    njki = cross( rjk , -rij );
    
    fx=-1+2*(dot(rh-ri+rk-rj,nijh)>0);
    
    rrij = norm( rij );
    nnijh2 = dot( nijh , nijh );
    nnjki2 = dot( njki , njki );
        
   Az(3*nh-2:3*nh,k)= - ( rrij / nnijh2 ) * nijh ;
      
   Az(3*ni-2:3*ni,k)=...
       (( rrij + dot(rhi,rij) / rrij ) / nnijh2) * nijh ...
       + (dot(rjk,rij) / ( nnjki2 * rrij )) * njki ;
      
   Az(3*nj-2:3*nj,k)=...
       - (( rrij + dot(rjk,rij) / rrij ) / nnjki2) * njki ...
       - (dot(rhi,rij) / ( nnijh2 * rrij )) * nijh ;
   
   Az(3*nk-2:3*nk,k)= ( rrij / nnjki2 ) * njki ;
   
   Az(:,k) = fx * Az(:,k);
   
end
%Az=-Az;