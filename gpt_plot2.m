clear; 
close all; 
clc; 

image_path = 'C:\Users\Colin\Documents\00 robotX\competition\image_heart.jpeg';

% Create a map axes
figure;
% Load the background image
img = imread(image_path); % Replace with your image file
[height, width, ~] = size(img);


% 27.378110, -82.455212

% top left
% Latitude: 27.378111
% Longitude: -82.455222

% bottom right
% Latitude: 27.372500
% Longitude: -82.449667

% Define the geographic limits that the image covers
latlim = [27.378111 27.372500]; % Replace with your image's latitude boundaries
lonlim = [-82.455222 -82.449667]; % Replace with your image's longitude boundaries


ax = axesm('mercator', 'MapLatLimit', latlim, 'MapLonLimit', lonlim);
setm(ax, 'FFaceColor', 'none'); % Make sure the map background is transparent

% Display the image as a background, using georeferenced coordinates
%hold on;
%geoshow(img, [latlim(1), latlim(2)], [lonlim(1), lonlim(2)]);


[x, y] = meshgrid(linspace(lonlim(1), lonlim(2), size(img, 2)), ...
                  linspace(latlim(1), latlim(2), size(img, 1)));
geoshow(y, x, img);

% Latitude and longitude coordinates for Nathan Benderson Park area
lat = [27.373877243020473, 27.3740470032047]; % Example coordinates
lon = [-82.45528349869997, -82.44689130642321]; % Example coordinates

% Create a map axes with north facing up and a proper map projection
%figure;
%ax = axesm('mercator', 'MapLatLimit', [27.35 27.40], 'MapLonLimit', [-82.46 -82.44]);
%ax = axesm('mercator', 'MapLatLimit', [27.377693 27.370835,], 'MapLonLimit', [-82.455255 -82.448399]);

%setm(ax, 'FFaceColor', [0.5 0.7 0.9]); % Set background color for water or map base
framem on; % Turn on the frame
gridm on; % Turn on the grid
mlabel on; % Show latitude labels
plabel on; % Show longitude labels





% Plot the latitude and longitude points (boundary points)
hold on;
scatterm(lat, lon); %  'ro-', 'LineWidth', 2, 

% Customize the map
title('Latitude and Longitude Plot for Nathan Benderson Park, Sarasota, FL');


bottom_bridge = [27.376118, -82.454486];
bottom_land = [27.372657, -82.452420]

scatterm(bottom_bridge(1), bottom_bridge(2), 2,  'blue'); %  'ro-', 'LineWidth', 2, 
scatterm(bottom_land(1), bottom_land(2),     2,  'blue'); %  'ro-', 'LineWidth', 2, 



% Origin point
origin_lat = 27.374958 ;
origin_lon = -82.454344; % point 1
origin_lat2 = 27.373877243020473; % point 2
origin_lat3 = 27.373333; % point 3


% Angles in degrees
% FTP A B C, STC A B C, DD A B C
angles_deg1 = [62 118 142 74 130 145 78 140 163];
angles_deg2 = [40 82  118 44 90  132 35 103 150];
angles_deg3 = [32 40  82  28 52  98  22 45  113];

angles_deg = [angles_deg1 angles_deg2 angles_deg3]; % combining all of the anlges

offset = 90; % ensures that 0 degrees is vertical
angles_rev = angles_deg * -1 + offset;
%angle_rad = deg2rad(angles_rev );

% Length of each line (in degrees of latitude/longitude, adjust as needed)
line_length = 0.005; % Roughly corresponds to about 1 km, depending on location

% Plot the origin point
plotm(origin_lat, origin_lon, 'bo', 'MarkerSize', 1, 'MarkerFaceColor', 'g');
plotm(origin_lat2, origin_lon, 'bo', 'MarkerSize', 1, 'MarkerFaceColor', 'g');
plotm(origin_lat3, origin_lon, 'bo', 'MarkerSize', 1, 'MarkerFaceColor', 'g');

x1_store = zeros(1,length(angles_rev)); 
x2_store = zeros(1,length(angles_rev));
y1_store = zeros(1,length(angles_rev));
y2_store = zeros(1,length(angles_rev));

