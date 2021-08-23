

# Methodology
These public transport travel time matrices show travel times between [LSOA11 Trip-points](https://github.com/stupidpupil/wales_lsoa_trip_points).

These times are generated using [street map and public transport timetable data for Wales and bordering regions](https://stupidpupil.github.io/wales_ish_otp_graph/)
and the [*r5r* library](https://ipeagit.github.io/r5r/), which is built on top of the 
[Rapid Realistic Routing on Real-world and Reimagined networks (R5) routing engine](https://github.com/conveyal/r5).

(See [this link for information about *driving-time* matrices](https://github.com/stupidpupil/wales_ish_osrm_runner/tree/matrix-releases).)

## Constraints

The maximum walking distance is 3 kilometres. Walking speed is 4.7 km/h.

The maximum trip duration is 6 hours. 

Transfer "slack" time - the minimum time between alighting from one vehicle and boarding another - is believed to be 120 seconds.

## Arrive by
*Arrive by* matrices include waiting time between the end of the journey and the arrive-by-time. This is intended to reflect the experience of using public transport to attend an appointment at a prespecified time.

The times in *arrive by* matrices are effectively rounded *up* to the nearest 15 minutes.

# Licence

The public transport travel time matrices produced by this tool are made available under the [ODbL v1.0](https://opendatacommons.org/licenses/odbl/1-0/) by Adam Watkins.

They are derived from other data, including:
- street map information obtained from [OpenStreetMap contributors](https://www.openstreetmap.org/copyright), via [Geofabrik.de](https://download.geofabrik.de/europe/great-britain.html), under the [ODbL v1.0](https://opendatacommons.org/licenses/odbl/1-0/),
- heavy rail timetable information obtained from [RSP Limited (Rail Delivery Group)](http://data.atoc.org/) under the [CC-BY v2.0](https://creativecommons.org/licenses/by/2.0/uk/legalcode), and
- bus and other public transport services timetable information obtained from [Traveline](https://www.travelinedata.org.uk/traveline-open-data/traveline-national-dataset/) and the [UK Department for Transport](https://data.bus-data.dft.gov.uk/) under the [OGL v3.0](https://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/).
- [LSOA11 Population-Weighted Centroids](https://geoportal.statistics.gov.uk/datasets/ons::lower-layer-super-output-areas-december-2011-population-weighted-centroids/about) and [LSOA11 Boundaries](https://geoportal.statistics.gov.uk/datasets/ons::lower-layer-super-output-areas-december-2011-boundaries-super-generalised-clipped-bsc-ew-v3/about) obtained from the [ONS Open Geography Portal](https://geoportal.statistics.gov.uk/), under the [OGL v3.0](https://www.ons.gov.uk/methodology/geography/licences) and containing OS data (Crown copyright and database right 2021).
