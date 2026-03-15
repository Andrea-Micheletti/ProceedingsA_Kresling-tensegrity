% Copyright (c) 2001-2011, Andrea Micheletti
%
% Permission to use, copy, modify, and distribute this software for any
% purpose with or without fee is hereby granted, provided that the above
% copyright notice and this permission notice appear in all copies.

function nodesv=coordswhole(place,cplace,constrv)
nodesv=zeros(size(constrv,1),size(place,2));
k=0;
for ii=1:size(constrv,1)
   if constrv(ii)==0
      nodesv(ii,:)=place(ii-k,:);
   else
      k=k+1;
      nodesv(ii,:)=cplace(k);
   end
end
