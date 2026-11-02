source("../../R/config.R")
source("../../R/analyze.R")

make_season <- function(site, values, start = "2024-06-01") {
  tibble::tibble(
    site_id = site,
    date = as.Date(start) + seq_along(values) - 1,
    value = values,
    qc_flag = "ok"
  )
}

test_that("geometric mean matches a hand calculation", {
  expect_equal(geometric_mean(c(10, 1000)), 100)
  expect_true(is.na(geometric_mean(c(NA, 0))))
})

test_that("site exceedance counts values strictly above the limit", {
  season <- make_season("A", c(rep(100, 15), rep(235, 2), rep(500, 3)))
  out <- site_exceedance(season, 235, min_samples = 20)
  expect_equal(out$n_exceed, 3)
  expect_equal(out$pct_exceed, 15)
})

test_that("sites below the minimum sample count are dropped", {
  season <- rbind(make_season("A", rep(100, 25)), make_season("B", rep(900, 5)))
  out <- site_exceedance(season, 235, min_samples = 20)
  expect_equal(out$site_id, "A")
})

test_that("recreation season keeps only the chosen months and usable flags", {
  df <- tibble::tibble(
    date = as.Date(c("2024-01-15", "2024-07-15", "2024-07-16")),
    value = c(10, 20, NA),
    qc_flag = c("ok", "ok", "missing")
  )
  expect_equal(nrow(recreation_season(df, 4:10)), 1)
})
