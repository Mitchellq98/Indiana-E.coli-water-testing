# Runs the analysis on the cleaned data and saves tables and figures.
# Run from the project root: Rscript scripts/03_analyze.R

library(readr)
library(ggplot2)
source("R/config.R")
source("R/analyze.R")
source("R/plots.R")

clean <- read_csv(CLEAN_PATH, show_col_types = FALSE)
season <- recreation_season(clean, RECREATION_MONTHS)

sites  <- site_exceedance(season, SINGLE_SAMPLE_LIMIT)
yearly <- yearly_exceedance(season, SINGLE_SAMPLE_LIMIT)

dir.create("output", showWarnings = FALSE)
write_csv(sites, "output/site_exceedance.csv")
write_csv(yearly, "output/yearly_exceedance.csv")

dir.create(FIG_DIR, showWarnings = FALSE)
ggsave(file.path(FIG_DIR, "top_sites.png"), plot_top_sites(sites), width = 8, height = 6, dpi = 150)
ggsave(file.path(FIG_DIR, "monthly_distribution.png"),
       plot_monthly_distribution(clean, SINGLE_SAMPLE_LIMIT), width = 8, height = 5, dpi = 150)
ggsave(file.path(FIG_DIR, "yearly_exceedance.png"),
       plot_yearly_exceedance(yearly), width = 8, height = 4.5, dpi = 150)

message("Season samples: ", nrow(season), " | Sites analyzed: ", nrow(sites))
print(head(sites, 10))
