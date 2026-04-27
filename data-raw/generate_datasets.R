#!/usr/bin/env Rscript
# =============================================================================
# data-raw/generate_datasets.R
# Applied Bio-Data Science (abds) package — dataset generation
# Mohamed Jumanne | 2026
# Run this script to regenerate all package datasets from scratch.
# =============================================================================

set.seed(2026)  # fixed seed — all datasets are fully reproducible

PKG <- "/home/claude/abds"

# ── helpers ───────────────────────────────────────────────────────────────────
save_dataset <- function(obj, name) {
  path <- file.path(PKG, "data", paste0(name, ".rda"))
  save(list = name, file = path, envir = parent.frame(), compress = "xz")
  cat(sprintf("  saved: %s (%d rows x %d cols)\n",
              name, nrow(get(name, envir = parent.frame())),
              ncol(get(name, envir = parent.frame()))))
}

# ── 1. trap_data ─────────────────────────────────────────────────────────────
# Core dataset used throughout Part I (Chapters 4–9).
# Light trap insect survey: 5 sites × 2 seasons = 10 observations.
trap_data <- data.frame(
  site             = rep(c("Site_A","Site_B","Site_C","Site_D","Site_E"), each = 2),
  season           = rep(c("dry","wet"), 5),
  habitat          = rep(c("forest","grassland","wetland","forest","grassland"), each = 2),
  distance_water_m = rep(c(240, 850, 30, 410, 620), each = 2),
  total_count      = c(47, 112, 14, 29, 88, 203, 39, 94, 11, 22),
  stringsAsFactors = FALSE
)
save(trap_data, file = file.path(PKG, "data", "trap_data.rda"), compress = "xz")
cat("  saved: trap_data (10 x 5)\n")

# ── 2. trap_messy ────────────────────────────────────────────────────────────
# Intentionally messy version of trap_data for data-cleaning exercises
# (Chapters 10–11). Contains: mixed-case seasons, typo in site name,
# one NA count, one character intruding in a numeric column.
trap_messy <- data.frame(
  site             = c("Site_A","Site_A","Site_B","Site_B","Site_C",
                       "Site_C","Site_DD","Site_D","Site_E","Site_E"),
  season           = c("dry","Wet","dry","wet","DRY",
                       "wet","dry","wet","dry","wet"),
  habitat          = c("Forest","grassland","grassland","grassland","wetland",
                       "wetland","forest","forest","grassland","grassland"),
  distance_water_m = c("240","240","850","850","30",
                       "30","410","410","620","620"),
  total_count      = c(47, 112, 14, 29, 88, 203, 39, NA, 11, 22),
  stringsAsFactors = FALSE
)
save(trap_messy, file = file.path(PKG, "data", "trap_messy.rda"), compress = "xz")
cat("  saved: trap_messy (10 x 5)\n")

# ── 3. site_env ──────────────────────────────────────────────────────────────
# Environmental covariates for each of the five survey sites.
# Used for join exercises in Chapter 13.
site_env <- data.frame(
  site              = c("Site_A","Site_B","Site_C","Site_D","Site_E"),
  elevation_m       = c(820, 1105, 340, 760, 990),
  canopy_cover_pct  = c(72, 18, 5, 65, 22),
  mean_temp_c       = c(22.4, 19.8, 26.1, 23.0, 20.5),
  annual_rain_mm    = c(1240, 680, 1850, 1100, 710),
  soil_moisture_pct = c(38, 14, 71, 32, 17),
  stringsAsFactors  = FALSE
)
save(site_env, file = file.path(PKG, "data", "site_env.rda"), compress = "xz")
cat("  saved: site_env (5 x 6)\n")

# ── 4. survey_multi ──────────────────────────────────────────────────────────
# Multi-year, multi-site survey: 6 sites × 2 seasons × 3 years = 36 rows.
# Used for grouping, summarising, and time-series exercises (Chapters 12, 15).
sites_m   <- c("Mto_Mzigo","Kibungo","Uwanja","Ndege","Msitu_Kuu","Bonde")
habitats_m <- c("wetland","forest","savanna","grassland","forest","wetland")
dist_m     <- c(25, 310, 720, 580, 180, 45)

rows <- expand.grid(year   = 2023:2025,
                    season = c("dry","wet"),
                    site   = sites_m,
                    stringsAsFactors = FALSE)

hab_map  <- setNames(habitats_m, sites_m)
dist_map <- setNames(dist_m,     sites_m)

