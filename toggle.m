clear;
close all;
clc;

% Path to the image
image_path = 'C:\Users\Colin\Documents\00 robotX\competition\image_heart.jpeg';

% Load and display background image
figure;
img = imread(image_path);
[height, width, ~] = size(img);

% Geographic boundaries
latlim = [27.378111 27.372500];
lonlim = [-82.455222 -82.449667];

% Create map axes
ax = axesm('mercator', 'MapLatLimit', latlim, 'MapLonLimit', lonlim);
setm(ax, 'FFaceColor', 'none');
framem on;
gridm on;
mlabel on;
plabel on;

% Display the image with georeferenced coordinates
[x, y] = meshgrid(linspace(lonlim(1), lonlim(2), size(img, 2)), linspace(latlim(1), latlim(2), size(img, 1)));
geoshow(y, x, img);

title('Latitude and Longitude Plot for Nathan Benderson Park, Sarasota, FL');

% Coordinates for points of interest
points_of_interest = [
    27.374958, -82.454344; % Origin 1
    27.373877243020473, -82.454344; % Origin 2
    27.373333, -82.454344; % Origin 3
];

% Plot points of interest
hold on;
scatterm(points_of_interest(:, 1), points_of_interest(:, 2), 1, 'g');

% Angles in degrees for each point
angles_deg = {
    [62 118 142 74 130 145 78 140 163],
    [40 82 118 44 90 132 35 103 150],
    [32 40 82 28 52 98 22 45 113]
};

angles_vertical = [180 180 180 180 180 180]
points_of_vertical = [
    27.377768,  -82.453263; % Origin 1
    27.377610,  -82.453176; % Origin 2
    27.377617,  -82.453085; % Origin 3
    27.377610,  -82.452906;
    27.377645,  -82.453660;
    27.377617,  -82.453588;
];

% Adjust angles
offset = 90;
angles_vert_rev = angles_vertical * -1 + offset;


% boundaries alpha
boundaries_alpha = [
-82.45274,	-82.45373,	-82.45374,	-82.45273;
27.37550,	27.37552,	27.37472,	27.37477;  
];

b_lat = [boundaries_alpha(2,:) boundaries_alpha(2,1)];
b_lon = [boundaries_alpha(1,:) boundaries_alpha(1,1)];

plotm(b_lat,b_lon,'magenta')

boundaries_beta = [
-82.45267	-82.45374	-82.45374	-82.45264;
27.37455	27.37452	27.37372	27.37379;
];

b_lat = [boundaries_beta(2,:) boundaries_beta(2,1)];
b_lon = [boundaries_beta(1,:) boundaries_beta(1,1)];

plotm(b_lat,b_lon,'magenta')

boundaries_charlie = [
-82.45263	-82.45374	-82.45372	-82.45265;
27.37371	27.37366	27.37288	27.37291;
];

b_lat = [boundaries_charlie(2,:) boundaries_charlie(2,1)];
b_lon = [boundaries_charlie(1,:) boundaries_charlie(1,1)];

plotm(b_lat,b_lon,'magenta')

% Adjust angles
offset = 90;
angles_rev = cellfun(@(x) x * -1 + offset, angles_deg, 'UniformOutput', false);

% Line length
line_length = 0.01;

% drawwing vertical lines
for p = 1:size(points_of_vertical, 1)
    origin_lat = points_of_vertical(p, 1);
    origin_lon = points_of_vertical(p, 2);
    %angles = angles_vert_rev(p);
    
    angle_rad = deg2rad(angles_vert_rev(p));
    end_lat = origin_lat + line_length * sind(angles_vert_rev(p));
    end_lon = origin_lon + line_length * cosd(angles_vert_rev(p));
    
    h = plotm([origin_lat, end_lat], [origin_lon, end_lon], 'r-', 'LineWidth', 2, 'Color', 'g');
    
end

% Store coordinates for all points
x1_store = [];
x2_store = [];
y1_store = [];
y2_store = [];

