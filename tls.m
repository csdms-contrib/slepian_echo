function P=tls(xdata,ydata)
% P=TLS(xdata,ydata)
%
% Total Least Squares via SVD. It pays to standardize xdata, see POLYFIT,
% e.g. P=TLS([xdata-mean(xdata)]/std(xdata),ydata)
%
% INPUT:
%
% xdata, ydata   What it sounds like
%
% OUTPUT
%
% P              The polynomial expansion coefficients as from POLYFIT
%
% Last modified by fjsimons-at-alum.mit.edu, 11/24/2015

% From a Wikipedia article on Total Least Squares... need better reference

if length(xdata)~=length(ydata)
  error('These data do not come in pairs')
else
  % Vectorize
  xdata=xdata(:);
  ydata=ydata(:);
end

% number of x,y data pairs
m=length(ydata);
% The sensitivity vector
A=[ones(m,1) xdata];
B=ydata;
% n is the width of A (A is m by n)
n=size(A,2); 
% C is A augmented with B
C=[A B];
% find the SVD of C.
[U,S,V]=svd(C,0); 

% Take the block of V consisting of the first n
% rows and the n+1 to last column
% Take the bottom-right block of V.
VAB=V(1:n,1+n:end);
VBB=V(1+n:end,1+n:end); 
% This now should be the solution
P=-VAB/VBB;

% Now reorder the polynomial degrees to conform with POLYFIT
P=flipud(P)';
