function varargout=loris1(N,eo,lon,lat,sc,fax,opt,ostat,omap,L)
% pstat=LORIS1(N,eo,lon,lat,sc,fax,opt,ostat,omap,L)
%
% Makes a cute plot of the cubed sphere in three-dimensional space.
%
% INPUT:
%
% N        The power of the dyadic subdivision [defaulted]
% eo       0 even number of points [default]
%          1 odd number of points
% lon,lat  The location of the viewing platform [defaulted]
% sc       0 regular cubed sphere [default]
%          1 superchunk cubed sphere
% fax      Axis scaling [defaulted]
% opt      Sets lon,lat view axis input if that had been left empty, to
%          'GJI2011' as published in doi: 10.1111/j.1365-246X.2011.05190.x
%          'SPIE2011' as published in doi: 10.1117/12.892285
%          'POLYNESIA' centered on Polynesia
%          'Zweeloo' centered on Jeroen Tromp's hometown
%          'lucia' to work on WaveWatch type things
% ostat    Some [lon,lat] coordinates that will be plotted as points
% omap     A (nearly) global field you may want rendered as well
%          omap.lat a Nx1 vector of latitudes [degrees]
%          omap.lon a Mx1 vector of longitudes [degrees]
%          omap.pv  a MxN matrix of values [ocean noise or whatever]
% L        a scalar with maximum spherical harmonic degree
%
% OUTPUT:
%
% pstat    The handles to the plotted OSTAT points
%
% EXAMPLE:
%
% load ~/POSTDOCS/ThomasLee/OCEAN_WAVE_MODEL/20100101_9s.mat
% loris1(5,[],[],[],0,[],'lucia',omap,[],[]);
%
% Tested on 8.3.0.532 (R2014a) and 9.0.0.341360 (R2016a)
% Last modified by fjsimons-at-alum.mit.edu, 12/19/2024

% Set the defaults
defval('N',4)
defval('opt','Zweeloo')
defval('ostat',[])

switch opt
 case 'GJI2011'
  defval('lon',-40)
  defval('lat',65)
  defval('fax',0.8)
 case 'SPIE2011'
  defval('lon',30)
  defval('lat',-5)
  defval('fax',1)
 case 'POLYNESIA'
  defval('lon',210.427)
  defval('lat',-17.559)
  defval('fax',1)
 case 'GUYOT'
  defval('lon',-74.6548)
  defval('lat',40.3458)
  defval('fax',1)
 case 'Zweeloo'
  defval('lon',6.733)
  defval('lat',52.8)
  defval('fax',1)
  % Set the cubed sphere to something good
  alfa=0.3;
  bita=0.5;
  gama=2.6;
 case 'lucia'
  defval('lon',332)
  defval('lat',15)
  defval('fax',1)
  % Set the cubed sphere to something good
  %  alfa=[-30]*pi/180;
  % To a desired latitude (remember original reference is at equator, i.e. not
  % as in PLM2ROT)
  bita=-pi*(lat-90)/180;
  % To a desired longitude
  gama=pi*(180-lon)/180;
  % Plot more stations, from ds.iris.edu
  TAM= [ 5.5284 22.7915];
  PAB= [-4.3499 39.5446];
  BBSR=[-64.696 32.3713];
  defval('ostat',[TAM; PAB; BBSR])
end

defval('actprint',0)
defval('eo',0)
defval('sc',0)

% Cubed-sphere defaults
defval('alfa',0.2);
defval('bita',0.9);
defval('gama',1);

% Create the cubed sphere
Nor=N;
[x,y,z,J,N]=cube2sphere(N,alfa,bita,gama,eo,0);

if sc==1
  % Create the superchunk sphere and reassign N
  [x2,y2,z2,J,N2]=cube2sphere(Nor*2,alfa,bita,gama,eo,1);
end

