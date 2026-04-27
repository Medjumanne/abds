# =============================================================================
# R/data.R — roxygen2 documentation for all abds datasets
# =============================================================================

# ── trap_data ─────────────────────────────────────────────────────────────────

#' Light trap insect survey — core dataset
#'
#' A small, clean dataset representing a light trap insect survey conducted
#' across five sites in two seasons. This is the primary dataset used in
#' Part I of \emph{The Biologist's R} (Chapters 4–9). It is intentionally
#' small so that every row can be examined by eye.
#'
#' @format A data frame with 10 rows and 5 variables:
#' \describe{
#'   \item{site}{Site identifier: Site_A through Site_E.}
#'   \item{season}{Survey season: \code{"dry"} or \code{"wet"}.}
#'   \item{habitat}{Dominant habitat at the site: \code{"forest"},
#'     \code{"grassland"}, or \code{"wetland"}.}
#'   \item{distance_water_m}{Distance from the trap to the nearest
#'     permanent water source, in metres.}
#'   \item{total_count}{Total number of insects captured per trap night.}
#' }
#' @source Synthetic data generated for \emph{The Biologist's R}.
#' @seealso \code{\link{trap_messy}} for the messy version;
#'   \code{\link{site_env}} for site-level environmental covariates.
#' @examples
#' data(trap_data)
#' head(trap_data)
#' summary(trap_data)
#'
#' # Mean count by habitat
#' aggregate(total_count ~ habitat, data = trap_data, FUN = mean)
"trap_data"


# ── trap_messy ────────────────────────────────────────────────────────────────

#' Light trap survey — intentionally messy version
#'
#' A messy version of \code{\link{trap_data}} for data-cleaning exercises
#' in Chapters 10–11. Contains all of the following deliberate problems:
#' mixed-case season labels (\code{"Wet"}, \code{"DRY"}),
#' a typo in one site name (\code{"Site_DD"} instead of \code{"Site_D"}),
#' a mixed-type column (\code{distance_water_m} stored as character),
#' and one missing value in \code{total_count}.
#'
#' @format A data frame with 10 rows and 5 variables:
#' \describe{
#'   \item{site}{Site identifier. Contains one typo: \code{"Site_DD"}.}
#'   \item{season}{Survey season. Contains mixed capitalisation:
#'     \code{"dry"}, \code{"wet"}, \code{"Wet"}, \code{"DRY"}.}
#'   \item{habitat}{Dominant habitat. Contains one incorrectly capitalised
#'     value: \code{"Forest"}.}
#'   \item{distance_water_m}{Distance in metres, stored as character.}
#'   \item{total_count}{Insects per trap night. Contains one \code{NA}.}
#' }
#' @source Synthetic data generated for \emph{The Biologist's R}.
#' @seealso \code{\link{trap_data}} for the clean version.
#' @examples
#' data(trap_messy)
#' str(trap_messy)
#' # Spot the problems:
#' unique(trap_messy$season)
#' unique(trap_messy$site)
#' is.na(trap_messy$total_count)
"trap_messy"


# ── site_env ──────────────────────────────────────────────────────────────────

#' Site-level environmental covariates
#'
#' Environmental measurements for each of the five survey sites in
#' \code{\link{trap_data}}. Used in Chapter 13 to demonstrate dataset
#' joining. Joining \code{site_env} to \code{trap_data} on the
#' \code{site} column enriches the trap records with environmental context.
#'
#' @format A data frame with 5 rows and 6 variables:
#' \describe{
#'   \item{site}{Site identifier: Site_A through Site_E. Matches the
#'     \code{site} column in \code{\link{trap_data}}.}
#'   \item{elevation_m}{Elevation above sea level, in metres.}
#'   \item{canopy_cover_pct}{Percentage canopy cover at the site (0–100).}
#'   \item{mean_temp_c}{Mean daily temperature during the survey period,
#'     in degrees Celsius.}
#'   \item{annual_rain_mm}{Mean annual rainfall at the site, in millimetres.}
#'   \item{soil_moisture_pct}{Mean soil moisture content during the
#'     survey period, as a percentage.}
#' }
#' @source Synthetic data generated for \emph{The Biologist's R}.
#' @seealso \code{\link{trap_data}}
#' @examples
#' data(trap_data)
#' data(site_env)
#' # Join environmental data to trap records
#' merged <- merge(trap_data, site_env, by = "site")
#' head(merged)
"site_env"


# ── survey_multi ──────────────────────────────────────────────────────────────

