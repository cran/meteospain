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
library(keyring)

## ----aemet_key, eval=FALSE----------------------------------------------------
#  install.packages('keyring')
#  library(keyring)
#  key_set('aemet') # A prompt asking for the secret (the API Key) will appear.

## ----aemet_options, eval=NOT_CRAN, results='hide'-----------------------------
# current day, all stations
api_options <- aemet_options(
  resolution = 'current_day',
  api_key = key_get('aemet')
)
api_options

## ----aemet_options_fake, eval=TRUE, echo=FALSE--------------------------------
# current day, all stations
fake_api <- aemet_options(
  resolution = 'current_day',
  api_key = 'my_api_key'
)
fake_api

## ----aemet_options_2, eval=NOT_CRAN, results='hide'---------------------------
# daily, all stations
api_options <- aemet_options(
  resolution = 'daily',
  start_date = as.Date('2020-04-25'), end_date = as.Date('2020-05-25'),
  api_key = key_get('aemet')
)
api_options

## ----aemet_options_fake_2, eval=TRUE, echo=FALSE------------------------------
# daily, all stations
fake_api <- aemet_options(
  resolution = 'daily',
  start_date = as.Date('2020-04-25'), end_date = as.Date('2020-05-25'),
  api_key = 'my_api_key'
)
fake_api

## ----aemet_options_3, eval=NOT_CRAN, results='hide'---------------------------
# monthly, only one station because AEMET API limitations
api_options <- aemet_options(
  resolution = 'monthly',
  start_date = as.Date('2020-04-25'), end_date = as.Date('2020-05-25'),
  station = "0149X",
  api_key = key_get('aemet')
)
api_options

## ----aemet_options_fake_3, eval=TRUE, echo=FALSE------------------------------
# monthly, only one station because AEMET API limitations
fake_api <- aemet_options(
  resolution = 'monthly',
  start_date = as.Date('2020-01-01'), end_date = as.Date('2020-12-31'),
  station = "0149X",
  api_key = 'my_api_key'
)
fake_api

## ----aemet_stations, eval = NOT_CRAN------------------------------------------
get_stations_info_from('aemet', api_options)

## ----aemet_data, eval = NOT_CRAN----------------------------------------------
api_options <- aemet_options(
  resolution = 'daily',
  start_date = as.Date('2020-04-25'),
  api_key = key_get('aemet')
)
spain_20200425 <- get_meteo_from('aemet', options = api_options)
spain_20200425

## ----aemet_data_plot, fig.width=7, fig.height=5, fig.align='center', eval = NOT_CRAN----
spain_20200425 |>
  units::drop_units() |>
  ggplot() +
  geom_sf(aes(colour = mean_temperature)) +
  scale_colour_viridis_c()

spain_20200425 |>
  ggplot() +
  geom_histogram(aes(x = precipitation))

