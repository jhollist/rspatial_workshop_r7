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