clf
% Set view angles ahead of time as an explicit longitude and latitude
[xv,yv,zv]=sph2cart(lon*pi/180,lat*pi/180,1);

if ~isempty(omap)
    % Maybe also plot some actual global field
    [LON,LAT]=meshgrid(omap.lon,omap.lat);
    % To be seen
    omap.pv(isnan(omap.pv))=min(min(omap.pv));
    omap.pv=[omap.pv]';
    % Must treat like irregular spacing
    lmcosi=xyz2plm(omap.pv(:),L,[],LAT(:),LON(:));
    % Verify if you want
    % plotplm(lmcosi1,[],[],4)
    % The cubed sphere expansion
    v=plm2cube(lmcosi,log(N)/log(2),alfa,bita,gama);
    plotoncube(v,'3D',1,x,y,z)
    axis image
end

if ~isempty(omap); hold on; end

% Plot the visible continents, which depends on the view angle
[a,h,XYZ]=plotcont([0 90],[360 -90],3); delete(h);

if ~isempty(omap); hold on; end

% Inner product selectivity
yes=[xv yv zv]*XYZ'>0; XYZ=XYZ(yes,1:3);
% This protection from jumps is straight from PLOTCONT
xx=XYZ(:,1); yy=XYZ(:,2); zz=XYZ(:,3);
d=sqrt((xx(2:end)-xx(1:end-1)).^2+(yy(2:end)-yy(1:end-1)).^2);
dlev=3; pp=find(d>dlev*nanmean(d));
nx=insert(xx,NaN,pp+1); ny=insert(yy,NaN,pp+1); nz=insert(zz,NaN,pp+1); 
% And then finally do it
skl=0.99;
pc=plot3(nx(:)*skl,ny(:)*skl,nz(:)*skl,'k-');
hold on

