# Runs the whole pipeline from the project root: Rscript run_all.R
# Skips the download if the raw file already exists.

source("R/config.R")
if (!file.exists(RAW_PATH)) source("scripts/01_download.R")
source("scripts/02_clean.R")
source("scripts/03_analyze.R")
rmarkdown::render("report/report.Rmd", output_dir = "report", knit_root_dir = getwd())
