function s=isemptyx(p,prop)
% s=ISEMPTYX(p,prop)
%
% Returns whether or not a specific property of a graphics handle or
% object is empty or not.
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
  s(index)=all(isempty(getx(p(index),prop)));
end

