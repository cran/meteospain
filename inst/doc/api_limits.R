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

## ----aemet_limit, error=TRUE, eval=NOT_CRAN-----------------------------------
try({
# aemet api has a limit for 15 days in daily:
get_meteo_from(
  'aemet',
  aemet_options(
    api_key = keyring::key_get('aemet'),
    resolution = 'daily',
    start_date = as.Date('1990-01-01'),
    end_date = as.Date('1990-12-31')
  )
)

# and monthly and yearly data to 36 months
get_meteo_from(
  'aemet',
  aemet_options(
    api_key = keyring::key_get('aemet'),
    resolution = 'yearly',
    start_date = as.Date('2005-01-01'),
    end_date = as.Date('2020-12-31'),
    stations = "0149X"
  )
)
})

## ----manual, eval=NOT_CRAN----------------------------------------------------
res_1990_jan_1 <- get_meteo_from(
  'aemet',
  aemet_options(
    api_key = keyring::key_get('aemet'),
    resolution = 'daily',
    start_date = as.Date('1990-01-01'),
    end_date = as.Date('1990-01-15')
  )
)

res_1990_jan_2 <- get_meteo_from(
  'aemet',
  aemet_options(
    api_key = keyring::key_get('aemet'),
    resolution = 'daily',
    start_date = as.Date('1990-01-16'),
    end_date = as.Date('1990-01-31')
  )
)

res_1990_jan <- rbind(res_1990_jan_1, res_1990_jan_2)
res_1990_jan

## ----dates_vecs---------------------------------------------------------------
# First, we prepare the date vectors, with the start and end dates.
start_dates <- seq(as.Date('1990-01-01'), as.Date('1990-07-01'), '15 days')
end_dates <- seq(as.Date('1990-01-15'), as.Date('1990-07-15'), '15 days')

# Both vectors must have the same length
length(start_dates) == length(end_dates)

# lets see them
data.frame(start_dates, end_dates)

## ----tidyverse_loop, eval=NOT_CRAN--------------------------------------------
# tidyverse map
res_tidyverse <-
  purrr::map2(
    .x = start_dates, .y = end_dates,
    .f = function(start_date, end_date) {
      res <- get_meteo_from(
        'aemet',
        aemet_options(
          api_key = keyring::key_get('aemet'),
          resolution = 'daily',
          start_date = start_date,
          end_date = end_date
        )
      )
      return(res)
    }
  ) |>
  purrr::list_rbind()

head(res_tidyverse)

## ----for_loop, eval=NOT_CRAN--------------------------------------------------
# base for loop
res_for <- data.frame()

for (index in seq_along(start_dates)) {
  temp_res <- get_meteo_from(
    'aemet',
    aemet_options(
      api_key = keyring::key_get('aemet'),
      resolution = 'daily',
      start_date = start_dates[index],
      end_date = end_dates[index]
    )
  )
  
  res_for <- rbind(res_for, temp_res)
}

head(res_for)

## ----identical, eval=NOT_CRAN-------------------------------------------------
# both are identical
identical(res_tidyverse, res_for)

## ----meteocat_daily, eval=NOT_CRAN--------------------------------------------
api_options <- meteocat_options(
  'daily', start_date = as.Date('2020-04-10'),
  api_key = keyring::key_get('meteocat')
)
april_2020 <- get_meteo_from('meteocat', api_options)
unique(april_2020$timestamp)

## ----meteocat_daily_loops, eval=NOT_CRAN--------------------------------------
start_dates <- seq(as.Date('2020-01-01'), as.Date('2020-04-01'), 'months')
# tidyverse map
meteocat_2020q1_tidyverse <-
  purrr::map(
    .x = start_dates,
    .f = function(start_date) {
      res <- get_meteo_from(
        'meteocat',
        meteocat_options(
          api_key = keyring::key_get('meteocat'),
          resolution = 'daily',
          start_date = start_date
        )
      )
      return(res)
    }
  ) |>
  purrr::list_rbind()

head(meteocat_2020q1_tidyverse)

# base for loop
meteocat_2020q1_for <- data.frame()

for (index in seq_along(start_dates)) {
  temp_res <- get_meteo_from(
    'meteocat',
    meteocat_options(
      api_key = keyring::key_get('meteocat'),
      resolution = 'daily',
      start_date = start_dates[index]
    )
  )
  
  meteocat_2020q1_for <- rbind(meteocat_2020q1_for, temp_res)
}

head(meteocat_2020q1_for)

# both are identical
identical(meteocat_2020q1_tidyverse, meteocat_2020q1_for)

## ----meteocat_monthly, eval=NOT_CRAN------------------------------------------
api_options <- meteocat_options(
  'monthly', start_date = as.Date('2020-04-10'),
  api_key = keyring::key_get('meteocat')
)
year_2020 <- get_meteo_from('meteocat', api_options)
unique(year_2020$timestamp)

## ----meteocat_monthly_loops, eval=NOT_CRAN------------------------------------
start_dates <- seq(as.Date('2019-01-01'), as.Date('2020-01-01'), 'years')
# tidyverse map
meteocat_2019_20_tidyverse <-
  purrr::map(
    .x = start_dates,
    .f = function(start_date) {
      res <- get_meteo_from(
        'meteocat',
        meteocat_options(
          api_key = keyring::key_get('meteocat'),
          resolution = 'monthly',
          start_date = start_date
        )
      )
      return(res)
    }
  ) |>
  purrr::list_rbind()

head(meteocat_2019_20_tidyverse)

# base for loop
meteocat_2019_20_for <- data.frame()

for (index in seq_along(start_dates)) {
  temp_res <- get_meteo_from(
    'meteocat',
    meteocat_options(
      api_key = keyring::key_get('meteocat'),
      resolution = 'monthly',
      start_date = start_dates[index]
    )
  )
  
  meteocat_2019_20_for <- rbind(meteocat_2019_20_for, temp_res)
}
head(meteocat_2019_20_for)

# both are identical
identical(meteocat_2019_20_tidyverse, meteocat_2019_20_for)

## ----meteocat_yearly, eval=NOT_CRAN-------------------------------------------
api_options <- meteocat_options(
  'yearly', start_date = as.Date('2020-04-10'),
  api_key = keyring::key_get('meteocat')
)
all_years <- get_meteo_from('meteocat', api_options)
unique(all_years$timestamp)

