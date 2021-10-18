function varargout=inpolymoll(lonv,latv,degres)
% [v,xp,yp,xgr,ygr,degres]=INPOLYMOLL(lonv,latv,degres)
%
% Finds the indices of a Mollweide grid that fall within a polygon
% defined by longitude and latitude pairs in degrees
%
% INPUT:
% 
% lonv,latv     Same-size arrays to define pairs of longitude and latitude
% degres        Degree resolution of the underlying grid [default: 1]
%
% OUTPUT:
%
% v             An index set that is plottable using PCOLOR
% xp,yp         The Mollweide coordinates of the polygon
% xgr,ygr       A Mollweide grid at the apppropriate resolution
% degres        Degree resolution of the underlying grid [default: 1]
%
% SEE ALSO:
%
% INPOLYCUBE
%
% EXAMPLE:
%
% inpolymoll('demo1')
% inpolymoll('demo2')
%
% Last modified by fjsimons-at-alum.mit.edu, 10/17/2021

% Wherever you keep coastlines etc
defval('ddir',fullfile(getenv('IFILES'),'COASTS'))

if ~isstr(lonv)
  % A default set of contours
  lon0=123; lat0=46; rad0=15; npt0=100;
  % Ouput first in spherical coordinates
  [lon1,lat1]=caploc([lon0 lat0],rad0,npt0,1);
  defval('lonv',lon1)
  defval('latv',lat1)
  defval('degres',1)

  % Convert these inputs to Mollweide coordinates
  [xp,yp]=mollweide(lonv*pi/180,latv*pi/180);

  % Now make the Mollweide grid coordinates with a certain degree resolution
  lon=linspace(    0,2*pi,2*pi/(degres*pi/180)+1);
  lat=linspace(-pi/2,pi/2,  pi/(degres*pi/180)+1);
  [longr,latgr]=meshgrid(lon,lat);
  [xgr,ygr]=mollweide(longr,latgr,pi);

  % Now see what's inside - needs adaptation for straddlining the
  % boundary - inside xbox and ybox - figure out boundary intersection
  % and then deal with it appropriately
  load(fullfile(ddir,'conm'))

  % Where are the jumps? 
  [~,~,~,p]=penlift(xp,yp);
  if length(p)==2
    % First piece
    xp1=[xp(p(2)+1:end) ; xp(1:p(1))];
    yp1=[yp(p(2)+1:end) ; yp(1:p(1))];
    v1=inpolybound(xgr,ygr,xp1,yp1,xbox,ybox,p);
    % Second piece, do the same thing
    xp2=xp(p(1)+1:p(2));
    yp2=yp(p(1)+1:p(2));
    v2=inpolybound(xgr,ygr,xp2,yp2,xbox,ybox,p);
    % Patch them together
    v=v1+v2;
  elseif length(p)==1
    % There is only one piece and we reassemble
    xp=[xp(p+1:end) ; xp(1:p)];
    yp=[yp(p+1:end) ; yp(1:p)];
    % But we need to offer the boundaries in a different way, not E/W but N/S
    % 1=ll 2=ul ; 3=ur ; 4=lr
    x1=xbox(1:size(xbox,1)/2,1);
    y1=ybox(1:size(ybox,1)/2,1);
    x2=xbox(size(xbox,1)/2+1:end,1);
    y2=ybox(size(ybox,1)/2+1:end,1);
    x3=xbox(1:size(xbox,1)/2,2);
    y3=ybox(1:size(ybox,1)/2,2);
    x4=xbox(size(xbox,1)/2+1:end,2);
    y4=ybox(size(ybox,1)/2+1:end,2);
    % for index=1:size(xbox,1); plot(xbox(index,1),ybox(index,1),'+'); hold on ; pause ; end
    % for index=1:size(xbox,2); plot(xbox(index,2),ybox(index,2),'+'); hold on ; pause ; end
    xbox=[[x4 ; x1] [x2 ; x3]];
    ybox=[[y4 ; y1] [y2 ; y3]];
    v=inpolybound(xgr,ygr,xp,yp,xbox,ybox,p);
  else
    v=inpolygon(xgr,ygr,xp,yp);
  end
  
  % Interior verification
  xver=0;
  if xver
    clf
    plot(xbox,ybox,'-') ; hold on
    pcolor(xgr,ygr,double(v)); shading flat
    [xp,yp]=penlift(xp,yp);
    plot(xp,yp,'-')
    axis image
  end
  
  % Variable output
  varns={v,xp,yp,xgr,ygr,degres};
  varargout=varns(1:nargout);
elseif strcmp(lonv,'demo1')
  % A bunch of handpicked ones
  lon0=353; lat0=46; rad0=15; npt0=100;
  [lon1,lat1]=caploc([lon0 lat0],rad0,npt0,1);
  [v1,xp1,yp1,xgr,ygr]=inpolymoll(lon1,lat1); 
  lon0=143; lat0=41; rad0=12; npt0=100;
  [lon2,lat2]=caploc([lon0 lat0],rad0,npt0,1);
  [v2,xp2,yp2]=inpolymoll(lon2,lat2);
  lon0=143; lat0=31; rad0=24; npt0=100;
  [lon3,lat3]=caploc([lon0 lat0],rad0,npt0,1);
  [v3,xp3,yp3]=inpolymoll(lon3,lat3);
  % Make the plot of the combined hitcounts
  pcolor(xgr,ygr,v1+v2+v3); shading flat
  hold on
  
  [xp1,yp1]=penlift(xp1,yp1);
  [xp2,yp2]=penlift(xp2,yp2);
  [xp3,yp3]=penlift(xp3,yp3);
  p{1}=plot(xp1,yp1);
  p{2}=plot(xp2,yp2); 
  p{3}=plot(xp3,yp3);
  plotcont([],[],2)
  plotplates([],[],2)
  hold off
  axis off image
  set(p{1}(:),'LineStyle','-')
  set(p{2}(:),'LineStyle','-')
  set(p{3}(:),'LineStyle','-')