% Draw lines at specified angles
for i = 1:length(angles_rev)
    if i <= 9
        plot_lat = origin_lat;
    elseif 9 < i && i <= 18
        %disp('changed')
        plot_lat = origin_lat2;
    else
        plot_lat = origin_lat3;
    end
    
    % i;
    % plot_lat;
    
    % Convert angle to radians
    angle_rad = deg2rad(angles_rev(i));
    %angle_rad(i)

    % Calculate the end point of the line
    end_lat = plot_lat + line_length * sind(angles_rev(i)); % Adjusts latitude
    %end_lon = origin_lon + line_length * cosd(angles_rev(i)); % Adjusts longitude
    end_lon = origin_lon + line_length * cosd(angles_rev(i)); % Adjusts longitude

    % Plot the line

    plotm([plot_lat, end_lat], [origin_lon, end_lon], 'r-', 'LineWidth', 0.5, 'Color','g');
    
    % storage 
    x1_store(i) = plot_lat;
    x2_store(i) = end_lat;
    y1_store(i) = origin_lon;
    y2_store(i) = end_lon;

end
colors = [
    0.0000, 0.4470, 0.7410; % Blue
    0.8500, 0.3250, 0.0980; % Red-Orange
    0.9290, 0.6940, 0.1250; % Yellow
    0.4940, 0.1840, 0.5560; % Purple
    0.4660, 0.6740, 0.1880; % Green
    0.3010, 0.7450, 0.9330; % Cyan
    0.6350, 0.0780, 0.1840; % Dark Red
    0.0000, 0.0000, 0.0000; % Black
    0.8500, 0.8500, 0.8500; % Light Gray
];

point_ss = []
for gg = 1:length(angles_deg1) 
    i = 0;
    j = 9;
    k = 18;
    
    line1 = [x1_store(gg + i),x2_store(gg + i),y1_store(gg + i),y2_store(gg+ i)];
    line2 = [x1_store(gg + j),x2_store(gg + j),y1_store(gg + j),y2_store(gg+ j)];
    line3 = [x1_store(gg + k),x2_store(gg + k),y1_store(gg + k),y2_store(gg+ k)];
    
    [intersect_lon, intersect_lat] = findIntersection(line1, line2);
    intersections = [intersect_lat, intersect_lon];
    point_s = scatterm(intersect_lat, intersect_lon, 5, colors(gg,:), 'filled', 'DisplayName', 'Intersection');
    point_ss = [point_ss, point_s]
    [intersect_lon, intersect_lat] = findIntersection(line1, line3);
    %intersections = [intersect_lat, intersect_lon];
    scatterm(intersect_lat, intersect_lon, 5, colors(gg,:), 'filled', 'DisplayName', 'Intersection');
end
hold off;

legendHandles = point_ss(1:2:end)
legendLabels = [...
    "FTP A"
    "FTP B"
    "FTP C"
    "STC A"
    "STC B"
    "STC C"
    "DND A"
    "DND B"
    "DND C"
    ]
legend(point_ss, legendLabels);

% You can also zoom interactively by calling:
zoom on; % This allows you to use the mouse to zoom in/out

% Helper function to find intersection between two lines
function [lat, lon] = findIntersection(line1, line2)
    % Extract points from the two lines
    x1 = line1(1); y1 = line1(3);
    x2 = line1(2); y2 = line1(4);
    x3 = line2(1); y3 = line2(3);
    x4 = line2(2); y4 = line2(4);

    % Line intersection formula
    denom = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4);
    if denom == 0
        % Lines are parallel, no intersection
        lat = [];
        lon = [];
        return;
    end
    
    intersect_x = ((x1 * y2 - y1 * x2) * (x3 - x4) - (x1 - x2) * (x3 * y4 - y3 * x4)) / denom;
    intersect_y = ((x1 * y2 - y1 * x2) * (y3 - y4) - (y1 - y2) * (x3 * y4 - y3 * x4)) / denom;

    % Return intersection point
    lat = intersect_y;
    lon = intersect_x;
end