% Copyright (c) 2001-2024, Andrea Micheletti
%
% Permission to use, copy, modify, and distribute this software for any
% purpose with or without fee is hereby granted, provided that the above
% copyright notice and this permission notice appear in all copies.

function [a1,a2,b,c1,c2,rd]=subspaces(A,tol)

[a b c]=svd(A); %computes the singular value decomposition
b=diag(b); %vector containing the singular values
r=rank(A,tol); %rank
rd=min(size(A))-r; %rank-deficiency

a1=a(:,1:r); 
if size(A,1)>r, a2=a(:,r+1:end); else a2=[]; end

c1=c(:,1:r);
if size(A,2)>r, c2=c(:,r+1:end); else c2=[]; end