% Draw lines for each point of interest
line_handles = [];
for p = 1:size(points_of_interest, 1)
    origin_lat = points_of_interest(p, 1);
    origin_lon = points_of_interest(p, 2);
    angles = angles_rev{p};
    
    for i = 1:length(angles)
        angle_rad = deg2rad(angles(i));
        end_lat = origin_lat + line_length * sind(angles(i));
        end_lon = origin_lon + line_length * cosd(angles(i));
        
        h = plotm([origin_lat, end_lat], [origin_lon, end_lon], 'r-', 'LineWidth',2, 'Color', 'g');
        line_handles = [line_handles, h];
        
        x1_store = [x1_store, origin_lat];
        x2_store = [x2_store, end_lat];
        y1_store = [y1_store, origin_lon];
        y2_store = [y2_store, end_lon];
    end
end

% Define colors for points
colors = [
    0.0000, 0.4470, 0.7410;
    0.8500, 0.3250, 0.0980;
    0.9290, 0.6940, 0.1250;
    0.4940, 0.1840, 0.5560;
    0.4660, 0.6740, 0.1880;
    0.3010, 0.7450, 0.9330;
    0.6350, 0.0780, 0.1840;
    0.0000, 0.0000, 0.0000;
    0.8500, 0.8500, 0.8500;
];

% Plot intersections
point_ss = [];
for gg = 1:length(angles_deg{1})
    for p = 1:size(points_of_interest, 1) - 1
        line1 = [x1_store(gg + (p-1) * length(angles_deg{1})), x2_store(gg + (p-1) * length(angles_deg{1})), y1_store(gg + (p-1) * length(angles_deg{1})), y2_store(gg + (p-1) * length(angles_deg{1}))];
        line2 = [x1_store(gg + p * length(angles_deg{1})), x2_store(gg + p * length(angles_deg{1})), y1_store(gg + p * length(angles_deg{1})), y2_store(gg + p * length(angles_deg{1}))];
        
        [intersect_lon, intersect_lat] = findIntersection(line1, line2);
        point_s = scatterm(intersect_lat, intersect_lon, 5, colors(gg, :), 'filled', 'DisplayName', 'Intersection');
        point_ss = [point_ss, point_s];
    end
end

% Add button for toggling green lines
%uicontrol('Style', 'togglebutton', 'String', 'Toggle Lines', 'Position', [20 20 100 30], 'Callback', @(src, event) toggleLines(src, line_handles));

% Add legend
legendHandles = point_ss(1:2:end);
legendLabels = [
    "FTP A"; "FTP B"; "FTP C";
    "STC A"; "STC B"; "STC C";
    "DND A"; "DND B"; "DND C"
];
legend(legendHandles, legendLabels);

% Enable interactive zoom
zoom on;

% Enable interactive clicking to get coordinates
disp('Click on the map to get latitude and longitude coordinates. Press Enter to stop.');
counter = 1;
while true
    [x, y] = ginput(1);
    if isempty(x)
        break;
    end
    [lat, lon] = minvtran(x, y);
    point_s = scatterm(lat, lon,4, 'red');
    legendLabels = [legendLabels; {sprintf('Lat: %.6f, Lon: %.6f', lat, lon)}];
    point_ss = [point_ss, point_s];
    legendHandles = [point_ss(1:2:end- counter), point_s];

    legend(legendHandles, legendLabels);
    fprintf('Latitude, Longitude, %.6f,  %.6f', lat, lon);
    counter = counter + 1;
end

% Intersection function
function [lat, lon] = findIntersection(line1, line2)
    x1 = line1(1); y1 = line1(3);
    x2 = line1(2); y2 = line1(4);
    x3 = line2(1); y3 = line2(3);
    x4 = line2(2); y4 = line2(4);

    denom = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4);
    if denom == 0
        lat = [];
        lon = [];
        return;
    end
    
    intersect_x = ((x1 * y2 - y1 * x2) * (x3 - x4) - (x1 - x2) * (x3 * y4 - y3 * x4)) / denom;
    intersect_y = ((x1 * y2 - y1 * x2) * (y3 - y4) - (y1 - y2) * (x3 * y4 - y3 * x4)) / denom;

    lat = intersect_y;
    lon = intersect_x;
end

% Toggle visibility function
function toggleLines(src, line_handles)
    if get(src, 'Value')
        set(line_handles, 'Visible', 'on');
    else
        set(line_handles, 'Visible', 'off');
    end
end
