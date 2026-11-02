# Downloads Indiana E. coli results and monitoring site details from the
# Water Quality Portal (https://www.waterqualitydata.us) and saves them as CSV.
# Run from the project root: Rscript scripts/01_download.R
# The first run can take several minutes; the raw files are not committed to git.

library(dataRetrieval)
library(readr)
source("R/config.R")

dir.create(dirname(RAW_PATH), recursive = TRUE, showWarnings = FALSE)

message("Requesting results from the Water Quality Portal...")
results <- readWQPdata(
  statecode          = STATE_CODE,
  characteristicName = CHARACTERISTIC,
  startDateLo        = START_DATE,
  startDateHi        = END_DATE
)
message("Downloaded ", nrow(results), " result rows.")

sites <- attr(results, "siteInfo")
if (is.null(sites) || nrow(sites) == 0) {
  message("No site info attached; requesting sites separately...")
  sites <- whatWQPsites(statecode = STATE_CODE, characteristicName = CHARACTERISTIC)
}

write_csv(results, RAW_PATH)
write_csv(sites, RAW_SITES_PATH)
message("Saved ", RAW_PATH, " and ", RAW_SITES_PATH)
