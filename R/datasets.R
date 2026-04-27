#' Light trap survey — primary teaching dataset
#'
#' A small, clean dataset representing insect counts from light traps deployed
#' at five sites across two seasons. This is the primary teaching dataset used
#' in Chapters 4 through 9 of \emph{The Biologist's R}. It is intentionally
#' small so that every row can be inspected by eye.
#'
#' @format A data frame with 10 rows and 5 variables:
#' \describe{
#'   \item{site}{Site identifier (character). One of Site_A to Site_E.}
#'   \item{season}{Trapping season (character). Either \code{"dry"} or \code{"wet"}.}
#'   \item{habitat}{Habitat type at the site (character). One of \code{"forest"},
#'     \code{"grassland"}, or \code{"wetland"}.}
#'   \item{distance_water_m}{Distance in metres from the trap to the nearest
#'     permanent water source (numeric).}
#'   \item{total_count}{Total number of insects captured per trap night (numeric).}
#' }
#' @source Synthetic data generated for teaching purposes.
#'   See \code{data-raw/generate_all.R} for the generation script.
#' @seealso \code{\link{trap_messy}} for a deliberately untidy version;
#'   \code{\link{site_env}} for environmental covariates to join.
#' @examples
#' library(abds)
#' head(trap_data)
#' summary(trap_data)
#'
#' # Mean count by habitat
#' aggregate(total_count ~ habitat, data = trap_data, FUN = mean)
"trap_data"


#' Light trap survey — messy version for data cleaning exercises
#'
#' An intentionally untidy version of \code{\link{trap_data}} containing
#' common real-world data quality problems: inconsistent capitalisation,
#' leading whitespace, mixed-case season labels, missing values encoded as
#' \code{NA}, and a numeric column stored as character. Used in Chapters 10
#' and 11 to teach data cleaning workflows.
#'
#' @format A data frame with 10 rows and 6 variables:
#' \describe{
#'   \item{site}{Site identifier with one leading space in row 1 (character).}
#'   \item{Season}{Season label with inconsistent capitalisation: \code{"Dry"},
#'     \code{"dry"}, \code{"WET"}, \code{"wet"}, etc. (character).}
#'   \item{Habitat}{Habitat type with inconsistent capitalisation (character).}
#'   \item{distance_water_m}{Distance to nearest water source in metres (numeric).}
#'   \item{total_count}{Total insect count, stored as character, with two
#'     \code{NA} values (character).}
#'   \item{notes}{Freetext field notes (character).}
#' }
#' @source Synthetic data generated for teaching purposes.
#' @seealso \code{\link{trap_data}} for the clean version.
#' @examples
#' library(abds)
#' str(trap_messy)
#' # Note: total_count is character, not numeric
#' # Note: Season has inconsistent capitalisation
"trap_messy"


#' Site-level environmental variables
#'
#' Environmental measurements recorded at each of the five survey sites.
#' Designed for joining exercises in Chapter 13, where it is linked to
#' \code{\link{trap_data}} by the \code{site} column.
#'
#' @format A data frame with 5 rows and 6 variables:
#' \describe{
#'   \item{site}{Site identifier matching \code{\link{trap_data}} (character).}
#'   \item{elevation_m}{Site elevation above sea level in metres (numeric).}
#'   \item{canopy_cover_pct}{Percentage canopy cover estimated by densiometer (numeric).}
#'   \item{mean_temp_c}{Mean annual air temperature in degrees Celsius (numeric).}
#'   \item{rainfall_mm_yr}{Mean annual rainfall in millimetres (numeric).}
#'   \item{soil_moisture_pct}{Volumetric soil moisture content as a percentage (numeric).}
#' }
#' @source Synthetic data generated for teaching purposes.
#' @seealso \code{\link{trap_data}}
#' @examples
#' library(abds)
#' site_env
#'
#' # Join with trap_data
#' if (requireNamespace("dplyr", quietly = TRUE)) {
#'   dplyr::left_join(trap_data, site_env, by = "site")
#' }
"site_env"


