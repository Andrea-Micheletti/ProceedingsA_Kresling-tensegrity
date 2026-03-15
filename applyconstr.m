% Copyright (c) 2001-2024, Andrea Micheletti
%
% Permission to use, copy, modify, and distribute this software for any
% purpose with or without fee is hereby granted, provided that the above
% copyright notice and this permission notice appear in all copies.

function A=applyconstr(A,rconstr)

%eliminates rows corresponding to constrained directions
for ii=size(rconstr,2):-1:1
   for jj=3:-1:1
      if rconstr(1+jj,ii)==1
         A(3*(rconstr(1,ii)-1)+jj,:)=[];
      end
   end
end
