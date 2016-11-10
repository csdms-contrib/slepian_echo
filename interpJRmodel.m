function varargout=interpJRmodel(dep,fname,mname)
% lmcosi=INTERPJRMODEL(dep,fname,mname)
%
% Calculates the spherical harmonic coefficients of the S40RTS model made
% by Jeroen Ritsema at a certain approved depth by knowing how to
% expand/interpolate explicitly using the splines that were precalculated.
%
% INPUT:
%
% dep      Depth requested, in km
% fname    Filename string with precomputed depths 'xpcube' [default] | 'xpall'
% mname    The model name {'S40RTS.sph' [default] | 's40_prelim.sph'}
%
% OUTPUT:
%
% lmcosi   [degr order cos sin] coefficients for PLM2XYZ/PLM2CUBE/PLOTPLM
%
% SEE ALSO:
%
% READJRMODEL, CALCJRMODEL, RTSSPLINES
% 
% EXAMPLE:
%
% figure(1) ; clf ; plotplm(calcJRmodel(600),[],[],[],1)
% figure(2) ; clf ; plotplm(interpJRmodel(609.525),[],[],[],1)
% figure(3) ; clf ; plotplm(interpJRmodel(600,'xpall'),[],[],[],1)
% figure(4) ; clf ; plotoncube(plm2cube(interpJRmodel(654.675)),'2D')
%
% Another comparison can be done at say 120 km ('xpall') and 112.875 km ('xpcube')
%
% Last modified by fjsimons-at-alum.mit.edu, 07/15/2016

% Define defaults
defval('dep',112.875)
defval('fname','xpcube')
defval('mname','S40RTS.sph')

% Get the expansion coefficients from the preloaded file
xp=rtssplines(dep,fname);

% Complain if needed
if isempty(xp)
  error('Specify valid depth')
end

% Load the model
% Hack for calcJRmodel
if ~strcmp(mname,'S40RTS.sph')
  [cosi,dels,dems]=readJRmodel(mname);
else
  % Go to default behavior with final model
  [cosi,dels,dems]=readJRmodel;
end

% Prepare output
lmcosi=[dels dems zeros(size(cosi(:,:,1)))];

% And perform the interpolation using the cubic splines
for ind=1:length(xp)
  lmcosi(:,3:4)=lmcosi(:,3:4)+xp(ind)*cosi(:,:,ind);
end

% Generate output
varns={lmcosi};
varargout=varns(1:nargout);
