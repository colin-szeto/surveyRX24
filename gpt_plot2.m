clear; 
close all; 
clc; 

% Latitude and longitude coordinates for Nathan Benderson Park area
lat = [27.373877243020473, 27.3740470032047]; % Example coordinates
lon = [-82.45528349869997, -82.44689130642321]; % Example coordinates

% Create a map axes with north facing up and a proper map projection
figure;
ax = axesm('mercator', 'MapLatLimit', [27.35 27.40], 'MapLonLimit', [-82.46 -82.44]);
setm(ax, 'FFaceColor', [0.5 0.7 0.9]); % Set background color for water or map base
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

plotm(bottom_bridge(1), bottom_bridge(2), 'ro-', 'LineWidth', 2, 'MarkerSize', 1, 'MarkerFaceColor', 'r');
plotm(bottom_land(1), bottom_land(2), 'ro-', 'LineWidth', 2, 'MarkerSize', 1, 'MarkerFaceColor', 'r');



% Origin point
origin_lat = 27.374958 ;
origin_lon = -82.454344; % point 1
origin_lat2 = 27.373877243020473; % point 2
origin_lat3 = 27.3740470032047; % point 3


% Angles in degrees
% FTP A B C, STC A B C, DD A B C
angles_deg1 = [62 118 142 74 130 145 78 140 163];
angles_deg2 = [40 118 82  44 90  132 35 103 150];
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

for gg = 1:length(angles_deg1) 
    i = 0;
    j = 9;
    k = 18;
    
    line1 = [x1_store(gg + i),x2_store(gg + i),y1_store(gg + i),y2_store(gg+ i)];
    line2 = [x1_store(gg + j),x2_store(gg + j),y1_store(gg + j),y2_store(gg+ j)];
    line3 = [x1_store(gg + k),x2_store(gg + k),y1_store(gg + k),y2_store(gg+ k)];
    
    [intersect_lon, intersect_lat] = findIntersection(line1, line2);
    intersections = [intersect_lat, intersect_lon];
    scatterm(intersect_lat, intersect_lon, 5, 'red', 'filled', 'DisplayName', 'Intersection');
    
    [intersect_lon, intersect_lat] = findIntersection(line1, line3);
    %intersections = [intersect_lat, intersect_lon];
    scatterm(intersect_lat, intersect_lon, 5, 'yellow', 'filled', 'DisplayName', 'Intersection');
end
hold off;


% Find intersections between the lines
% num_lines = length(angles_deg);
% intersections = [];
% for i = 1:num_lines-1
%     for j = i+1:num_lines
%         % Extract the end points of the lines
%         line1 = [x1_store(i), x2_store(i); y1_store(i), y2_store(i)];
%         line2 = [x1_store(j), x2_store(j); y1_store(j), y2_store(j)];
%         
%         % Find intersection using a helper function
%         [intersect_lat, intersect_lon] = findIntersection(line1, line2);
%         
%         if ~isempty(intersect_lat)
%             % Store intersection points
%             intersections = [intersections; intersect_lat, intersect_lon];
%             
%             % Plot intersection points
%             scatterm(intersect_lat, intersect_lon, 70, 'red', 'filled', 'DisplayName', 'Intersection');
%         end
%     end
% end

%for i = 1:length(angles_deg1)
%    [intersect_lat, intersect_lon] = findIntersection([x1_store(i), x2_store(i); y1_store(i), y2_store(i)],...
%        [x1_store(i+9), x2_store(i+9); y1_store(i+9), y2_store(i+9)])
%
%     scatterm(intersect_lat, intersect_lon, 5, 'red', 'filled', 'DisplayName', 'Intersection');
%end




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