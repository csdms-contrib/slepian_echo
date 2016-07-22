function xp=rtssplines(dep,fname)
% xp=RTSSPLINES(dep,fname)
%
% Find the expansion coefficients into a certain spline basis for a
% certain depth, in keeping with the model from Jeroen Ritsema. These
% were originally calculated and saved using a series of Fortran codes
% written by and available from Jeroen Ritsema, which were tested to
% return identical results (on the preliminary model s40_prelim.sph)
% using CALCJRMODEL which is now no longer needed.
%
% INPUT:
%
% dep      Depth requested, in km
% fname    Filename string with precomputed depths, as in:
%          'xpcube'[default, for the canonical cubed sphere]
%          'xpall' [one for every km in the mantle]
%
% OUTPUT:
%
% xp       The radial spline expansion coefficients required
%
% SEE ALSO:
%
% CALCJRMODEL, INTERPJRMODEL, READJRMODEL
%
% Last modified by fjsimons-at-alum.mit.edu, 07/15/2016

% Define default depth
defval('dep',2189.775)

% Define default file names and directory locations
defval('diro',fullfile(getenv('IFILES'),'EARTHMODELS','RITSEMA'))
defval('fname','xpcube.mat')

% Load the precomputed coefficients
load(fullfile(diro,fname))
[d,i]=sort(xp(:,1),1,'descend');
bigxp=xp(i,:);

% Locate the apropriate set of coefficients
%xp=bigxp(bigxp(:,1)==dep,2:end);
xp=bigxp(abs(bigxp(:,1)-dep)<1e-6,2:end);
