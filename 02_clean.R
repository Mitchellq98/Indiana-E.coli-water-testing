# Cleans the raw download and writes the analysis-ready dataset plus a cleaning log.
# Run from the project root: Rscript scripts/02_clean.R

library(readr)
library(dplyr)
source("R/config.R")
source("R/clean.R")

raw <- read_csv(RAW_PATH, show_col_types = FALSE, guess_max = 100000)

result <- clean_results(raw, list(
  qc_pattern  = QC_ACTIVITY_PATTERN,
  count_units = COUNT_UNITS,
  upper_limit = UPPER_REVIEW_LIMIT
))

dir.create(dirname(CLEAN_PATH), recursive = TRUE, showWarnings = FALSE)
write_csv(result$data, CLEAN_PATH)
write_csv(result$log, CLEAN_LOG_PATH)

print(result$log)
print(count(result$data, qc_flag))