#' Multi-year light trap survey
#'
#' A larger dataset representing six years of trapping at ten sites across
#' two seasons per year. Used in Chapters 12, 14, and 15 to teach grouped
#' summaries, missing value handling, and species richness calculations on
#' larger datasets.
#'
#' @format A data frame with 120 rows and 8 variables:
#' \describe{
#'   \item{site}{Site identifier, Site_01 to Site_10 (character).}
#'   \item{year}{Survey year, 2019 to 2024 (integer).}
#'   \item{season}{Trapping season: \code{"dry"} or \code{"wet"} (character).}
#'   \item{habitat}{Habitat type: \code{"forest"}, \code{"grassland"}, or
#'     \code{"wetland"} (character).}
#'   \item{distance_water_m}{Distance to nearest water source in metres (numeric).}
#'   \item{trap_nights}{Number of trap nights in that site-season combination (integer).}
#'   \item{total_count}{Total insects captured across all trap nights (numeric).}
#'   \item{count_per_night}{Mean count per trap night (numeric).}
#' }
#' @source Synthetic data generated for teaching purposes.
#' @seealso \code{\link{trap_data}} for the simpler single-year version.
#' @examples
#' library(abds)
#' dim(survey_multi)
#' table(survey_multi$habitat, survey_multi$season)
"survey_multi"


#' Species-level insect records — long format
#'
#' Individual species counts from ten sites across two seasons, in long
#' (tidy) format. Each row is one species at one site in one season.
#' Contains 20 Afrotropical insect species from multiple functional groups.
#' Used in Chapter 15 for species richness and diversity calculations.
#'
#' @format A data frame with 301 rows and 7 variables:
#' \describe{
#'   \item{site}{Site identifier, Site_01 to Site_10 (character).}
#'   \item{season}{Trapping season: \code{"dry"} or \code{"wet"} (character).}
#'   \item{habitat}{Habitat type (character).}
#'   \item{species}{Binomial species name (character).}
#'   \item{family}{Taxonomic family (character). All species are Culicidae.}
#'   \item{functional_group}{Ecological functional group (character). One of
#'     \code{"malaria_vector"}, \code{"arbovirus_vector"},
#'     \code{"filariasis_vector"}, or \code{"nuisance_biter"}.}
#'   \item{count}{Number of individuals of this species captured (integer).}
#' }
#' @source Synthetic data generated for teaching purposes.
#' @examples
#' library(abds)
#' # Number of species detected per site-season combination
#' if (requireNamespace("dplyr", quietly = TRUE)) {
#'   dplyr::count(species_records, site, season, name = "n_species")
#' }
"species_records"


#' Species abundance matrix — wide format
#'
#' A site-by-species matrix of insect counts, with 12 sites as rows and
#' 20 species as columns. Used in Chapters 19 and 20 to teach descriptive
#' statistics and data distributions. Contains many zeros, reflecting the
#' typical sparsity of ecological community data.
#'
#' @format A data frame with 12 rows and 22 variables:
#' \describe{
#'   \item{site}{Site identifier (character).}
#'   \item{habitat}{Habitat type (character).}
#'   \item{Culex_sitiens, Culex_pipiens, ...}{One column per species;
#'     values are counts (integer). Species names use underscores instead of
#'     spaces for valid column name syntax.}
#' }
#' @source Synthetic data generated for teaching purposes.
#' @seealso \code{\link{pa_matrix}} for the presence/absence version.
#' @examples
#' library(abds)
#' # Total abundance per species
#' colSums(abundance_matrix[, 3:22])
"abundance_matrix"


#' Presence/absence matrix
#'
#' A binary site-by-species matrix derived from \code{\link{abundance_matrix}}.
#' Values are 1 (species present) or 0 (species absent). Used in Chapter 21
#' to teach presence/absence analysis and occupancy concepts.
#'
#' @format A data frame with 12 rows and 22 variables. Structure is identical
#'   to \code{\link{abundance_matrix}} but species columns contain 0 or 1.
#' @source Synthetic data generated for teaching purposes.
#' @seealso \code{\link{abundance_matrix}}
#' @examples
#' library(abds)
#' # Species richness per site
#' rowSums(pa_matrix[, 3:22])
"pa_matrix"


