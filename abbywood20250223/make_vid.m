% Define parameters for the video
outputVideoFile = 'output_video.mp4';  % Output video file name
frameRate = 10;                        % Frames per second

% Create a VideoWriter object for MP4 output
v = VideoWriter(outputVideoFile, 'MPEG-4');
v.FrameRate = frameRate;
open(v);

% Loop over the images from point_1.png to point_177.png
for i = 1:177
    % Create the filename using sprintf
    filename = sprintf('point_%d.png', i);
    
    % Check if the file exists (optional)
    if exist(filename, 'file')
        % Read the image
        img = imread(filename);
        
        % Write the frame to the video
        writeVideo(v, img);
    else
        warning('File %s does not exist. Skipping...', filename);
    end
end

% Finalize the video file
close(v);
