# abds <img src="man/figures/logo.png" align="right" height="139" alt="" />

<!-- badges: start -->
[![R package](https://img.shields.io/badge/R-package-276DC3)](https://www.r-project.org/)
[![License: CC BY 4.0](https://img.shields.io/badge/License-CC%20BY%204.0-lightgrey.svg)](https://creativecommons.org/licenses/by/4.0/)
[![GitHub](https://img.shields.io/github/v/release/MohamedJumanne/abds)](https://github.com/MohamedJumanne/abds)
<!-- badges: end -->

**Applied Bio-Data Science** companion datasets for  
*The Biologist's R: A Practical Introduction to Data Analysis for Field Scientists*  
by Mohamed Jumanne

---

## Overview

`abds` provides eleven synthetic but ecologically realistic datasets designed
to accompany *The Biologist's R*. All datasets represent insect survey data
from a fictional tropical landscape and are structured to teach progressive
analytical skills — from data import and cleaning through to generalised
linear modelling and statistical power analysis.

Every dataset in the book is available with a single `library(abds)` call.
No manual file creation required.

---

## Installation

```r
# Install from GitHub (requires the remotes package)
install.packages("remotes")
remotes::install_github("Medjumanne/abds")
```

---

## Datasets

| Dataset | Rows | Cols | Used in | Description |
|---|---|---|---|---|
| `trap_data` | 10 | 5 | Ch. 4–9 | Primary teaching dataset. 5 sites × 2 seasons. |
| `trap_messy` | 10 | 6 | Ch. 10–11 | Intentionally dirty version for cleaning exercises. |
| `site_env` | 5 | 6 | Ch. 13 | Environmental variables per site for joining. |
| `survey_multi` | 120 | 8 | Ch. 12, 14–15 | Six-year multi-site survey. |
| `species_records` | 301 | 7 | Ch. 15 | Species-level long-format records. |
| `abundance_matrix` | 12 | 22 | Ch. 19–20 | Wide-format species abundance matrix. |
| `pa_matrix` | 12 | 22 | Ch. 21 | Presence/absence version of abundance_matrix. |
| `insect_counts` | 80 | 7 | Ch. 22, 25 | Overdispersed counts with environmental predictors. |
| `morphology` | 134 | 7 | Ch. 23 | Individual-level morphological measurements. |
| `env_regression` | 72 | 8 | Ch. 24–26 | Abundance and five environmental predictors. |
| `sampling_design` | 60 | 4 | Ch. 29 | Simulated power curves. |

---

## Quick start

```r
library(abds)

# The primary dataset — used throughout Part I
head(trap_data)

# Mean count by habitat and season
library(dplyr)
trap_data %>%
  group_by(habitat, season) %>%
  summarise(mean_count = mean(total_count), .groups = "drop")

# Your first ggplot
library(ggplot2)
ggplot(trap_data, aes(x = distance_water_m, y = total_count,
                      colour = habitat)) +
  geom_point(size = 3) +
  labs(x = "Distance to water (m)", y = "Total count",
       colour = "Habitat")
```

---

## The ecological story

All datasets share a consistent fictional landscape:

- **Study system:** Afrotropical insects surveyed by light trap
- **Sites:** Five core sites (Site_A to Site_E) in Part I; ten sites (Site_01 to Site_10) in Parts II–IV
- **Habitats:** Forest, grassland, and wetland
- **Species:** Twenty Afrotropical Culicidae species across four functional groups
- **Environmental gradient:** Abundance declines with distance from water and elevation; increases in wetland habitats and during the wet season

This consistency means datasets from different chapters can be joined, compared, and extended. The data are coherent, not arbitrary.

---

## Reproducibility

All datasets were generated with `set.seed(2026)`. The generation script is
available in `data-raw/generate_all.R`. To regenerate all datasets from
scratch:

```r
source("data-raw/generate_all.R")
```

---

## Citation

If you use `abds` in teaching or research, please cite:

> Jumanne, M. (2026). *The Biologist's R: A Practical Introduction to Data
> Analysis for Field Scientists*. Applied Bio-Data Science.
> https://github.com/MohamedJumanne/abds

---

## About ABDS

Applied Bio-Data Science is a platform dedicated to making R-based analytics
accessible to field scientists with biological training.

- LinkedIn: [Applied Bio-Data Science](https://linkedin.com/company/113216209)
- GitHub: [Medjumanne](https://github.com/Medjumanne)

---

## License

Data are released under [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/).
You are free to use, share, and adapt all datasets with attribution.
