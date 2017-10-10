# Live Coding: Region 7 R Spatial Workshop
# Install - dplyr, sf, raster, rgdal, sp

# Packages
library(dplyr)
library(sf)
library(raster)
library(here)
library(httr)

# Get Data
url <- "https://github.com/usepa/rspatial_workshop/blob/master/data/data.zip?raw=true"
GET(url,write_disk(here("data/data.zip"),overwrite = TRUE))

# Unzip data
unzip(here("data/data.zip"), exdir = here("data"), overwrite = TRUE)

# Read in data files

## Shapefile
dc_metro <- st_read(here("data/Metro_Lines.shp"))

## geojson
dc_metro_sttn <- st_read(here("data/metrostations.geojson"))

# Write spatial data

## Shapefile
st_write(dc_metro_sttn,here("data/metrosttn.shp"))

## Geojson
st_write(dc_metro,here("data/metrolines.geojson"))

## Read files exercise
us_states <- st_read(here("data/tl_2015_us_state.shp"))

# Read in raster data

## Geotiff
dc_elev <- raster(here("data/dc_ned.tif"))
dc_elev

# Write out raster data
#writeRaster(dc_elev,"dc_elev_example.asc", overwrite = T)

# Read in raster exercise
dc_nlcd <- raster(here("data/dc_nlcd.tif"))
plot(dc_nlcd)

# Explore spatial data
summary(dc_metro_sttn)
names(dc_metro)

# manipulate with dplyr

est_mkt_sttn <- dc_metro_sttn %>%
  filter(NAME == "Eastern Market")

org_line_only <- dc_metro %>%
  filter(NAME == "orange")

# Merging data

station_rides <- read.csv(here("data/station_rides.csv"), stringsAsFactors = FALSE)
dc_metro_sttn_busy <- dc_metro_sttn %>%
  left_join(station_rides, by = c("NAME" = "Ent.Station")) %>%
  filter(avg_wkday > 10000) %>%
  select(name = NAME, line = LINE, ridership = avg_wkday)

dc_metro_stn_summ <- dc_metro_sttn %>%
  left_join(station_rides, by = c("NAME" = "Ent.Station")) %>%
  group_by(LINE) %>%
  summarize(total_avg_ridership = sum(avg_wkday, na.rm = TRUE)) %>%
  arrange(desc(total_avg_ridership))
dc_metro_stn_summ

# Projection

# look at the proj info
## sf
st_crs(dc_metro)$proj4string
## raster
raster::projection(dc_nlcd)

# Save p4 to object
alb_p4 <- raster::projection(dc_nlcd)

# Transform sf
dc_metro_alb <- st_transform(dc_metro, alb_p4 )

# Transform raster
dc_elev_alb <- raster::projectRaster(dc_elev,crs=alb_p4)


