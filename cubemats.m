function [rottot,mats,legs]=cubemats(alfa,bita,gama)
% [rottot,mats,legs]=CUBEMATS(alfa,bita,gama)
%
% This makes the rotation matrices to slap the "standard" X+ face of the
% cubed sphere as generated by CUBEJAC all over the three-dimensional
% sphere. 
%
% INPUT:
% 
% alfa      First Euler angle of wholesale tilt of all tiles [defaulted]
% beta      Second Euler angle of wholesale tilt of all tiles [defaulted]
% gama      Third Euler angle of wholesale tilt of all tiles [defaulted]
%
% OUTPUT:
%
% rottot    The wholesale rotation matrix
% mats      The 'facial' rotation matrices
% legs      Legends for a plot, should you want them
% 
% Last modified by fjsimons-at-alum.mit.edu, 08/20/2009

defval('alfa',0.2089-0.175);
defval('bita',0.9205+0.25);
defval('gama',1.2409-0.05);

% Make the wholesale rotation matrix, i.e the matrix that moves the
% tilted cube to its "standard position" (but with its "front face" not
% yet in the JV-convention)
rottot=rotz(gama)*roty(bita)*rotz(alfa);

% From the tilted cube we have to do an additional rotation to get
% the different faces in JV position and circulation convention.
mats{1}=rotx(pi);                % Face 1 or x-plus 
legs{1}='X+';

mats{2}=rotz(pi)*roty(-pi/2);    % Face 2 or z-minus 
legs{2}='Z-';

mats{3}=roty(pi/2)*rotz(-pi/2);  % Face 3 or y-plus 
legs{3}='Y+';

mats{4}=rotx(-pi/2)*rotz(-pi);   % Face 4 or x-minus
legs{4}='X-';

mats{5}=rotz(-pi/2)*roty(pi/2);  % Face 5 or z-plus 
legs{5}='Z+';

mats{6}=roty(pi)*rotz(pi/2);     % Face 6 or y-minus
legs{6}='Y-';
