import smopy
import numpy as np
import matplotlib.pyplot as plt
from matplotlib.patches import Polygon
from pathlib import Path

# Image path
image_path = Path(r"C:\Users\Colin\Documents\00 robotX\competition\image_heart.jpeg")

# Geographic boundaries
latlim = [27.378111, 27.372500]
lonlim = [-82.455222, -82.449667]

# Load map using smopy
zoom = 17  # Adjust zoom level as needed
map_obj = smopy.Map((latlim[0], lonlim[0], latlim[1], lonlim[1]), z=zoom)

# Convert latitude/longitude points to pixel coordinates
def latlon_to_pixels(lat, lon):
    x, y = map_obj.to_pixels(lat, lon)
    return x, y

# Create figure
fig, ax = plt.subplots(figsize=(8, 8))
ax.imshow(map_obj.to_numpy(), extent=[0, map_obj.w, map_obj.h, 0])

# Points of interest (latitude, longitude)
points_of_interest = np.array([
    #[27.374887, -82.452340],  # Below road    
    #[27.375603, -82.452284],  # White road
    #[27.376269, -82.452381]   # Top northwest corner
    [27.376097, -82.452812],#Red Edge Buoy#1
    [27.376097, -82.452912],#Red Edge Buoy#2
    [27.376097, -82.45305],#Red Edge Buoy#3
    [27.376097, -82.453198],#Red Edge Buoy#4
    [27.376097, -82.453285],#Red Edge Buoy#5
    [27.376097, -82.453431],#Red Edge Buoy#6
    [27.376097, -82.453517],#Red Edge Buoy#7
    [27.376097, -82.453684],#Red Edge Buoy#8
    [27.376097, -82.453822],#Red Edge Buoy#9
    [27.376097, -82.453965],#Red Edge Buoy#10


   # [27.374784, -82.452445],
   # [27.374706, -82.452445], 
   # [27.374636, -82.452445],
   # [27.374547, -82.453445],

    
    
    
])

# Convert points to pixel coordinates
poi_pixels = np.array([latlon_to_pixels(lat, lon) for lat, lon in points_of_interest])
ax.scatter(poi_pixels[:, 0], poi_pixels[:, 1], c='g', s=10, label="Points of Interest")

# Boundaries (each row is a set of lon/lat points)
boundaries_alpha = np.array([
    [-82.452467, -82.452441, -82.45374, -82.45273],
    [27.375102, 27.374394, 27.37472, 27.37477]
])

#boundaries_beta = np.array([
#    [-82.45268, -82.45265, -82.45375, -82.45374],
#    [27.37455, 27.37377, 27.37371, 27.37452]
#])

#boundaries_charlie = np.array([
 #   [-82.45268, -82.45265, -82.45375, -82.45374],
  #  [27.37455, 27.37377, 27.37371, 27.37452]
#])

# Function to plot boundary regions
def plot_boundary(ax, boundary, color, linestyle="-"):
    pixels = np.array([latlon_to_pixels(lat, lon) for lat, lon in zip(boundary[1], boundary[0])])
    ax.plot(pixels[:, 0], pixels[:, 1], color=color, linestyle=linestyle)


plot_boundary(ax, boundaries_alpha, 'magenta')
#plot_boundary(ax, boundaries_beta, 'magenta')
#plot_boundary(ax, boundaries_charlie, 'black', "--")

# Convert lat/lon to pixel coordinates for plotting
poi_pixels = np.array([map_obj.to_pixels(lat, lon) for lat, lon in points_of_interest])

# Extract x and y coordinates
x_coords, y_coords = poi_pixels[:, 0], poi_pixels[:, 1]

# Plot points of interest
ax.scatter(x_coords, y_coords, c='g', s=50, marker='o', label="Points of Interest")

# Add labels for each point
for i, (x, y) in enumerate(zip(x_coords, y_coords)):
    ax.text(x, y, f" P{i+1}", fontsize=10, color="black", ha="right")



## Draw lines from points based on angles
#for i, (lat, lon) in enumerate(points_of_interest):
#    origin_x, origin_y = latlon_to_pixels(lat, lon)
#    for angle in angles_deg[i]:
#        dx, dy = angle_to_vector(angle)
#        ax.arrow(origin_x, origin_y, dx, -dy, head_width=5, head_length=5, fc='r', ec='r')



## Define angles for each point
#angles_deg = [
#    [290, 233, 304, 239],
#    [257, 224, 266, 224],
#    [217, 200, 216, 200]
#]

## Convert angles to vector direction
#def angle_to_vector(angle, length=20):
#    angle_rad = np.radians(angle)
#    dx = length * np.cos(angle_rad)
#    dy = length * np.sin(angle_rad)
#    return dx, dy
#
## Draw lines from points based on angles
#for i, (lat, lon) in enumerate(points_of_interest):
#    origin_x, origin_y = latlon_to_pixels(lat, lon)
#    for angle in angles_deg[i]:
#        dx, dy = angle_to_vector(angle)
#        ax.arrow(origin_x, origin_y, dx, -dy, head_width=5, head_length=5, fc='r', ec='r')
#
## Function to find intersection of two lines
#def find_intersection(line1, line2):
#    x1, y1, x2, y2 = line1
#    x3, y3, x4, y4 = line2
#
#    denom = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4)
#    if denom == 0:
#        return None  # Parallel lines, no intersection
#
#    intersect_x = ((x1 * y2 - y1 * x2) * (x3 - x4) - (x1 - x2) * (x3 * y4 - y3 * x4)) / denom
#    intersect_y = ((x1 * y2 - y1 * x2) * (y3 - y4) - (y1 - y2) * (x3 * y4 - y3 * x4)) / denom
#    return intersect_x, intersect_y
#
## Plot intersection points (example for first two lines)
#intersect = find_intersection([poi_pixels[0, 0], poi_pixels[1, 0], poi_pixels[0, 1], poi_pixels[1, 1]],
#                              [poi_pixels[1, 0], poi_pixels[2, 0], poi_pixels[1, 1], poi_pixels[2, 1]])
#if intersect:
#
## Enable interactive clicking to get coordinates
#clicked_points = []
#
#def onclick(event):
#    if event.xdata is not None and event.ydata is not None:
#        lat, lon = map_obj.to_pixels(event.ydata, event.xdata, inverse=True)
#        print(f"Clicked: Latitude: {lat:.6f}, Longitude: {lon:.6f}")
#        ax.scatter(event.xdata, event.ydata, c='red', s=10)
#        fig.canvas.draw()
#
#fig.canvas.mpl_connect('button_press_event', onclick)

# Display plot
ax.set_title("Latitude and Longitude Plot for Nathan Benderson Park, Sarasota, FL")
ax.legend()
plt.show()
