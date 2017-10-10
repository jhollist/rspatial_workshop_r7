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


busy_sttn <- dc_metro_sttn %>%
  filter(avg_wkday > 10000) %>%
  select(name = NAME, line = LINE, ridership = avg_wkday)
