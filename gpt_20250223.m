%% Initialization and Loading Data
clear; close all; clc;
format longg

% Define the image path and load the background image
% (uncomment your preferred image)
% image_path = 'C:\Users\Colin\Documents\00 robotX\competition\image_heart.jpeg';
% image_path = 'C:\Users\Colin\Documents\00 robotX\competition\mirimar_bound.png';
% img = imread(image_path);
% [imgHeight, imgWidth, ~] = size(img);
% 
% % Define geographic boundaries (latitudes and longitudes)
% latlim = [32.916009, 32.913393];
% lonlim = [-117.102201, -117.099516];

image_path = 'C:\Users\Colin\Documents\00 robotX\competition\abby_bound.png';
latlim = [32.924198, 32.923938];
lonlim = [ -117.039175,-117.037906];
img = imread(image_path);
[imgHeight, imgWidth, ~] = size(img);

% Pre-compute the grid for the background image
[x, y] = meshgrid(linspace(lonlim(1), lonlim(2), imgWidth), ...
                  linspace(latlim(1), latlim(2), imgHeight));

% Load CSV data: columns 1: latitude, 2: longitude, 3: heading (in degrees)
%load('abbywood_20250223.csv')  % Assumes the file loads a variable 'abbywood_20250223'
dat_points = load('abby_square_20250223.csv');

% (Optional) If you want to use the CSV data directly as points of interest:
% points_of_interest = [abbywood_20250223(:,1), abbywood_20250223(:,2)];

%% Set arrow parameters
% Define a scale for the arrow length (adjust as needed)
arrowScale = (lonlim(2)-lonlim(1)) / 10;  % Example: 1/10th of the longitude span

%% Loop over each point and save an image with the heading vector
numPoints = size(dat_points, 1);
for i = 1:numPoints
    % Extract current point and heading
    currentLat = dat_points(i, 1);
    currentLon = dat_points(i, 2);
    heading   = dat_points(i, 3);
    
    % Calculate vector components for the arrow.
    % Assuming heading is in degrees clockwise from north:
    % The change in latitude (dLat) is proportional to cos(heading)
    % and the change in longitude (dLon) is proportional to sin(heading)
    dLat = arrowScale * cosd(heading);
    dLon = arrowScale * sind(heading);
    
    % Create a new figure and set up the map axes
    figure;
    ax = axesm('mercator', 'MapLatLimit', latlim, 'MapLonLimit', lonlim);
    setm(ax, 'FFaceColor', 'none');
    framem on;
    gridm on;
    mlabel on;
    plabel on;
    
    % Display the background image with georeferenced coordinates
    geoshow(y, x, img);
    hold on;
    
    % Plot the current point (red circle)
    scatterm(currentLat, currentLon, 30, 'r', 'filled');
    
    % Overlay the heading vector using quiverm
    % quiverm(lat, lon, dLat, dLon, SCALE, ...) with SCALE=0 to disable automatic scaling.
    quiverm(currentLat, currentLon, dLat, dLon, 0, 'b', 'LineWidth', 2);
    
    % Add a title with the point number and heading
    title(sprintf('Point %d: Heading %.2f°', i, heading));
    
    % Save the figure as a PNG image
    filename = sprintf('point_%d.png', i);
    saveas(gcf, filename);
    
    % Close the figure to avoid too many open windows
    close(gcf);
end
