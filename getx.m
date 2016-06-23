function val=getx(oh,prop)
% val=GETX(oh,prop)
% 
% Gets a property from a HANDLE or an OBJECT
%
% INPUT
%
% oh      The object or handle in question
% prop    The property, a string, e.g. 'XData'
%
% OUTPUT
%
% val     The value of the requested property
%
% EXAMPLE
%
% getx(plot(1:10),'LineWidth')
% 
% SEE ALSO
%
% SETX
%
% Tested on 8.3.0.532 (R2014a) and 9.0.0.341360 (R2016a)
% Last modified by fjsimons-at-alum.mit.edu, 06/23/2016

if verLessThan('matlab','R2014b')
  val=get(oh,prop);
else
  val=oh.(prop);
end