rows$habitat          <- hab_map[rows$site]
rows$distance_water_m <- dist_map[rows$site]
rows$trap_nights      <- sample(3:7, nrow(rows), replace = TRUE)

# simulate counts: wetland/forest > grassland/savanna; wet > dry; trend over years
base_count <- ifelse(rows$habitat %in% c("wetland","forest"), 80, 25)
season_eff <- ifelse(rows$season == "wet", 1.8, 1.0)
year_eff   <- 1 + 0.06 * (rows$year - 2023)
mu         <- base_count * season_eff * year_eff *
              exp(rnorm(nrow(rows), 0, 0.25))

rows$total_count     <- round(pmax(mu, 1))
rows$species_richness <- round(pmin(rows$total_count / 4 +
                                    rnorm(nrow(rows), 0, 1.5), 28))
rows$species_richness <- pmax(rows$species_richness, 1)

survey_multi <- rows[, c("site","year","season","habitat",
                          "distance_water_m","trap_nights",
                          "total_count","species_richness")]
survey_multi <- survey_multi[order(survey_multi$site,
                                   survey_multi$year,
                                   survey_multi$season), ]
rownames(survey_multi) <- NULL
save(survey_multi, file = file.path(PKG, "data", "survey_multi.rda"), compress = "xz")
cat(sprintf("  saved: survey_multi (%d x %d)\n", nrow(survey_multi), ncol(survey_multi)))

# ── 5. species_records ───────────────────────────────────────────────────────
# Species-level trap records: one row per species per trap night.
# Used for species richness calculations (Chapter 15).
spp <- data.frame(
  species = c("Anopheles gambiae","Anopheles funestus","Anopheles coustani",
              "Culex quinquefasciatus","Culex univittatus","Culex pipiens",
              "Aedes aegypti","Mansonia uniformis","Coquillettidia aurites",
              "Uranotaenia bilineata","Ficalbia uniformis","Aedomyia africana"),
  genus   = c("Anopheles","Anopheles","Anopheles","Culex","Culex","Culex",
              "Aedes","Mansonia","Coquillettidia","Uranotaenia","Ficalbia","Aedomyia"),
  family  = rep("Culicidae", 12),
  pref_habitat = c("wetland","forest","wetland","urban","savanna","urban",
                   "urban","wetland","wetland","forest","forest","wetland"),
  stringsAsFactors = FALSE
)

trap_ids <- paste0("T", sprintf("%03d", 1:30))
trap_sites <- sample(c("Mto_Mzigo","Kibungo","Uwanja","Ndege","Msitu_Kuu","Bonde"),
                     30, replace = TRUE)
trap_seasons <- sample(c("dry","wet"), 30, replace = TRUE, prob = c(0.4, 0.6))

records <- lapply(seq_along(trap_ids), function(i) {
  n_spp <- sample(2:7, 1)
  chosen <- sample(nrow(spp), n_spp)
  site_hab <- habitats_m[match(trap_sites[i], sites_m)]
  # species more likely if habitat matches preference
  probs <- ifelse(spp$pref_habitat[chosen] == site_hab, 3, 1)
  cnt <- round(rpois(n_spp, lambda = ifelse(trap_seasons[i]=="wet", 18, 8) * probs/mean(probs)))
  cnt <- pmax(cnt, 1)
  data.frame(
    trap_id = trap_ids[i],
    site    = trap_sites[i],
    season  = trap_seasons[i],
    species = spp$species[chosen],
    genus   = spp$genus[chosen],
    family  = spp$family[chosen],
    count   = cnt,
    stringsAsFactors = FALSE
  )
})

species_records <- do.call(rbind, records)
species_records <- species_records[order(species_records$trap_id,
                                         species_records$species), ]
rownames(species_records) <- NULL
save(species_records, file = file.path(PKG, "data", "species_records.rda"), compress = "xz")
cat(sprintf("  saved: species_records (%d x %d)\n",
            nrow(species_records), ncol(species_records)))

# ── 6. abundance_matrix ──────────────────────────────────────────────────────
# Wide-format species-abundance matrix: 12 sites × 15 species + metadata.
# Used for diversity indices and multivariate overview (Chapters 19–20).
sites_ab <- paste0("S", sprintf("%02d", 1:12))
hab_ab   <- sample(c("forest","grassland","wetland","savanna"), 12,
                   replace = TRUE, prob = c(0.3,0.3,0.2,0.2))
