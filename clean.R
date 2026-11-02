# Cleaning and quality-control functions. Each function takes a data frame and
# returns a data frame, so every step can be tested on its own.

library(dplyr)

# Keeps only the Water Quality Portal columns the project uses and gives them short names.
select_columns <- function(raw) {
  raw |>
    transmute(
      site_id           = MonitoringLocationIdentifier,
      org_id            = OrganizationIdentifier,
      date              = as.Date(ActivityStartDate),
      activity_type     = ActivityTypeCode,
      media             = ActivityMediaName,
      value             = suppressWarnings(as.numeric(ResultMeasureValue)),
      unit              = ResultMeasure.MeasureUnitCode,
      detection_note    = ResultDetectionConditionText,
      status            = ResultStatusIdentifier
    )
}

# Removes rows that are not real field measurements of water.
drop_non_samples <- function(df, qc_pattern) {
  df |>
    filter(
      media == "Water",
      !grepl(qc_pattern, activity_type, ignore.case = TRUE),
      is.na(status) | status != "Rejected"
    )
}

# Keeps rows whose unit is a count per 100 mL and labels them with one common unit.
standardize_units <- function(df, count_units) {
  df |>
    mutate(unit_key = tolower(gsub("\\s", "", unit))) |>
    filter(unit_key %in% count_units) |>
    mutate(unit = "count/100mL") |>
    select(-unit_key)
}

# Adds a qc_flag column. Flagged rows are kept so the decision is visible later.
flag_values <- function(df, upper_limit) {
  df |>
    mutate(qc_flag = case_when(
      is.na(value) & !is.na(detection_note) ~ "censored",
      is.na(value)                         ~ "missing",
      value < 0                            ~ "negative",
      value > upper_limit                  ~ "above_review_limit",
      TRUE                                 ~ "ok"
    ))
}

# Runs every step and records how many rows each step removed.
clean_results <- function(raw, cfg) {
  log <- tibble(step = character(), rows_remaining = integer())
  record <- function(df, step) {
    n <- nrow(df)  # forces earlier pipeline steps to run first, so the log stays in order
    log <<- bind_rows(log, tibble(step = step, rows_remaining = n))
    df
  }

  cleaned <- raw |>
    record("raw download") |>
    select_columns() |>
    drop_non_samples(cfg$qc_pattern) |>
    record("dropped QC, non-water and rejected rows") |>
    standardize_units(cfg$count_units) |>
    record("kept count/100mL units only") |>
    flag_values(cfg$upper_limit) |>
    distinct() |>
    record("removed exact duplicates")

  list(data = cleaned, log = log)
}
