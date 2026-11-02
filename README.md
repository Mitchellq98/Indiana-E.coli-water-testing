# E. coli in Indiana Waterways

An R analysis of public E. coli monitoring data from Indiana rivers and lakes,
2015-2025. It looks at which monitoring sites most often exceed Indiana's
recreational water quality limit, how concentrations change through the year,
and how the statewide exceedance rate has changed over time.

## Data

All data comes from the [Water Quality Portal](https://www.waterqualitydata.us),
a public database run by the USGS and EPA that combines results from state,
federal and local monitoring programs. It is downloaded with the USGS
[dataRetrieval](https://doi-usgs.github.io/dataRetrieval/) R package.

## Project layout

```
R/config.R            settings: state, dates, limits, file paths
R/clean.R             cleaning and quality-control functions
R/analyze.R           exceedance and summary functions
R/plots.R             chart functions
scripts/01_download.R pulls raw data from the Water Quality Portal
scripts/02_clean.R    writes the cleaned dataset and a cleaning log
scripts/03_analyze.R  writes summary tables and charts
report/report.Rmd     the written report
tests/                unit tests and a small made-up test file
run_all.R             runs everything in order
```

## How to run

Install R (4.2 or newer), then install the packages once:

```r
install.packages(c("dataRetrieval", "dplyr", "readr", "ggplot2",
                   "lubridate", "tidyr", "rmarkdown", "knitr", "testthat"))
```

From the project folder:

```
Rscript run_all.R
Rscript -e 'testthat::test_dir("tests/testthat")'
```

The first run downloads the data, which can take several minutes. Later runs
reuse the saved file.

## Cleaning steps

1. Keep water samples only, and drop quality-control samples (field blanks,
   replicates, spikes) and results marked Rejected.
2. Keep results reported as counts per 100 mL (CFU or MPN) and label them with
   one common unit.
3. Flag, but keep, missing, censored, negative and implausibly high values so
   each decision is visible.
4. Remove exact duplicate rows.

The number of rows left after each step is saved in
`data/processed/cleaning_log.csv`.
