% Copyright (c) 2001-2024, Andrea Micheletti
%
% Permission to use, copy, modify, and distribute this software for any
% purpose with or without fee is hereby granted, provided that the above
% copyright notice and this permission notice appear in all copies.

function cvector=constraints(rconstraints,Nnodes)

cvector=zeros(3*Nnodes,1);
for ii=1:size(rconstraints,2)
   cvector(3*rconstraints(1,ii)-2:3*rconstraints(1,ii))=rconstraints(2:4,ii);
end
