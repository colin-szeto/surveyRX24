import smopy
import numpy as np
import matplotlib.pyplot as plt
from matplotlib.patches import Polygon
from pathlib import Path
import math

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

points_of_interest= np.array([

[27.37445999908638, -82.45295136312592    ],
[27.374620996345485, -82.4534577277253    ],
[27.374653996345476, -82.45345772802732   ],
[27.374680996197824, -82.45347798283991   ],
[27.374751995970872, -82.45350836537044   ],
[27.374789995893757, -82.45351849302833   ],
[27.374820995893746, -82.45351849332907   ],
[27.374930996345434, -82.45345773056249   ],
[27.374989997039794, -82.45335645799223   ],
[27.374989999086356, -82.45295136555124   ],
[27.37488199908636, -82.45295136505702    ],
[27.374783998973435, -82.45298174648507   ],
[27.374705998973443, -82.45298174610672   ],
[27.374783999192704, -82.45292098273204   ],
[27.374705999192717, -82.45292098239653   ],
[27.37488199908636, -82.45295136505702    ],
[27.374989999086356, -82.45295136555124   ],
[27.37488199977159, -82.45269818252851    ],
[27.374783999771587, -82.45269818230427   ],
[27.374635999771595, -82.45269818196564   ],
[27.374546999086373, -82.45395136352404   ]

])


# Points of interest (latitude, longitude)
reference_bouys = np.array([
    #[27.374887, -82.452340],  # Below road    
    #[27.375603, -82.452284],  # White road
    #[27.376269, -82.452381]   # Top northwest corner
    [27.376097, -82.452812],#Red Edge Buoy#1
    [27.376097, -82.452912],#Red Edge Buoy#2
    [27.376097, -82.45305],#Red Edge Buoy#3
    [27.376097, -82.453198],#Red Edge Buoy#4
    [27.376097, -82.453285],#Red Edge Buoy#5
    [27.376097, -82.453431],#Red Edge Buoy#6
    [27.376096999990867, -82.45333563706173],#back boundary
    #[27.376097, -82.453517],#Red Edge Buoy#7
    #[27.376097, -82.453684],#Red Edge Buoy#8
    #[27.376097, -82.453822],#Red Edge Buoy#9
    #[27.376097, -82.453965],#Red Edge Buoy#10
])

boundary_bouys = np.array([
#[27.376096999990867, -82.45333563706173], # northwest bouy
[27.375102,-82.452467]                  ,
[27.374394,-82.452441]                  ,
[27.374377,-82.452435]                  ,
[27.373693,-82.453285]
])


def destination_point(lat, lon, bearing, distance):
    """
    Calculate the destination point given a starting point, bearing, and distance in meters
    """
    # convert decimal degrees to radians
    lon, lat, bearing = map(math.radians, [lon, lat, bearing])

    distance = distance/1000

    # calculate the destination point
    lat2 = math.asin(math.sin(lat) * math.cos(distance/6371) + math.cos(lat) * math.sin(distance/6371) * math.cos(bearing))
    lon2 = lon + math.atan2(math.sin(bearing) * math.sin(distance/6371) * math.cos(lat), math.cos(distance/6371) - math.sin(lat) * math.sin(lat2))
    lat2 = math.degrees(lat2)
    lon2 = math.degrees(lon2)
    print("{}, {}".format(lat2, lon2))
    return lat2, lon2


# Function to plot boundary regions
def plot_line(ax, boundary, color, linestyle="-"):
    pixels = np.array([latlon_to_pixels(lat, lon) for lat, lon in zip(boundary[1], boundary[0])])
    ax.plot(pixels[:, 0], pixels[:, 1], color=color, linestyle=linestyle)

#plot_line(ax, points, 'magenta','--')

def draw_line_vert(lat_in, lon_in,color):
    reb = [lat_in, lon_in]
    reb_f_lat,reb_f_lon = destination_point(reb[0], reb[1],180,300)
    points = np.array([
        [reb_f_lon, reb[1]],
        [reb_f_lat, reb[0]]
    ])
    plot_line(ax, points, color,'--')
    
