"""
Query Maps
===========
This script should read in a list of hospital locations and a list of start
locations and produce a new file of travel times between each start and the
three closest hospitals
===========
Arguments:
--input_file, -i path/to/location_pairs.csv
--output_file, -o query_output.csv (default)
--api, -a API key
--travel_mode, -t (options: driving, walking, bicycling, transit; default: driving)
--departure_time, -d (must be in the format '%b %d %Y %I:%M%p' example 'Jun 1 2005  1:33PM' ; default: now)
--traffic_model, -m (options: best_guess, optimistic, pessimistic; default: best_guess)

Output
 - file with travel times
"""

"""
Input file format:
location_file (csv)
- each row should correspond to a query
- start_id, start_longitude, start_latitude, end_id, end_longitude, end_latitude, end_dist
- NOTE: you can have multiple end locations (just concatenate the columns)
"""

"""
Output file format:

This file may have comment lines written above the data
Comment lines all must begin with #
The column headings will be included. This line should not start with a header
"""

import googlemaps
import optparse
from datetime import datetime
import numpy as np
import pandas as pd

parser = optparse.OptionParser()

parser.add_option('-i', '--input_file',
    action="store", dest="input_fi",
    help="path to input file")

parser.add_option('-o', '--output_file',
    action="store", dest="output_fi",
    help="path to output file", default = "query_output.csv")

parser.add_option('-a', '--api',
    action="store", dest="key",
    help="API key (see https://developers.google.com/maps/documentation/embed/get-api-key for details)")

parser.add_option('-t', '--travel_mode',
    action="store", dest="mode",
    help="options: driving, walking, bicycling, transit; default: driving",
    default = 'driving')

parser.add_option('-d', '--departure_time',
    action="store", dest="time",
    help="use 'now' for current time; for custom times, must be in the format '%b %d %Y %I:%M%p' example 'Jun 1 2005  1:33PM' ; default: now",
    default = 'now')

parser.add_option('-m', '--traffic_model',
    action="store", dest="model",
    help="options: best_guess, optimistic, pessimistic; default: best_guess",
    default = 'best_guess')

options, args = parser.parse_args()

required = ['input_fi','key']

for r in required:
    if options.__dict__[r] is None:
        parser.error("parameter %s required. Try python query_maps.py --help"%r)
        
if options.mode not in ['driving','walking','bicycling','transit']:
    parser.error("parameter travel_mode must be [driving|walking|bicycling|transit]")
    
if options.model not in ['best_guess','optimistic','pessimistic']:
    parser.error("parameter traffic_odel must be [best_guess|optimistic|pessimistic]")

if options.time == 'now':
    dept_time = datetime.now()
else:
    dept_time = datetime.strptime(options.time, '%b %d %Y %I:%M%p')
    
input_df = pd.read_csv(options.input_fi, sep = ',', dtype=str)

if ((input_df.shape[1] - 3) % 4) != 0:
    print('ERROR: the number of columns in the locations file is incorrect. See usage for more details')
    sys.exit(1)
    
gmaps = googlemaps.Client(key=options.key)

start_locs = input_df.iloc[:,[1,2]].apply(lambda x: ','.join(x), axis = 1).values
dest_pos = np.array(list(range(int((input_df.shape[1] - 3) / 4)))) + 1
dest_pos = np.array(list(zip(4*dest_pos, 4*dest_pos + 1)))
travel_times_colnames = ['duration_' + str(j) for j in range(len(dest_pos))] + ['duration_in_traffic_' + str(j) for j in range(len(dest_pos))]

with open(options.output_fi, 'w') as f:
    f.write(','.join(list(input_df) + travel_times_colnames) + '\n')
    for i in range(len(start_locs)):
        dest_locs = [','.join(input_df.iloc[i,p].values) for p in dest_pos]
        distance_result = gmaps.distance_matrix(start_locs[i],
                                         dest_locs,
                                         mode=options.mode,
                                         avoid="ferries",
                                         departure_time=dept_time,
                                         traffic_model=options.model
                                        )
        duration = [distance_result['rows'][0]['elements'][j]['duration']['value'] for j in range(len(dest_locs))]
        duration_traffic = [distance_result['rows'][0]['elements'][j]['duration_in_traffic']['value'] for j in range(len(dest_locs))]
        f.write(','.join(np.concatenate((input_df.iloc[i,],np.array(duration + duration_traffic).astype(str)))) + '\n')