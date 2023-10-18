## ----include = FALSE----------------------------------------------------------
# use eval = NOT_CRAN in the chunks connecting to API, to avoid errors or warnings in CRAN checks
NOT_CRAN <- identical(tolower(Sys.getenv("NOT_CRAN")), "true")
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  purl = NOT_CRAN
)

# env keyring
withr::local_options(list("keyring_backend" = "env"))

## ----setup--------------------------------------------------------------------
library(meteospain)
library(ggplot2)
library(ggforce)
library(units)
library(sf)

## ----meteoclimatic_options, eval = NOT_CRAN-----------------------------------
api_options <- meteoclimatic_options(stations = 'ESCAT08')
api_options

## ----meteoclimatic_stations, eval = NOT_CRAN----------------------------------
get_stations_info_from('meteoclimatic', options = api_options)

## ----meteoclimatic_data, eval = NOT_CRAN--------------------------------------
current_day_barcelona <- get_meteo_from('meteoclimatic', options = api_options)
current_day_barcelona

## ----meteoclimatic_data_plot, fig.width=7, fig.height=5, fig.align='center', eval = NOT_CRAN----
current_day_barcelona |>
  units::drop_units() |>
  ggplot() +
  geom_sf(aes(colour = max_temperature)) +
  scale_colour_viridis_c()

current_day_barcelona |>
  ggplot() +
  geom_histogram(aes(x = max_relative_humidity))