#' Insect count data for GLM exercises
#'
#' Eighty trap-night records with habitat, season, and three continuous
#' environmental predictors. Counts are overdispersed (negative binomial
#' generating process), making this dataset appropriate for teaching count
#' data analysis and generalised linear models in Chapters 22 and 25.
#'
#' @format A data frame with 80 rows and 7 variables:
#' \describe{
#'   \item{trap_id}{Unique trap identifier (character).}
#'   \item{habitat}{Habitat type (character).}
#'   \item{season}{Trapping season (character).}
#'   \item{vegetation_density}{Percentage vegetation density at the trap site (numeric).}
#'   \item{light_intensity}{Ambient light intensity in lux at time of collection (numeric).}
#'   \item{distance_water_m}{Distance to nearest water source in metres (numeric).}
#'   \item{total_count}{Total insects captured, overdispersed counts (integer).}
#' }
#' @source Synthetic data generated for teaching purposes.
#' @examples
#' library(abds)
#' hist(insect_counts$total_count, breaks = 20,
#'      main = "Distribution of trap counts",
#'      xlab = "Total count")
"insect_counts"


#' Individual morphological measurements
#'
#' Body length, wing length, and weight measurements for individual insects
#' from three species and both sexes. Variables are positively correlated
#' by design, with females larger than males. Used in Chapter 23 to teach
#' correlation analysis.
#'
#' @format A data frame with 134 rows and 7 variables:
#' \describe{
#'   \item{individual_id}{Unique individual identifier (character).}
#'   \item{species}{Species name (character). One of \emph{Anopheles gambiae},
#'     \emph{Culex pipiens}, or \emph{Aedes aegypti}.}
#'   \item{sex}{Sex of the individual: \code{"female"} or \code{"male"} (character).}
#'   \item{body_length_mm}{Body length in millimetres (numeric).}
#'   \item{wing_length_mm}{Wing length in millimetres (numeric).}
#'   \item{weight_mg}{Body weight in milligrams (numeric).}
#'   \item{trap_site}{Site where the individual was captured (character).}
#' }
#' @source Synthetic data generated for teaching purposes.
#' @examples
#' library(abds)
#' # Correlation between body and wing length
#' cor(morphology$body_length_mm, morphology$wing_length_mm)
"morphology"


#' Environmental predictors and abundance for regression
#'
#' Seventy-two site-level records with insect abundance and five environmental
#' predictors. Used in Chapters 24 through 26 to teach simple and multiple
#' regression and generalised linear models. Abundance data have ecological
#' structure: higher in wetlands, declining with elevation and distance to water.
#'
#' @format A data frame with 72 rows and 8 variables:
#' \describe{
#'   \item{site_id}{Unique site identifier (character).}
#'   \item{habitat}{Habitat type (character).}
#'   \item{temperature_c}{Mean temperature in degrees Celsius (numeric).}
#'   \item{rainfall_mm}{Annual rainfall in millimetres (numeric).}
#'   \item{elevation_m}{Elevation above sea level in metres (numeric).}
#'   \item{vegetation_index}{Normalised vegetation index, 0 to 1 (numeric).}
#'   \item{distance_water_m}{Distance to nearest water source in metres (numeric).}
#'   \item{abundance}{Insect abundance count, overdispersed (integer).}
#' }
#' @source Synthetic data generated for teaching purposes.
#' @examples
#' library(abds)
#' plot(abundance ~ distance_water_m, data = env_regression,
#'      col = as.factor(env_regression$habitat),
#'      xlab = "Distance to water (m)", ylab = "Abundance")
"env_regression"


#' Statistical power by sample size and effect size
#'
#' A simulation-derived dataset showing statistical power as a function of
#' sample size (number of sites) and Cohen's d effect size. Used in Chapter 29
#' to teach sample size planning and the concept of statistical power without
#' requiring mathematical derivation.
#'
#' @format A data frame with 60 rows and 4 variables:
#' \describe{
#'   \item{n_sites}{Number of sites (sample size), from 5 to 100 in steps of 5 (integer).}
#'   \item{effect_size}{Cohen's d effect size: 0.2 (small), 0.5 (medium), or 0.8 (large) (numeric).}
#'   \item{effect_label}{Human-readable effect size label (character).}
#'   \item{power}{Estimated statistical power at two-tailed alpha = 0.05 (numeric).}
#' }
#' @source Synthetic data generated for teaching purposes.
#' @examples
#' library(abds)
#' if (requireNamespace("ggplot2", quietly = TRUE)) {
#'   ggplot2::ggplot(sampling_design,
#'                   ggplot2::aes(x = n_sites, y = power,
#'                               colour = effect_label, group = effect_label)) +
#'     ggplot2::geom_line() +
#'     ggplot2::geom_hline(yintercept = 0.8, linetype = "dashed") +
#'     ggplot2::labs(x = "Number of sites", y = "Power", colour = "Effect size")
#' }
"sampling_design"