def draw_line_horiz(lat_in, lon_in,color):
    reb = [lat_in, lon_in]
    reb_f_lat,reb_f_lon = destination_point(reb[0], reb[1],270,300)
    points = np.array([
        [reb_f_lon, reb[1]],
        [reb_f_lat, reb[0]]
    ])
    plot_line(ax, points, color,'--')

counter_1 = 1
for pair in reference_bouys:
    if counter_1 == 7:
        draw_line_vert(pair[0], pair[1],'g')
    else:
        draw_line_vert(pair[0], pair[1],'m')
        
    counter_1 = counter_1 + 1 

for pair in boundary_bouys:
    draw_line_horiz(pair[0], pair[1],'m')
    
grid_lines = np.array([
    [27.375102,-82.452467],
])
    
# to generate grid lines
ref_point = [27.375102,-82.452467]  
for i in range(0,20,1):
    # create bouys
    lat_n, lon_n = destination_point(ref_point[0], ref_point[1], 180, 5)
    new_row = [lat_n, lon_n]
    print("new_row {}".format(new_row))
    grid_lines = np.vstack([grid_lines,new_row])
    ref_point = destination_point(ref_point[0], ref_point[1], 180, 5)
    
for pair in grid_lines:
    draw_line_horiz(pair[0], pair[1],"#4DBEEE")
    
# vertical lines 
ref_point = [27.375102,-82.452467]  
for i in range(0,20,1):
    # create bouys
    lat_n, lon_n = destination_point(ref_point[0], ref_point[1], 270, 5)
    new_row = [lat_n, lon_n]
    print("new_row {}".format(new_row))
    grid_lines = np.vstack([grid_lines,new_row])
    ref_point = destination_point(ref_point[0], ref_point[1], 270, 5)
    
for pair in grid_lines:
    draw_line_vert(pair[0], pair[1],"#4DBEEE")


#reference_bouys_pixels = np.array([map_obj.to_pixels(lat, lon) for lat, lon in grid_lines])
#x_coords, y_coords = reference_bouys_pixels[:, 0], reference_bouys_pixels[:, 1] # Extract x and y coordinates
#ax.scatter(x_coords, y_coords, c='black', s=1, marker='o', label="grid_lines") # Plot points of interest

# Convert lat/lon to pixel coordinates for plotting
reference_bouys_pixels = np.array([map_obj.to_pixels(lat, lon) for lat, lon in reference_bouys])
x_coords, y_coords = reference_bouys_pixels[:, 0], reference_bouys_pixels[:, 1] # Extract x and y coordinates
ax.scatter(x_coords, y_coords, c='red', s=50, marker='o', label="Red Bouys") # Plot points of interest
for i, (x, y) in enumerate(zip(x_coords, y_coords)): # Add labels for each point
    ax.text(x, y, f" RB {i+1}", fontsize=10, color="black", ha="right",rotation=90)


# Plotting the waypoints
poi_pixels = np.array([latlon_to_pixels(lat, lon) for lat, lon in points_of_interest])
ax.scatter(poi_pixels[:, 0], poi_pixels[:, 1], c='g', s=10, label="Waypoints")
x_coords, y_coords = poi_pixels[:, 0], poi_pixels[:, 1]
for i, (x, y) in enumerate(zip(x_coords, y_coords)):
   ax.text(x, y, f" WP {i+1}", fontsize=10, color="black", ha="right")
   
# boundary pylongs 
reference_bouys_pixels = np.array([map_obj.to_pixels(lat, lon) for lat, lon in boundary_bouys])
x_coords, y_coords = reference_bouys_pixels[:, 0], reference_bouys_pixels[:, 1] # Extract x and y coordinates
ax.scatter(x_coords, y_coords, c='m', s=50, marker='o', label="Boundary Bouys") # Plot points of interest
for i, (x, y) in enumerate(zip(x_coords, y_coords)): # Add labels for each point
    ax.text(x, y, f" RB {i+1}", fontsize=10, color="black", ha="right")


    
    
# Display plot
ax.set_title("Latitude and Longitude Plot for Nathan Benderson Park, Sarasota, FL")
ax.legend()
plt.show()
