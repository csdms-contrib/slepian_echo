function setx(oh,prop,val)
% SETX(oh,prop,val)
% 
% Sets a property from a HANDLE or an OBJECT
%
% INPUT
%
% oh      The object or handle in question
% prop    The property, a string, e.g. 'XData'
% val     The value of the property to be set
%
% EXAMPLE
%
% setx(plot(1:10),'LineWidth',2)
% 
% SEE ALSO
%
% GETX
%
% Tested on 8.3.0.532 (R2014a) and 9.0.0.341360 (R2016a)
% Last modified by fjsimons-at-alum.mit.edu, 06/21/2016

if verLessThan('matlab','9')
  set(oh,prop,val);
else
  oh.(prop)=val;
end




