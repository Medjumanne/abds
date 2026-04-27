#' abds: Datasets for 'The Biologist's R'
#'
#' A collection of synthetic but ecologically realistic datasets designed to
#' accompany \emph{The Biologist's R: A Practical Introduction to Data Analysis
#' for Field Scientists} by Mohamed Jumanne (Applied Bio-Data Science, 2026).
#'
#' All datasets represent insect survey data from a fictional tropical landscape
#' and progress in complexity from Chapter 4 through Chapter 35. Install the
#' package once; every dataset in the book is then available with a single
#' \code{library(abds)} call.
#'
#' @section Available datasets:
#' \describe{
#'   \item{\code{\link{trap_data}}}{Primary teaching dataset. 5 sites, 2 seasons (10 rows). Used in Chapters 4--9.}
#'   \item{\code{\link{trap_messy}}}{Intentionally dirty version of trap_data. Used in Chapters 10--11.}
#'   \item{\code{\link{site_env}}}{Environmental variables per site for joining. Used in Chapter 13.}
#'   \item{\code{\link{survey_multi}}}{Multi-year survey, 10 sites x 2 seasons x 6 years (120 rows). Used in Chapters 12, 14--15.}
#'   \item{\code{\link{species_records}}}{Species-level long-format records (301 rows). Used in Chapter 15.}
#'   \item{\code{\link{abundance_matrix}}}{Wide-format species abundance matrix, 12 sites x 20 species. Used in Chapters 19--20.}
#'   \item{\code{\link{pa_matrix}}}{Presence/absence version of abundance_matrix. Used in Chapter 21.}
#'   \item{\code{\link{insect_counts}}}{Overdispersed count data with environmental predictors (80 rows). Used in Chapters 22, 25.}
#'   \item{\code{\link{morphology}}}{Individual-level morphological measurements (134 rows). Used in Chapter 23.}
#'   \item{\code{\link{env_regression}}}{Abundance and five environmental predictors (72 rows). Used in Chapters 24--26.}
#'   \item{\code{\link{sampling_design}}}{Simulated power curves by sample size and effect size. Used in Chapter 29.}
#' }
#'
#' @section Usage:
#' \preformatted{
#' # Install from GitHub
#' # install.packages("remotes")
#' # remotes::install_github("MohamedJumanne/abds")
#'
#' library(abds)
#' head(trap_data)
#' }
#'
#' @docType package
#' @name abds-package
#' @aliases abds
NULL
