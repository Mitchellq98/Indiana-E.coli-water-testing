# Analysis functions. All of them expect the cleaned dataset from R/clean.R.

library(dplyr)
library(lubridate)

# Keeps usable measurements taken during the recreation season.
recreation_season <- function(clean, months) {
  clean |>
    filter(qc_flag %in% c("ok", "above_review_limit"), month(date) %in% months)
}

# One row per site: sample count, median, and share of samples over the single-sample limit.
# Sites with fewer than min_samples are dropped because their rates are unreliable.
site_exceedance <- function(season, limit, min_samples = 20) {
  season |>
    group_by(site_id) |>
    summarise(
      n_samples      = n(),
      first_sample   = min(date),
      last_sample    = max(date),
      median_value   = median(value),
      n_exceed       = sum(value > limit),
      pct_exceed     = 100 * n_exceed / n_samples,
      .groups = "drop"
    ) |>
    filter(n_samples >= min_samples) |>
    arrange(desc(pct_exceed))
}

# Statewide share of samples over the limit, by year.
yearly_exceedance <- function(season, limit) {
  season |>
    mutate(year = year(date)) |>
    group_by(year) |>
    summarise(
      n_samples  = n(),
      pct_exceed = 100 * mean(value > limit),
      .groups = "drop"
    )
}

# Geometric mean, the statistic Indiana's 30-day criterion uses.
geometric_mean <- function(x) {
  x <- x[!is.na(x) & x > 0]
  if (length(x) == 0) return(NA_real_)
  exp(mean(log(x)))
}