sp_names <- paste0("Sp_", LETTERS[1:15])

mat <- matrix(0, nrow = 12, ncol = 15,
              dimnames = list(sites_ab, sp_names))

for (i in 1:12) {
  n_present <- sample(5:12, 1)
  present   <- sample(15, n_present)
  for (j in present) {
    mat[i, j] <- round(rnbinom(1, mu = 20, size = 2))
  }
}

abundance_matrix <- data.frame(site    = sites_ab,
                                habitat = hab_ab,
                                mat,
                                stringsAsFactors = FALSE)
save(abundance_matrix, file = file.path(PKG, "data", "abundance_matrix.rda"), compress = "xz")
cat(sprintf("  saved: abundance_matrix (%d x %d)\n",
            nrow(abundance_matrix), ncol(abundance_matrix)))

# ── 7. pa_matrix ─────────────────────────────────────────────────────────────
# Presence/absence matrix: 15 sites × 20 species + site metadata.
# Used for presence/absence analysis (Chapter 21).
sites_pa  <- paste0("Site_", sprintf("%02d", 1:15))
hab_pa    <- sample(c("forest","grassland","wetland","savanna","riparian"),
                    15, replace = TRUE)
elev_pa   <- round(rnorm(15, 800, 200))
sp_pa     <- paste0("Species_", sprintf("%02d", 1:20))

pa_mat <- matrix(0, nrow = 15, ncol = 20,
                 dimnames = list(sites_pa, sp_pa))
for (i in 1:15) {
  occ <- sample(20, sample(6:16, 1))
  pa_mat[i, occ] <- 1
}

pa_matrix <- data.frame(site        = sites_pa,
                         habitat     = hab_pa,
                         elevation_m = elev_pa,
                         pa_mat,
                         stringsAsFactors = FALSE)
save(pa_matrix, file = file.path(PKG, "data", "pa_matrix.rda"), compress = "xz")
cat(sprintf("  saved: pa_matrix (%d x %d)\n", nrow(pa_matrix), ncol(pa_matrix)))

# ── 8. insect_counts ─────────────────────────────────────────────────────────
# Overdispersed count data with habitat and environmental predictors.
# Used for GLM and Poisson regression exercises (Chapters 22, 25).
n <- 80
insect_counts <- data.frame(
  obs_id      = sprintf("OBS_%03d", 1:n),
  site        = sample(paste0("S",1:10), n, replace = TRUE),
  habitat     = sample(c("forest","grassland","wetland","savanna"),
                       n, replace = TRUE, prob = c(0.3,0.25,0.25,0.2)),
  season      = sample(c("dry","wet"), n, replace = TRUE, prob = c(0.45,0.55)),
  trap_nights = sample(1:5, n, replace = TRUE),
  stringsAsFactors = FALSE
)

insect_counts$temp_c      <- round(rnorm(n, 24, 3), 1)
insect_counts$humidity_pct <- round(pmin(pmax(rnorm(n, 65, 15), 20), 98), 1)
insect_counts$moon_phase  <- round(runif(n, 0, 1), 2)

hab_mu <- c(forest = 45, grassland = 12, wetland = 90, savanna = 18)
sea_mu <- c(dry = 0.6, wet = 1.4)

mu_count <- hab_mu[insect_counts$habitat] *
            sea_mu[insect_counts$season] *
            insect_counts$trap_nights *
            exp(0.04 * (insect_counts$humidity_pct - 65)) *
            exp(rnorm(n, 0, 0.3))

insect_counts$count <- round(pmax(rnbinom(n, mu = mu_count, size = 1.5), 0))
save(insect_counts, file = file.path(PKG, "data", "insect_counts.rda"), compress = "xz")
cat(sprintf("  saved: insect_counts (%d x %d)\n",
            nrow(insect_counts), ncol(insect_counts)))

# ── 9. morphology ────────────────────────────────────────────────────────────
# Individual morphological measurements: 3 mosquito species × 30 individuals.
# Used for correlation and comparison exercises (Chapter 23).
n_per <- 30
spp_m <- c("Anopheles gambiae","Culex quinquefasciatus","Aedes aegypti")

