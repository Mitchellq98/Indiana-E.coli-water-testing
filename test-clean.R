source("../../R/config.R")
source("../../R/clean.R")

fixture <- readr::read_csv("../fixtures/sample_results.csv", show_col_types = FALSE)
cfg <- list(qc_pattern = QC_ACTIVITY_PATTERN, count_units = COUNT_UNITS, upper_limit = UPPER_REVIEW_LIMIT)

test_that("QC samples, non-water media and rejected results are removed", {
  out <- clean_results(fixture, cfg)$data
  expect_false(any(grepl("Quality Control", out$activity_type)))
  expect_true(all(out$media == "Water"))
  expect_false(any(out$status == "Rejected", na.rm = TRUE))
})

test_that("only count-per-100mL units survive, under one label", {
  out <- clean_results(fixture, cfg)$data
  expect_equal(unique(out$unit), "count/100mL")
})

test_that("unit matching ignores case and spaces", {
  df <- tibble::tibble(unit = c("CFU/100ml", "MPN/100 mL", "mg/L"))
  expect_equal(nrow(standardize_units(df, COUNT_UNITS)), 2)
})

test_that("values are flagged rather than dropped", {
  df <- tibble::tibble(
    value = c(50, NA, NA, -3, 30000),
    detection_note = c(NA, "Not Detected", NA, NA, NA)
  )
  expect_equal(flag_values(df, UPPER_REVIEW_LIMIT)$qc_flag,
               c("ok", "censored", "missing", "negative", "above_review_limit"))
})

test_that("cleaning log records each step in order", {
  log <- clean_results(fixture, cfg)$log
  expect_equal(nrow(log), 4)
  expect_true(all(diff(log$rows_remaining) <= 0))
})