#' Multi-year multi-site insect survey
#'
#' A larger survey dataset covering 6 sites across 2 seasons for 3 years
#' (2023–2025), giving 36 observations. Used in Chapters 12 and 15 to
#' demonstrate grouped summaries, multi-level comparisons, and time trends.
#' Count data show a realistic seasonal effect (wet > dry) and a modest
#' positive trend over the three years.
#'
#' @format A data frame with 36 rows and 8 variables:
#' \describe{
#'   \item{site}{Site name. Six sites: Mto_Mzigo, Kibungo, Uwanja,
#'     Ndege, Msitu_Kuu, Bonde.}
#'   \item{year}{Survey year: 2023, 2024, or 2025.}
#'   \item{season}{Survey season: \code{"dry"} or \code{"wet"}.}
#'   \item{habitat}{Dominant habitat: \code{"forest"}, \code{"grassland"},
#'     \code{"wetland"}, or \code{"savanna"}.}
#'   \item{distance_water_m}{Distance from trap to nearest water, metres.}
#'   \item{trap_nights}{Number of trap nights for this site/season/year.}
#'   \item{total_count}{Total insect count across all trap nights.}
#'   \item{species_richness}{Number of species identified.}
#' }
#' @source Synthetic data generated for \emph{The Biologist's R}.
#' @examples
#' data(survey_multi)
#' # Mean count by habitat and season
#' aggregate(total_count ~ habitat + season, data = survey_multi, FUN = mean)
"survey_multi"


# ── species_records ───────────────────────────────────────────────────────────

#' Species-level light trap records
#'
#' Individual species-level records from 30 trap nights across six sites.
#' Each row represents one species captured at one trap on one night.
#' Used in Chapter 15 to calculate species richness and explore
#' species composition. The 12 species are real mosquito species
#' found in East Africa; counts are synthetic.
#'
#' @format A data frame with approximately 130 rows and 7 variables:
#' \describe{
#'   \item{trap_id}{Unique trap identifier (T001–T030).}
#'   \item{site}{Site name. Matches sites in \code{\link{survey_multi}}.}
#'   \item{season}{Survey season: \code{"dry"} or \code{"wet"}.}
#'   \item{species}{Full binomial species name.}
#'   \item{genus}{Genus name.}
#'   \item{family}{Family name (all Culicidae).}
#'   \item{count}{Number of individuals of this species captured.}
#' }
#' @source Synthetic counts; species names are real East African mosquito
#'   taxa. Generated for \emph{The Biologist's R}.
#' @examples
#' data(species_records)
#' # Species richness per trap
#' tapply(species_records$species, species_records$trap_id,
#'        function(x) length(unique(x)))
"species_records"


# ── abundance_matrix ─────────────────────────────────────────────────────────

#' Species abundance matrix — 12 sites × 15 species
#'
#' A wide-format species-abundance table used for diversity analysis in
#' Chapters 19–20. Each row is a site; columns Sp_A through Sp_O are
#' species with integer abundance counts (zeros included for absences).
#'
#' @format A data frame with 12 rows and 17 variables:
#' \describe{
#'   \item{site}{Site identifier (S01–S12).}
#'   \item{habitat}{Dominant habitat type.}
#'   \item{Sp_A, Sp_B, ..., Sp_O}{Abundance of each of 15 species.
#'     Zero indicates absence.}
#' }
#' @source Synthetic data generated for \emph{The Biologist's R}.
#' @examples
#' data(abundance_matrix)
#' # Total abundance per site
#' rowSums(abundance_matrix[, 3:17])
#' # Species prevalence (proportion of sites where present)
#' colMeans(abundance_matrix[, 3:17] > 0)
"abundance_matrix"


# ── pa_matrix ─────────────────────────────────────────────────────────────────

#' Presence/absence matrix — 15 sites × 20 species
#'
#' A binary presence/absence table used for Chapter 21 exercises on
#' detecting and modelling species occurrence. Each row is a site;
#' columns Species_01 through Species_20 are coded 1 (present) or
#' 0 (absent).
#'
#' @format A data frame with 15 rows and 23 variables:
#' \describe{
#'   \item{site}{Site identifier (Site_01–Site_15).}
#'   \item{habitat}{Dominant habitat type.}
#'   \item{elevation_m}{Site elevation in metres.}
#'   \item{Species_01, ..., Species_20}{Presence (1) or absence (0)
#'     for each of 20 species.}
#' }
#' @source Synthetic data generated for \emph{The Biologist's R}.
#' @examples
#' data(pa_matrix)
#' # Occupancy rate per species
#' colMeans(pa_matrix[, 4:23])
#' # Species richness per site
#' rowSums(pa_matrix[, 4:23])
"pa_matrix"


# ── insect_counts ─────────────────────────────────────────────────────────────

#' Overdispersed insect count data with environmental predictors
#'
#' Eighty trap-night records with count data and associated environmental
#' measurements. Designed to exhibit overdispersion (variance > mean),
#' making it suitable for negative binomial and Poisson GLM exercises
#' in Chapters 22 and 25. The habitat and season effects are strong
#' and clearly detectable.
#'
#' @format A data frame with 80 rows and 9 variables:
#' \describe{
#'   \item{obs_id}{Observation identifier.}
#'   \item{site}{Site identifier (S1–S10).}
#'   \item{habitat}{Habitat type: forest, grassland, wetland, or savanna.}
#'   \item{season}{Survey season: \code{"dry"} or \code{"wet"}.}
#'   \item{trap_nights}{Effort: number of trap nights (1–5).}
#'   \item{temp_c}{Mean temperature during the survey period, Celsius.}
#'   \item{humidity_pct}{Mean relative humidity, percent.}
#'   \item{moon_phase}{Moon illumination fraction at time of trapping (0–1).}
#'   \item{count}{Total insect count across all trap nights.}
#' }
#' @source Synthetic data generated for \emph{The Biologist's R}.
#' @examples
#' data(insect_counts)
#' # Evidence of overdispersion
#' mean(insect_counts$count)
#' var(insect_counts$count)
#' # Count distribution by habitat
#' boxplot(count ~ habitat, data = insect_counts)
"insect_counts"


