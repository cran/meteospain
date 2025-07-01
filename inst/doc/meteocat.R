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
library(keyring)

## ----meteocat_key, eval=FALSE-------------------------------------------------
# install.packages('keyring')
# library(keyring)
# key_set('meteocat') # A prompt asking for the secret (the API Key) will appear.

## ----meteocat_options, eval=NOT_CRAN, results='hide'--------------------------
# current day, all stations
api_options <- meteocat_options(
  resolution = 'instant',
  api_key = key_get('meteocat')
)
api_options

## ----meteocat_options_fake, eval=TRUE, echo=FALSE-----------------------------
# current day, all stations
fake_api <- meteocat_options(
  resolution = 'instant',
  api_key = 'my_api_key'
)
fake_api

## ----meteocat_options_2, eval=NOT_CRAN, results='hide'------------------------
# daily, all stations
api_options <- meteocat_options(
  resolution = 'daily',
  start_date = as.Date('2020-04-10'),
  api_key = key_get('meteocat')
)
api_options

## ----meteocat_options_fake_2, eval=TRUE, echo=FALSE---------------------------
# daily, all stations
fake_api <- meteocat_options(
  resolution = 'daily',
  start_date = as.Date('2020-04-25'),
  api_key = 'my_api_key'
)
fake_api

## ----meteocat_stations, eval = NOT_CRAN---------------------------------------
get_stations_info_from('meteocat', api_options)

## ----meteocat_data, eval = NOT_CRAN-------------------------------------------
api_options <- meteocat_options(
  resolution = 'monthly',
  start_date = as.Date('2020-04-01'),
  api_key = key_get('meteocat')
)
catalunya_2020 <- get_meteo_from('meteocat', options = api_options)
catalunya_2020

## ----meteocat_data_plot, fig.width=7, fig.height=7, fig.align='center', eval = NOT_CRAN----
catalunya_2020 |>
  units::drop_units() |>
  mutate(month = lubridate::month(timestamp, label = TRUE)) |>
  ggplot() +
  geom_sf(aes(colour = mean_temperature)) +
  facet_wrap(vars(month), ncol = 4) +
  scale_colour_viridis_c()

catalunya_2020 |>
  mutate(month = lubridate::month(timestamp, label = TRUE)) |>
  ggplot() +
  geom_histogram(aes(x = precipitation)) +
  facet_wrap(vars(month), ncol = 4)

