function varargout=calcJRmodel(dep,xver)
% lmcosi=CALCJRMODEL(dep,xver)
%
% Loads the spherical harmonic coefficients of the (preliminary) S40RTS
% model, suitable for verification with Jeroen Ritsema's own codes and
% output for a number of VERY explicit depths where I have maps
% available. The code here was only tested for the specific instance of his
% model s40_prelim.sph, but no changes are needed or expected.
%
% INPUT:
%
% dep      Depth requested, in km (e.g. 120 600 1000 1500 2800)
% xver     1 Verify with the explicitly written out maps of JR 
%
% OUTPUT:
%
% lmcosi   [degr order cos sin] coefficients for PLM2XYZ/PLM2CUBE/PLOTPLM/PLM2SLEP
%
% Last modified by fjsimons-at-alum.mit.edu, 07/16/2016

% Define defaults
defval('dep',120)

% Where are the specifc map slices (e.g. map.1500km.xyz and
% map.1500km.ps.gz provided by Jeroen Ritsema, used for comparison?)
defval('diro','/u/fjsimons/IFILES/EARTHMODELS/RITSEMA/SLICES');

% Excessive verification with JR own output
defval('xver',1)

% Do my own interpolation
lmcosi=interpJRmodel(dep,'xpall','s40_prelim.sph');

if xver==1
  % Perform the expansion on a 1x1 degree grid and arrange
  defval('degres',1)
  [modl,lon,lat]=plm2xyz(lmcosi,degres);
  modljr=flipud(modl); 
  modljr=[modljr(2:end-1,181:end) modljr(2:end-1,2:180)];
  modljr=[modljr(:) ; modl(1) ; modl(end)];

  % Compare with the mapped output stored in 'diro'
  try
    % What is the misfit bewteen JR and me here?
    k=load(sprintf('%s/map.%ikm.xyz',diro,dep));
  catch
    error('Specify valid map depth!')
  end
  % plot(abs([k(:,3)-modljr])./abs(k(:,3))*100,'b+')
  plot(k(:,3),modljr,'b+')
  disp(sprintf('RMS misfit in percent is %5.3f %s',...
       sqrt(mean((k(:,3)-modljr).^2))/sqrt(mean(k(:,3).^2))*100,'%'))
end

% Generate output as requested
varns={lmcosi};
varargout=varns(1:nargout);
