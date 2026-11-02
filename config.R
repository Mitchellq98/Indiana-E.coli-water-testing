# Project-wide settings. Change values here, not inside the scripts.

# Indiana is FIPS state code 18. The Water Quality Portal expects "US:18".
STATE_CODE <- "US:18"
CHARACTERISTIC <- "Escherichia coli"
START_DATE <- "2015-01-01"
END_DATE   <- "2025-12-31"

# Indiana recreational E. coli criteria (327 IAC 2-1-6), in CFU or MPN per 100 mL.
SINGLE_SAMPLE_LIMIT <- 235
GEOMEAN_LIMIT       <- 125
RECREATION_MONTHS   <- 4:10   # April through October

# Units treated as equivalent counts per 100 mL. Compared lowercase with spaces removed.
COUNT_UNITS <- c("cfu/100ml", "mpn/100ml", "#/100ml")

# Many E. coli labs use a method whose upper reporting limit is about 24,196 MPN/100 mL.
# Values above this are flagged for review, not deleted.
UPPER_REVIEW_LIMIT <- 24196

# Activity types that are quality-control samples, not real field measurements.
QC_ACTIVITY_PATTERN <- "Quality Control|Blank|Replicate|Spike"

RAW_PATH       <- "data/raw/ecoli_results.csv"
RAW_SITES_PATH <- "data/raw/ecoli_sites.csv"
CLEAN_PATH     <- "data/processed/ecoli_clean.csv"
CLEAN_LOG_PATH <- "data/processed/cleaning_log.csv"
FIG_DIR        <- "figures"
