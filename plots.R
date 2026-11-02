# Plot functions. Each returns a ggplot object; saving is done by the caller.

library(ggplot2)
library(dplyr)
library(lubridate)

# Horizontal bars for the sites that most often exceed the single-sample limit.
plot_top_sites <- function(site_table, top_n = 15) {
  site_table |>
    slice_max(pct_exceed, n = top_n, with_ties = FALSE) |>
    mutate(site_id = reorder(site_id, pct_exceed)) |>
    ggplot(aes(x = pct_exceed, y = site_id)) +
    geom_col(fill = "#2b6c8f") +
    labs(
      title = "Sites most often over Indiana's single-sample E. coli limit",
      subtitle = "Recreation season samples, sites with at least 20 samples",
      x = "Samples over limit (%)", y = NULL
    ) +
    theme_minimal(base_size = 12)
}

# Distribution of values by month on a log scale, with the limit drawn as a line.
plot_monthly_distribution <- function(clean, limit) {
  clean |>
    filter(qc_flag %in% c("ok", "above_review_limit"), value > 0) |>
    mutate(month = month(date, label = TRUE)) |>
    ggplot(aes(x = month, y = value)) +
    geom_boxplot(outlier.alpha = 0.15, fill = "#d9e8f0") +
    geom_hline(yintercept = limit, linetype = "dashed", colour = "#b23a3a") +
    scale_y_log10() +
    labs(
      title = "E. coli concentration by month",
      subtitle = paste0("Dashed line: single-sample limit (", limit, " per 100 mL)"),
      x = NULL, y = "E. coli per 100 mL (log scale)"
    ) +
    theme_minimal(base_size = 12)
}

# Statewide exceedance rate per year.
plot_yearly_exceedance <- function(yearly) {
  ggplot(yearly, aes(x = year, y = pct_exceed)) +
    geom_line(colour = "#2b6c8f", linewidth = 1) +
    geom_point(colour = "#2b6c8f", size = 2) +
    labs(
      title = "Share of recreation-season samples over the limit, by year",
      x = NULL, y = "Samples over limit (%)"
    ) +
    theme_minimal(base_size = 12)
}