% Plot a single "main" face, all visible
% Don't do mesh as this is not see-through
% pm=mesh(x(:,:,1),y(:,:,1),z(:,:,1),ones(N,N),'edgecolor','k');
if sc==0
  % Figure out in what panel lies the center view point
  [~,~,mf]=sphere2cube(lon,lat,alfa,bita,gama);
  horz=[x(:,:,mf)  y(:,:,mf)  z(:,:,mf) ];
  vert=[x(:,:,mf)' y(:,:,mf)' z(:,:,mf)'];
  pm=plot3(horz(:,1:N),horz(:,N+1:2*N),horz(:,2*N+1:3*N),'k');
  um=plot3(vert(:,1:N),vert(:,N+1:2*N),vert(:,2*N+1:3*N),'k');
end

% Then plot the ribs only
for ind=1:6
  % These will be the lines plotted, with some redundancy
  horz=[x(:,[1 N],ind)  y(:,[1 N],ind)  z(:,[1 N],ind) ];
  vert=[x([1 N],:,ind)' y([1 N],:,ind)' z([1 N],:,ind)'];
  % But restrict them to the viewable area
  horz(repmat(reshape([xv yv zv]*[reshape(horz,2*N,[])]'<0,N,2),1,3))=NaN;
  vert(repmat(reshape([xv yv zv]*[reshape(vert,2*N,[])]'<0,N,2),1,3))=NaN; 
  % Then plot them for real
  p{ind}=plot3(horz(:,1:2),horz(:,3:4),horz(:,5:6),'k');
  u{ind}=plot3(vert(:,1:2),vert(:,3:4),vert(:,5:6),'k');
end

if sc==1
  % Now hold on and plot the superchunk ribs also
  x=x2; y=y2; z=z2; N=N2;
  for ind=1:6
    % These will be the lines plotted, with some redundancy
    horz=[x(:,[1 N],ind)  y(:,[1 N],ind)  z(:,[1 N],ind) ];
    vert=[x([1 N],:,ind)' y([1 N],:,ind)' z([1 N],:,ind)'];
    % But restrict them to the viewable area
    horz(repmat(reshape([xv yv zv]*[reshape(horz,2*N,[])]'<0,N,2),1,3))=NaN;
    vert(repmat(reshape([xv yv zv]*[reshape(vert,2*N,[])]'<0,N,2),1,3))=NaN; 
    % Then plot them for real
    p2{ind}=plot3(horz(:,1:2),horz(:,3:4),horz(:,5:6),'k');
    u2{ind}=plot3(vert(:,1:2),vert(:,3:4),vert(:,5:6),'k');
  end
end

if ~isempty(ostat)
    % Do stations individually
    [xs,ys,zs]=sph2cart(ostat(:,1)*pi/180,ostat(:,2)*pi/180,1);
    for index=1:size(ostat,1)
        pstat(index)=plot3(xs(index),ys(index),zs(index),'o');
    end
    set(pstat,'MarkerFaceColor','k','MarkerEdgeColor','k')
    t=title(sprintf('lon %g lat %g\n%s %g %s %g %s %g',lon,lat,...
                  '\alpha',alfa*180/pi,...
                  '\beta',bita*180/pi,...
                    '\gamma',gama*180/pi));
end

% Now set (and verify the syntax) of the view 
view([xv,yv,zv]); [AZ,EL]=view;
disp(sprintf('Azimuth: %i ; Elevation: %i',round(AZ),round(EL)))

% And now plot an entire equatorial circle also
[xe,ye,ze]=sph2cart(linspace(0,2*pi,100),0,1);
xyze=[rotz(-lon*pi/180)*roty(-[90-lat]*pi/180)*[xe ; ye ; repmat(ze,1,length(ye))]]';
peq=plot3(xyze(:,1),xyze(:,2),xyze(:,3),'k');

% Cosmetics
% Change all of their colors
set(pc,'Color',grey,'LineW',1)
if ~isempty(omap)
    set(pc,'Color','w','LineWidth',2)
    caxis([-3 2])
end
set(cat(1,p{:}),'Color','k','LineW',1)
set(cat(1,u{:}),'Color','k','LineW',1)
if sc==1
  set(cat(1,p2{:}),'Color','b','LineW',0.5)
  set(cat(1,u2{:}),'Color','b','LineW',0.5)
  % Save money for SPIE
  set(cat(1,p2{:}),'Color',grey,'LineW',0.5,'LineS','-')
  set(cat(1,u2{:}),'Color',grey,'LineW',0.5,'LineS','-')
end
% set(pm,'EdgeColor','k','LineW',0.5)
if sc==0
  set(pm,'Color','k','LineW',0.5)
  set(um,'Color','k','LineW',0.5)
  if ~isempty(omap)
      set(um(1),'LineWidth',2);
      set(um(end),'LineWidth',2);
      set(pm(1),'LineWidth',2);
      set(pm(end),'LineWidth',2);
  end
end
set(peq,'Color','k','LineW',1)

fig2print(gcf,'portrait')

axis equal; axis([-1 1 -1 1 -1 1]*fax);
xl=xlabel('x'); yl=ylabel('y'); zl=zlabel('z');
set(gca,'xtick',[-fax 0 fax],'ytick',[-fax 0 fax],'ztick',[-fax 0 fax])
moveh(xl,-0.55); movev(xl,0.15)
moveh(yl,-0.2); movev(yl,0.2)
moveh(zl,-0.1); movev(zl,0.1)
axis off
% As if the next line did anything - it doesn't
bottom(pc,gca)

% Where is the North Pole?
hold on
pnp=plot3(0,0,1,'MarkerF','k','MarkerE','k','Marker','o');
delete(pnp)
hold off
% Where is the Viewing Axis?
hold on
pnp=plot3(xv,yv,zv,'MarkerF','k','MarkerE','k','Marker','o');
delete(pnp)
hold off

% Print it out
figna=figdisp([],sprintf('%s_%i',opt,sc),'-painters',actprint);

