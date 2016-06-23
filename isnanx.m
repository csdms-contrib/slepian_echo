function s=isnanx(p,prop)
% s=ISNANX(p,prop)
%
% Returns whether or not a specific property of a graphics handle or
% object is NaN or not.
%
% INPUT
%
% p        The handle or object
% prop     The property [default: 'XData']
%
% OUTPUT
%
% s        The logical
%
% Last modified by fjsimons-at-alum.mit.edu, 06/23/2016

defval('prop','XData')

% Loop over the entries
for index=1:length(p)
  s(index)=all(isnan(getx(p(index),prop)));
end


