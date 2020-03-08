% Copyright 2016 The MathWorks, Inc.

% WMS servers
url1 = 'http://raster.nationalmap.gov/arcgis/services/Orthoimagery/USGS_EROS_Ortho/ImageServer/WMSServer?';
url2 = 'http://geoint.nrlssc.navy.mil/osm/wms/OSM/basemap/Mapnik/OSM_BASEMAP?';

% Latitude and Longitude ranges
lim.lat = [40.6857 40.8061];                            % limit lat to NYC                         
lim.lon = [-74.0743 -73.8577];                          % limit lon to NYC

% Image dimension
img.h = 420 * 2;                                        % set image height
img.w = 560 * 2;                                        % set image width

% Landmarks
lmk1.lat = [40.7619284,40.7527262,40.7418804,40.7233578,40.7057831];
lmk1.lon = [-73.9750497,-73.9772294,-73.9936086,-73.9977205,-74.0119842];
lmk1.str = {'Tiffany','Grand Central Station','Empire State Bldg', ...
    'Soho','Wall Street'};

lmk2.lat = [40.7785839,40.7577854,40.7505709,40.7408444,40.7150773];
lmk2.lon = [-73.9651738,-73.978739,-73.9951074,-74.0053217,-74.0142849];
lmk2.str = {{'Metropolitan','Museum'},{'Saks','Fifth','Ave'}, ... 
    {'Penn','Station'},'Chelsea','Tribeca'};

% Data Aspect ratio for New York
nyc_lat = 40.7;                                         % NYC's latitude
dar = [1, cosd(nyc_lat), 1];                            % compute ratio

% generate a clock face
cir.ctr = [40.7890145,-74.049522];                      % center
cir.r = .015;                                           % radius
[cir.lat, cir.lon] = scircle1( ...                      % create circle
    cir.ctr(1),cir.ctr(2), cir.r);

% generate clock handles
hours = 0:23;                                           % hours
angles = 90 - hours*(360/12);                           % hour handle angles
rads = angles*pi/180;                                   % angles to radians

hr = cir.r * 0.8;                                       % hour handle legnth
mr = cir.r * 0.9;                                       % min handle length

hour.x = ones(24,2) * cir.ctr(2);                       % hour handle end
hour.x(:,2) = hr*cos(rads)' + cir.ctr(2);               % the other end
hour.y = ones(24,2) * cir.ctr(1);                       % hour handle end
hour.y(:,2) = hr*sin(rads)' + cir.ctr(1);               % the other end
min.x = [cir.ctr(2) mr*cos(rads(1))' + cir.ctr(2);];    % min handle
min.y = [cir.ctr(1) mr*sin(rads(1))' + cir.ctr(1);];    % min handle

clearvars angles ans ds hours hr mr nyc_lat rads