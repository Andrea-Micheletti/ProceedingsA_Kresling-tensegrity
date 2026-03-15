function lz = zangles(nodes,zedges)

csf = 1; % set to 1 (0) to use the 'acos' ('asin') function to compute the angles

Nzedges = size(zedges,1);

lz=zeros(Nzedges,1);

for k=1:Nzedges
    nh = zedges(k,1);
    ni = zedges(k,2);
    nj = zedges(k,3);
    nk = zedges(k,4);
    rhi = nodes(:,ni) - nodes(:,nh);
    rij = nodes(:,nj) - nodes(:,ni);
    rjk = nodes(:,nk) - nodes(:,nj);
    nijh = cross( rij , -rhi );
    njki = cross( rjk , -rij );
    nnijh = norm( nijh );
    nnjki = norm( njki );
    if csf
        ang = acos(dot(nijh,njki)/(nnijh*nnjki));
    else
        ang = asin(norm(cross(nijh,njki))/(nnijh*nnjki));
    end
    lz(k)=ang;
    

%     v1=nodes(:,zedges(ii,1));
%     v2=nodes(:,zedges(ii,2));
%     v3=nodes(:,zedges(ii,3));
%     v4=nodes(:,zedges(ii,4));
%     dir1=v2-v1; %dir1=dir1/norm(dir1); 
%     dir2=v3-v2; %dir2=dir2/norm(dir2);
%     dir3=v4-v3; %dir3=dir3/norm(dir3);
%     normal1=cross(dir1,dir2); normal1=normal1/norm(normal1);
%     normal2=cross(dir2,dir3); normal2=normal2/norm(normal2);
%     normal=cross(normal1,normal2);
%     lzedges0(ii)=asin(norm(normal));
end