morph_list <- lapply(seq_along(spp_m), function(i) {
  params <- list(
    bl_mu = c(3.1, 3.8, 2.9)[i],
    wl_mu = c(2.9, 3.5, 2.7)[i],
    wt_mu = c(1.8, 2.3, 1.6)[i]
  )
  bl <- round(rnorm(n_per, params$bl_mu, 0.25), 2)
  wl <- round(bl * runif(n_per, 0.88, 0.96) + rnorm(n_per, 0, 0.05), 2)
  wt <- round(bl^2 * 0.17 + rnorm(n_per, 0, 0.08), 3)
  data.frame(
    individual_id  = paste0(substr(gsub(" ","_",spp_m[i]),1,2),
                            sprintf("%02d", 1:n_per)),
    species        = spp_m[i],
    sex            = sample(c("female","male"), n_per,
                            replace = TRUE, prob = c(0.6,0.4)),
    body_length_mm = pmax(bl, 1.5),
    wing_length_mm = pmax(wl, 1.2),
    weight_mg      = pmax(wt, 0.3),
    stringsAsFactors = FALSE
  )
})

morphology <- do.call(rbind, morph_list)
rownames(morphology) <- NULL
save(morphology, file = file.path(PKG, "data", "morphology.rda"), compress = "xz")
cat(sprintf("  saved: morphology (%d x %d)\n",
            nrow(morphology), ncol(morphology)))

# ── 10. env_regression ───────────────────────────────────────────────────────
# Abundance with five environmental predictors for regression exercises
# (Chapters 24–26).
n <- 100
env_regression <- data.frame(
  site_id     = sprintf("SITE_%03d", 1:n),
  habitat     = sample(c("forest","grassland","wetland","savanna"),
                       n, replace = TRUE),
  elevation_m = round(rnorm(n, 750, 250)),
  stringsAsFactors = FALSE
)

env_regression$temperature_c    <- round(28 - env_regression$elevation_m * 0.006 +
                                         rnorm(n, 0, 1.2), 1)
env_regression$rainfall_mm      <- round(pmax(1200 - env_regression$elevation_m * 0.5 +
                                         rnorm(n, 0, 120), 200))
env_regression$vegetation_index <- round(pmin(pmax(
  0.3 + 0.0002 * env_regression$rainfall_mm +
  rnorm(n, 0, 0.08), 0.1), 0.95), 3)
env_regression$distance_water_m <- round(pmax(
  rlnorm(n, meanlog = 5.5, sdlog = 0.8), 10))

log_mu <- -2 +
  0.8 * env_regression$vegetation_index +
  -0.003 * env_regression$distance_water_m +
  0.05 * env_regression$rainfall_mm / 100 +
  rnorm(n, 0, 0.4)

env_regression$abundance <- round(pmax(exp(log_mu) + rnorm(n, 0, 2), 0))
save(env_regression, file = file.path(PKG, "data", "env_regression.rda"), compress = "xz")
cat(sprintf("  saved: env_regression (%d x %d)\n",
            nrow(env_regression), ncol(env_regression)))

# ── 11. sampling_design ──────────────────────────────────────────────────────
# Illustrative dataset showing statistical power as a function of
# sample size and effect size. Used in Chapters 27–29.
effect_sizes <- c(0.2, 0.5, 0.8)
n_values     <- c(5, 10, 15, 20, 30, 40, 60, 80, 100, 120)

sd_rows <- expand.grid(n_sites    = n_values,
                       effect_size = effect_sizes,
                       stringsAsFactors = FALSE)

power_calc <- function(n, d, alpha = 0.05) {
  ncp <- d * sqrt(n / 2)
  crit <- qt(1 - alpha/2, df = 2*n - 2)
  1 - pt(crit, df = 2*n - 2, ncp = ncp) +
      pt(-crit, df = 2*n - 2, ncp = ncp)
}

sd_rows$power       <- round(mapply(power_calc, sd_rows$n_sites,
                                    sd_rows$effect_size), 3)
sd_rows$ci_width    <- round(2 * qt(0.975, df = sd_rows$n_sites - 1) *
                              1 / sqrt(sd_rows$n_sites), 3)
sd_rows$effect_label <- factor(
  paste0("d = ", sd_rows$effect_size),
  levels = c("d = 0.2","d = 0.5","d = 0.8")
)

sampling_design <- sd_rows[order(sd_rows$effect_size, sd_rows$n_sites), ]
rownames(sampling_design) <- NULL
save(sampling_design, file = file.path(PKG, "data", "sampling_design.rda"), compress = "xz")
cat(sprintf("  saved: sampling_design (%d x %d)\n",
            nrow(sampling_design), ncol(sampling_design)))

cat("\nAll 11 datasets generated and saved to", file.path(PKG, "data"), "\n")