elseif strcmp(lonv,'demo2')
  % A bunch of random ones
  nrand=100;
  lon0=rand(nrand,1)*360; lat0=90-rand(nrand,1)*180; rad0=rand(nrand,1)*20; npt0=100;
  
  [lonv,latv]=caploc([lon0 lat0],rad0,npt0,1);

  % Find the insides
  for index=1:size(lonv,2)
    % Next line for troubleshooting
    % disp(sprintf('lon0=%f; lat0=%f; rad0=%f;',lon0(index),lat0(index),rad0(index)))
    [v{index},xp(:,index),yp(:,index),xgr,ygr,degres]=inpolymoll(lonv(:,index),latv(:,index));
  end

  vv=sum(cat(3,v{:}),3);
  
  pcolor(xgr,ygr,vv); shading flat
  hold on
  for index=1:size(lonv,2)
    [xpp,ypp]=penlift(xp(:,index),yp(:,index));
    p{index}=plot(xpp,ypp,'k','LineWidth',1);
  end
  plotcont([],[],2)
%  plotplates([],[],2)
  hold off
  axis off
  set(p{1}(:),'LineStyle','-')
  set(p{2}(:),'LineStyle','-')
  set(p{3}(:),'LineStyle','-')
  axis image
  t=title(sprintf(...
      '%s for %i randomly distributed spherical patches\nMollweide resolution %4.2f%s  -  Maximum observed overlap %i',...
		  upper(mfilename),nrand,degres,str2mat(176),max(vv(:))));
  set(t,'FontWeight','normal')
  movev(t,0.1)
  text(1.65,-1.4,copyright,'FontSize',6)
  g=flipud(gray(1+max(vv(:)))); %g(1,:)=[1 1 1];
  colormap(g)
  % If you want a physical print
  figdisp([],sprintf('%3i',nrand),[],2)
end


% Function to include the boundary in polygon finding    
function v=inpolybound(xgr,ygr,xp,yp,xbox,ybox,p)
% Find the nearest boundary point to the first piece
% Watch out, these are Euclidean distances only to the defined points...
% Knowing that there are two distinct boundaries

xver=0;
if xver
  plot(xbox,ybox,'-'); hold on
  for index=1:size(xp,1); plot(xp(index),yp(index),'o'); hold on ; pause ; end
end

dxxp1=xxpdist([xp yp],[xbox(:,1) ybox(:,1)]);
dxxp2=xxpdist([xp yp],[xbox(:,2) ybox(:,2)]);
% Only one of them is the closest
[dmin1,i1]=min(dxxp1(:)); 
[dmin2,i2]=min(dxxp2(:)); 
% So you take the closest and that's your boundary now
if dmin1<dmin2
  i=i1; xb=xbox(:,1); yb=ybox(:,1); sized=size(dxxp1);
else
  i=i2; xb=xbox(:,2); yb=ybox(:,2); sized=size(dxxp2);
end
% The ith point on the curve is closest to the jth point on the boundary
[i1,j1]=ind2sub(sized,i);

% Finding anything but the first or last points is highly suspect, probably due to
% not sampling the boundary finely enough... may need to go further back
if i1==2
  i1=1;
end
if i1==length(xp)-1
  i1=length(xp);
end

% If it's not (first or) last you should reorder the curve from that beginning
if i1~=size(xp,1)
  xp=[xp(i1:end) ; xp(1:i1-1)];
  yp=[yp(i1:end) ; yp(1:i1-1)];
  % So you know the first point on the curve and its closest boundary
  i1=1;
  % Now you'll find the closest to the last point on the boundary
  i2=size(xp,1);
else
  % So you know the last point on the curve and its closest boundary
  % Now you'll find the closest to the first point on the boundary
  i2=1;
end

if xver
 plot(xp(i1),yp(i1),'+'); plot(xb(j1),yb(j1),'v')
end

% And then you have to find one more point
dxxp=xxpdist([xp(i2) yp(i2)],[xb yb]);
[dmin,j2]=min(dxxp(:));

if xver
 plot(xp(i2),yp(i2),'+'); plot(xb(j2),yb(j2),'^')
end

% And then you define the new polygon with the boundary segment
if j1<j2
  xb=xb(j1:j2);
  yb=yb(j1:j2);
else
  xb=xb(j2:j1);
  yb=yb(j2:j1);
end
% The flip orders the curve, might need to be conditioned on a penlift
xpp=[xp ; flipud(xb)];
ypp=[yp ; flipud(yb)];

if xver
 for index=1:size(xb,1); plot(xb(index),yb(index),'+'); hold on ; pause ; end
 for index=1:size(xpp,1); plot(xpp(index),ypp(index),'v'); hold on ; pause ; end
end

% Finally find where it's at
v=inpolygon(xgr,ygr,xpp,ypp);

if xver
  pcolor(xgr,ygr,double(v)); shading flat
end
