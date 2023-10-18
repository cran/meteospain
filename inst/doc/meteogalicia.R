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
library(dplyr)
library(ggplot2)
library(ggforce)
library(units)
library(sf)

## ----meteogalicia_options, eval=NOT_CRAN--------------------------------------
# last measure for all stations
api_options <- meteogalicia_options()
api_options

# current day, only some stations
api_options <- meteogalicia_options(
  resolution = 'current_day',
  stations = c('10157', '14000', '10045')
)
api_options

# daily, all stations
api_options <- meteogalicia_options(
  resolution = 'daily',
  start_date = as.Date('2020-04-25'), end_date = as.Date('2020-05-25')
)
api_options

# monthly, some stations
api_options <- meteogalicia_options(
  resolution = 'monthly',
  start_date = as.Date('2020-04-01'), end_date = as.Date('2020-08-01'),
  stations = c('10157', '14000', '10045')
)
api_options

## ----meteogalicia_stations, eval = NOT_CRAN-----------------------------------
get_stations_info_from('meteogalicia')

## ----meteogalicia_data, eval = NOT_CRAN---------------------------------------
api_options <- meteogalicia_options(
  resolution = 'monthly',
  start_date = as.Date('2020-01-01'),
  end_date = as.Date('2020-12-31')
)
galicia_2020 <- get_meteo_from('meteogalicia', options = api_options)
galicia_2020

## ----meteogalicia_data_plot, fig.width=7, fig.height=5, fig.align='center', eval = NOT_CRAN----
galicia_2020 |>
  units::drop_units() |>
  mutate(month = lubridate::month(timestamp, label = TRUE)) |>
  ggplot() +
  geom_sf(aes(colour = max_temperature)) +
  facet_wrap(vars(month), ncol = 4) +
  scale_colour_viridis_c()

galicia_2020 |>
  mutate(month = lubridate::month(timestamp, label = TRUE)) |>
  ggplot() +
  geom_histogram(aes(x = precipitation)) +
  facet_wrap(vars(month), ncol = 4)

