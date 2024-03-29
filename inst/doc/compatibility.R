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
library(sf)
library(purrr)
library(dplyr)
library(ggplot2)
library(units)

# provide keys for aemet and meteocat if not done already
# keyring::key_set('aemet')
# keyring::key_set('meteocat')

## ----daily_april_2020, eval=NOT_CRAN------------------------------------------
aemet_daily <- get_meteo_from(
    'aemet', aemet_options(
      'daily', start_date = as.Date('2020-04-01'), end_date = as.Date('2020-04-30'),
      api_key = keyring::key_get('aemet')
    )
)

meteocat_daily <- get_meteo_from(
  'meteocat',
  meteocat_options('daily', start_date = as.Date('2020-04-01'), api_key = keyring::key_get('meteocat'))
)

meteogalicia_daily <- get_meteo_from(
  'meteogalicia',
  meteogalicia_options('daily', start_date = as.Date('2020-04-01'), end_date = as.Date('2020-04-30'))
)

ria_daily <- get_meteo_from(
  'ria',
  ria_options('daily', start_date = as.Date('2020-04-01'), end_date = as.Date('2020-04-30'))
)

## ----join_step, eval=NOT_CRAN-------------------------------------------------
april_2020_spain <- list(
  dplyr::as_tibble(aemet_daily),
  dplyr::as_tibble(meteocat_daily),
  dplyr::as_tibble(meteogalicia_daily),
  dplyr::as_tibble(ria_daily)
) |>
  purrr::reduce(dplyr::full_join) |>
  sf::st_as_sf()

april_2020_spain

## ----plot_map, eval=NOT_CRAN, fig.height=5, fig.width=7, fig.align='center'----
april_2020_spain |>
  dplyr::filter(lubridate::day(timestamp) == 25) |>
  units::drop_units() |>
  ggplot(aes(colour = service)) +
  geom_sf() +
  scale_colour_viridis_d()

## ----plot_map_2, eval=NOT_CRAN, fig.height=5, fig.width=7, fig.align='center'----
april_2020_spain |>
  dplyr::filter(lubridate::day(timestamp) == 25) |>
  units::drop_units() |>
  ggplot(aes(colour = mean_temperature)) +
  geom_sf() +
  scale_colour_viridis_c()

