function varargout=zerocube(d1,d2,d3,fnX)
% [X,fnX]=zerocube(d1,d2,d3,fnX)
% 
% Creates a standard cubed-sphere full of ZERO entries
%
% INPUT:
%
% d1,d2,d3   The lengths in the respective dimensions
% fnX        If given, takes the field names from here
%
% OUTPUT:
%
% X          The output structure with six three-dimensional arrays
% fnX        Field names
% 
% SEE ALSO:
%
% CELLNAN, CUBEMATS, RANDCUBE, NANCUBE
%
% Last modified by fjsimons-at-alum.mit.edu, 10/12/2021

defval('d1',128)
defval('d2',128)
defval('d3',37)
defval('fnX',{'xplus','zminus','yplus','xminus','zplus','yminus'});

for index=1:length(fnX)
  % Uses dynamic structure field variables
  X.(fnX{index})=zeros(d1,d2,d3);
end


% Output
varns={X,fnX};
varargout=varns(1:nargout);
