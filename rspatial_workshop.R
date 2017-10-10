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

