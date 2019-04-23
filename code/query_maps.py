"""
Query Maps
===========
This script should read in a list of hospital locations and a list of start
locations and produce a new file of travel times between each start and the
three closest hospitals
===========
Arguments:
[1] path/to/hospital_locations.txt
[2] path/to/start_locations.txt
[3] API key

Output
 - file with travel times
"""

"""
Input file format:
hospital locations (csv)
- each row should correspond to a hospital
- field 1 should be latitude (in DD), field 2 should be longitude (in DD)

start locations (csv)
- each row should correspond to a start locations
- feild 1 should be latitude (in DD), field 2 should be longitude (in DD), field 3 should be census_tract_id
"""

"""
Output file format:

The input file should have rows which each represent a distinct start location
The columns of the input file should be:
census_tract_id: `string`
start_longitude: `string?`
start_latitude: `string?`
t_1: `int` minutes to nearest hospital
t_2: `int` minutes to second nearest hospital
t_3: `int` minutes to third nearest hospital

This file may have comment lines written above the data
Comment lines all must begin with #
The column headings will be included. This line should not start with a header
"""