# ── morphology ────────────────────────────────────────────────────────────────

#' Individual morphological measurements from three mosquito species
#'
#' Morphological measurements from 30 individuals of each of three
#' mosquito species (90 rows total). Body length, wing length, and
#' weight are realistically correlated within species. Used in
#' Chapter 23 to introduce correlation analysis, and as the basis
#' for species comparison exercises.
#'
#' @format A data frame with 90 rows and 6 variables:
#' \describe{
#'   \item{individual_id}{Unique individual identifier.}
#'   \item{species}{Species name: \emph{Anopheles gambiae},
#'     \emph{Culex quinquefasciatus}, or \emph{Aedes aegypti}.}
#'   \item{sex}{\code{"female"} or \code{"male"}. Females are
#'     more common (60:40 ratio), reflecting typical trap catches.}
#'   \item{body_length_mm}{Body length from head to abdomen tip, mm.}
#'   \item{wing_length_mm}{Wing length from base to tip, mm.}
#'   \item{weight_mg}{Individual dry weight, mg.}
#' }
#' @source Synthetic data generated for \emph{The Biologist's R}.
#'   Species names are real; measurements are synthetic but consistent
#'   with published ranges for these taxa.
#' @examples
#' data(morphology)
#' # Correlation between body length and wing length
#' cor(morphology$body_length_mm, morphology$wing_length_mm)
#' # Mean body length by species
#' aggregate(body_length_mm ~ species, data = morphology, FUN = mean)
"morphology"


# ── env_regression ────────────────────────────────────────────────────────────

#' Insect abundance with five environmental predictors
#'
#' A 100-row dataset designed for regression exercises in Chapters 24–26.
#' Abundance is a function of vegetation index, distance to water, and
#' rainfall, with realistic noise. The dataset supports both linear and
#' generalised linear modelling and includes enough predictors to
#' demonstrate model selection.
#'
#' @format A data frame with 100 rows and 8 variables:
#' \describe{
#'   \item{site_id}{Site identifier (SITE_001–SITE_100).}
#'   \item{habitat}{Habitat type: forest, grassland, wetland, or savanna.}
#'   \item{elevation_m}{Site elevation, metres.}
#'   \item{temperature_c}{Mean temperature, Celsius. Decreases with elevation.}
#'   \item{rainfall_mm}{Annual rainfall, mm. Decreases slightly with elevation.}
#'   \item{vegetation_index}{Normalised vegetation index (0–1). Increases
#'     with rainfall.}
#'   \item{distance_water_m}{Distance to nearest permanent water, metres.}
#'   \item{abundance}{Insect abundance (count). Driven primarily by
#'     vegetation index and distance to water.}
#' }
#' @source Synthetic data generated for \emph{The Biologist's R}.
#' @examples
#' data(env_regression)
#' # Simple linear regression
#' mod <- lm(abundance ~ vegetation_index + distance_water_m, data = env_regression)
#' summary(mod)
"env_regression"


# ── sampling_design ───────────────────────────────────────────────────────────

#' Statistical power as a function of sample size and effect size
#'
#' An illustrative dataset showing how statistical power and confidence
#' interval width change with sample size for three common effect sizes
#' (small, medium, large). Used in Chapters 27–29 to build intuition about
#' sample size, power, and the precision of estimates without requiring
#' readers to run simulations themselves.
#'
#' @format A data frame with 30 rows and 5 variables:
#' \describe{
#'   \item{n_sites}{Number of sites (sample size): 5, 10, 15, 20, 30,
#'     40, 60, 80, 100, 120.}
#'   \item{effect_size}{Cohen's d: 0.2 (small), 0.5 (medium), 0.8 (large).}
#'   \item{power}{Statistical power (0–1) for a two-sample t-test at
#'     alpha = 0.05.}
#'   \item{ci_width}{Width of the 95% confidence interval for a mean
#'     estimated from \code{n_sites} observations with SD = 1.}
#'   \item{effect_label}{Factor label for plotting: "d = 0.2" etc.}
#' }
#' @source Computed analytically using the t-distribution.
#'   Generated for \emph{The Biologist's R}.
#' @examples
#' data(sampling_design)
#' # Power to detect a medium effect at n = 30
#' subset(sampling_design, n_sites == 30 & effect_size == 0.5)
#' # Plot power curves
#' plot(power ~ n_sites, data = subset(sampling_design, effect_size == 0.5),
#'      type = "l", xlab = "Sample size", ylab = "Power")
"sampling_design"
