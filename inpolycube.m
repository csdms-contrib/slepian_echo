function varargout=inpolycube(lonv,latv,lfin,alfa,bita,gama)
% [v,xiv,etav]=INPOLYCUBE(lonv,latv,lfin,alfa,bita,gama)
%
% Finds the indices of a cubed-sphere grid that fall within a polygon
% defined by longitude and latitude pairs in degrees
%
% INPUT:
% 
% lonv,latv     Same-size arrays to define pairs of longitude and latitude
% lfin          Dyadic subdivision of the cubed sphere
% alfa          First Euler angle of wholesale tilt of all tiles [defaulted]
% beta          Second Euler angle of wholesale tilt of all tiles [defaulted]
% gama          Third Euler angle of wholesale tilt of all tiles [defaulted]
%
% OUTPUT:
%
% v             An index set that is plottable using PLOTONCUBE
% xiv,etav      The cubed-sphere coordinates of the polygon 
%
% SEE ALSO:
%
% BOXCUBE, PLOTONCUBE
%
% EXAMPLE:
%
% inpolycube('demo1')
% inpolycube('demo2')
%
% Last modified by fjsimons-at-alum.mit.edu, 10/12/2021

if ~isstr(lonv)
  % A default set of contours
  lon0=123; lat0=46; rad0=15; npt0=100;
  % Ouput first in spherical coordinates
  [lon1,lat1]=caploc([lon0 lat0],rad0,npt0,1);
  defval('lonv',lon1)
  defval('latv',lat1)

  % Do all default inputs for the cubed sphere
  defval('lfin',7)
  defval('alfa',[])
  defval('bita',[])
  defval('gama',[])

  % Convert these inputs to cubed-sphere coordinates
  [xiv,etav,fid]=sphere2cube(lonv,latv,alfa,bita,gama);

  % Now make the cubed sphere grid in cubed-sphere coordinates

  % Produce the Jacobian, the single-face coordinates and the angular
  % spacing 

  % Later might explore changing this but for now it appeas right
  eo=1; N=2^lfin+eo;
  % The xi,eta coordinates on a single face
  [~,~,~,~,XI,ETA]=cubejac(N,N,0);

  % Now for every face find whether the grid contains points inside the
  % curve or not... will be easy if the coordinates are within a face
  v=zeros(N,N,6); 
  for index=1:6
    if ~isempty(xiv{index}) & ~isempty(etav{index})
      % This all works fine if everything is WITHIN the face, but what if
      % it's straddling more? To add a CORNER point, or a piece of the
      % boundary like in INPOLYMOLL
      keyboard
      v(:,:,index)=inpolygon(XI,ETA,xiv{index},etav{index});
    end
  end
  
  % Variable output
  varns={v,xiv,etav};
  varargout=varns(1:nargout);
elseif strcmp(lonv,'demo1')
  % A bunch of handpicked ones
  lon0=123; lat0=46; rad0=15; npt0=100;
  [lon1,lat1]=caploc([lon0 lat0],rad0,npt0,1);
  [v1,xiv1,etav1]=inpolycube(lon1,lat1); 
  lon0=143; lat0=41; rad0=12; npt0=100;
  [lon2,lat2]=caploc([lon0 lat0],rad0,npt0,1);
  [v2,xiv2,etav2]=inpolycube(lon2,lat2);
  lon0=143; lat0=31; rad0=24; npt0=100;
  [lon3,lat3]=caploc([lon0 lat0],rad0,npt0,1);
  [v3,xiv3,etav3]=inpolycube(lon3,lat3);
  % Make the plot of the combined hitcounts
  plotoncube(v1+v2+v3,'2D',1); 
  % Add the contours
  hold on
  p{1}=plotonchunk(xiv1,etav1); 
  p{2}=plotonchunk(xiv2,etav2); 
  p{3}=plotonchunk(xiv3,etav3);
  plotcont([],[],9); hold off
  set(p{1}(:),'LineStyle','-')
  set(p{2}(:),'LineStyle','-')
  set(p{3}(:),'LineStyle','-')
elseif strcmp(lonv,'demo2')
  % A bunch of random ones
  nrand=30;
  lon0=rand(nrand,1)*360; lat0=90-rand(nrand,1)*180; rad0=rand(nrand,1)*20; npt0=100;
  [lonv,latv]=caploc([lon0 lat0],rad0,npt0,1);

  % Find the insides
  for index=1:size(lonv,2)
    [v{index},xiv{index},etav{index}]=inpolycube(lonv(:,index),latv(:,index));
  end

  vv=zeros(size(v{1}));
  % As many as their are domains
  for index=1:size(lonv,2)
    % As many as there are faces
    for ondex=1:6
      vv(:,:,ondex)=vv(:,:,ondex)+v{index}(:,:,ondex);
    end
  end

  % Flatten the result - 3D option requires eo adaptation
  plotoncube(vv,'2D',1)
  
  hold on
  for index=1:size(lonv,2)
    p{index}=plotonchunk(xiv{index},etav{index}); 
    hold on
    set(p{index}(:),'LineStyle','-')
  end
  plotcont([],[],9); 
  hold off
end

