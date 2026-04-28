## data-raw/generate_all.R
## Generates all synthetic datasets for the abds package
## Mohamed Jumanne | Applied Bio-Data Science | 2026
## Run with: Rscript data-raw/generate_all.R

set.seed(2026)

# ── Species list (used across multiple datasets) ─────────────────────────────
species_list <- data.frame(
  species = c(
    "Culex sitiens", "Culex pipiens", "Culex quinquefasciatus",
    "Culex univittatus", "Culex antennatus",
    "Anopheles gambiae", "Anopheles funestus", "Anopheles arabiensis",
    "Anopheles coustani", "Anopheles ziemanni",
    "Aedes aegypti", "Aedes vittatus",
    "Mansonia uniformis", "Mansonia africana",
    "Coquillettidia fuscopennata", "Uranotaenia bilineata",
    "Ficalbia uniformis", "Aedomyia africana",
    "Mimomyia splendens", "Culiseta longiareolata"
  ),
  family = c(
    rep("Culicidae", 5),
    rep("Culicidae", 5),
    rep("Culicidae", 2),
    rep("Culicidae", 2),
    rep("Culicidae", 6)
  ),
  functional_group = c(
    rep("nuisance_biter", 5),
    rep("malaria_vector", 5),
    rep("arbovirus_vector", 2),
    rep("filariasis_vector", 2),
    rep("nuisance_biter", 6)
  ),
  stringsAsFactors = FALSE
)

# ── 1. trap_data ─────────────────────────────────────────────────────────────
# The primary teaching dataset used throughout Part I (Chapters 4-9)
# 5 sites x 2 seasons = 10 observations
trap_data <- data.frame(
  site             = rep(c("Site_A","Site_B","Site_C","Site_D","Site_E"), each = 2),
  season           = rep(c("dry","wet"), 5),
  habitat          = c("forest","forest","grassland","grassland","wetland",
                       "wetland","forest","forest","grassland","grassland"),
  distance_water_m = c(240,240,850,850,30,30,410,410,620,620),
  total_count      = c(47,112,14,29,88,203,39,94,11,22),
  stringsAsFactors = FALSE
)

# ── 2. trap_messy ────────────────────────────────────────────────────────────
# Intentionally dirty version of trap_data for Chapters 10-11
# Contains: mixed case, NAs, whitespace errors, a character-encoded number
trap_messy <- data.frame(
  site             = c(" Site_A","Site_A","Site_B","SITE_B","Site_C",
                       "Site_C","Site_D","Site_D","Site_E","Site_E"),
  Season           = c("Dry","Wet","dry","WET","dry","Wet","DRY","wet","dry","wet"),
  Habitat          = c("Forest","forest","Grassland","grassland","Wetland",
                       "wetland","forest","Forest","grassland","Grassland"),
  distance_water_m = c(240,240,850,850,30,30,410,410,620,620),
  total_count      = c("47","112",NA,"29","88","203","39",NA,"11","22"),
  notes            = c("","equipment ok","trap damaged","","","after rain",
                       "","equipment ok","","trap damaged"),
  stringsAsFactors = FALSE
)

# ── 3. site_env ──────────────────────────────────────────────────────────────
# Environmental variables per site — for joining exercises (Chapter 13)
site_env <- data.frame(
  site               = c("Site_A","Site_B","Site_C","Site_D","Site_E"),
  elevation_m        = c(820, 640, 430, 755, 590),
  canopy_cover_pct   = c(78, 12, 5, 71, 18),
  mean_temp_c        = c(22.4, 26.1, 28.7, 23.0, 25.8),
  rainfall_mm_yr     = c(1240, 880, 1650, 1100, 920),
  soil_moisture_pct  = c(42, 18, 68, 35, 22),
  stringsAsFactors   = FALSE
)

# ── 4. survey_multi ──────────────────────────────────────────────────────────
# Multi-year survey: 10 sites x 2 seasons x 6 years = 120 observations
# For Chapters 12, 14, 15
sites_10 <- paste0("Site_", sprintf("%02d", 1:10))
habitats_10 <- c("forest","forest","forest","grassland","grassland",
                  "wetland","wetland","forest","grassland","wetland")
distances_10 <- c(240,410,180,850,620,30,55,320,780,95)

survey_multi <- do.call(rbind, lapply(2019:2024, function(yr) {
  do.call(rbind, lapply(c("dry","wet"), function(seas) {
    base_counts <- c(45,38,62,12,10,96,88,41,15,102)
    year_effect <- (yr - 2019) * 2
    season_mult <- if(seas == "wet") 2.4 else 1.0
    noise       <- rnorm(10, 0, 8)
    counts      <- round(pmax(0, base_counts * season_mult + year_effect + noise))
    trap_nights <- sample(c(3, 4, 5), 10, replace = TRUE)
    data.frame(
      site             = sites_10,
      year             = yr,
      season           = seas,
      habitat          = habitats_10,
      distance_water_m = distances_10,
      trap_nights      = trap_nights,
      total_count      = counts,
      count_per_night  = round(counts / trap_nights, 1),
      stringsAsFactors = FALSE
    )
  }))
}))
rownames(survey_multi) <- NULL

# ── 5. species_records ───────────────────────────────────────────────────────
# Species-level long-format data — for Chapter 15 (species richness)
# 10 sites x 2 seasons x subset of 20 species
sp_probs <- c(0.9,0.8,0.7,0.6,0.55,0.85,0.75,0.65,0.5,0.45,
              0.7,0.4,0.6,0.5,0.55,0.8,0.35,0.65,0.3,0.4)

species_records <- do.call(rbind, lapply(1:10, function(si) {
  do.call(rbind, lapply(c("dry","wet"), function(seas) {
    season_mult <- if(seas == "wet") 1.6 else 1.0
    do.call(rbind, lapply(1:nrow(species_list), function(spi) {
      present <- runif(1) < sp_probs[spi] * season_mult
      if(!present) return(NULL)
      cnt <- rpois(1, lambda = round(sp_probs[spi] * 20 * season_mult))
      if(cnt == 0) cnt <- 1L
      data.frame(
        site             = sites_10[si],
        season           = seas,
        habitat          = habitats_10[si],
        species          = species_list$species[spi],
        family           = species_list$family[spi],
        functional_group = species_list$functional_group[spi],
        count            = as.integer(cnt),
        stringsAsFactors = FALSE
      )
    }))
  }))
}))
rownames(species_records) <- NULL

# ── 6. abundance_matrix ──────────────────────────────────────────────────────
# Wide format: 12 sites x 20 species — Chapter 19-20
sites_12 <- c(sites_10, "Site_11", "Site_12")
habitats_12 <- c(habitats_10, "wetland", "grassland")

abundance_matrix <- as.data.frame(matrix(0L, nrow = 12, ncol = 20))
colnames(abundance_matrix) <- gsub(" ", "_", species_list$species)
abundance_matrix <- cbind(
  data.frame(site = sites_12, habitat = habitats_12, stringsAsFactors = FALSE),
  abundance_matrix
)

for(si in 1:12) {
  is_wet <- habitats_12[si] == "wetland"
  is_for <- habitats_12[si] == "forest"
  for(spi in 1:20) {
    p <- sp_probs[spi]
    if(is_wet) p <- p * 1.4
    if(is_for) p <- p * 1.1
    p <- min(p, 0.98)
    present <- runif(1) < p
    if(present) {
      abundance_matrix[si, spi + 2] <- as.integer(
        rpois(1, lambda = round(p * 30))
      )
    }
  }
}

# ── 7. pa_matrix ─────────────────────────────────────────────────────────────
# Presence/absence version of abundance_matrix — Chapter 21
pa_matrix <- abundance_matrix
pa_matrix[, 3:22] <- ifelse(abundance_matrix[, 3:22] > 0, 1L, 0L)

# ── 8. insect_counts ─────────────────────────────────────────────────────────
# Overdispersed count data for GLM chapters (22, 25)
# 80 trap nights across habitats with environmental predictors
n <- 80
insect_counts <- data.frame(
  trap_id           = paste0("T", sprintf("%03d", 1:n)),
  habitat           = sample(c("forest","grassland","wetland"), n,
                             replace = TRUE, prob = c(0.4,0.3,0.3)),
  season            = sample(c("dry","wet"), n, replace = TRUE),
  vegetation_density = round(runif(n, 10, 95), 1),
  light_intensity    = round(runif(n, 200, 2000), 0),
  distance_water_m   = round(runif(n, 20, 900), 0),
  stringsAsFactors   = FALSE
)
# Generate counts with ecological structure
lambda <- exp(
  2.5 +
  ifelse(insect_counts$habitat == "wetland",  1.2,
  ifelse(insect_counts$habitat == "forest",   0.5, 0)) +
  ifelse(insect_counts$season  == "wet",      0.9, 0) +
  -0.004 * insect_counts$distance_water_m +
   0.008 * insect_counts$vegetation_density +
  rnorm(n, 0, 0.3)
)
insect_counts$total_count <- rnbinom(n, mu = lambda, size = 2)

# ── 9. morphology ────────────────────────────────────────────────────────────
# Individual-level measurements for correlation chapter (23)
# 3 species x 2 sexes x ~25 individuals = ~150 rows
morph_species <- c("Anopheles gambiae","Culex pipiens","Aedes aegypti")
morph_params <- list(
  "Anopheles gambiae" = list(bl = 3.2, wl = 4.1, wt = 1.8),
  "Culex pipiens"     = list(bl = 3.8, wl = 4.8, wt = 2.3),
  "Aedes aegypti"     = list(bl = 2.9, wl = 3.7, wt = 1.5)
)
sex_effect <- list(female = 1.12, male = 1.0)

morphology <- do.call(rbind, lapply(morph_species, function(sp) {
  do.call(rbind, lapply(c("female","male"), function(sx) {
    n_ind <- sample(22:28, 1)
    params <- morph_params[[sp]]
    sf <- sex_effect[[sx]]
    bl <- round(rnorm(n_ind, params$bl * sf, 0.25), 2)
    wl <- round(bl * 1.28 + rnorm(n_ind, 0, 0.15), 2)
    wt <- round((bl * 0.4 + wl * 0.15) * sf + rnorm(n_ind, 0, 0.12), 2)
    trap_site <- sample(sites_10, n_ind, replace = TRUE)
    data.frame(
      individual_id   = paste0(substr(gsub(" ","_",sp),1,3),"_",
                               toupper(substr(sx,1,1)),"_",
                               sprintf("%03d",1:n_ind)),
      species         = sp,
      sex             = sx,
      body_length_mm  = pmax(1.5, bl),
      wing_length_mm  = pmax(2.0, wl),
      weight_mg       = pmax(0.5, wt),
      trap_site       = trap_site,
      stringsAsFactors = FALSE
    )
  }))
}))
rownames(morphology) <- NULL

# ── 10. env_regression ───────────────────────────────────────────────────────
# Abundance + 5 environmental predictors for regression chapters (24-26)
n_reg <- 72
env_regression <- data.frame(
  site_id          = paste0("S", sprintf("%02d", 1:n_reg)),
  habitat          = sample(c("forest","grassland","wetland"), n_reg,
                            replace = TRUE, prob = c(0.35,0.35,0.30)),
  temperature_c    = round(rnorm(n_reg, 25.5, 2.8), 1),
  rainfall_mm      = round(rnorm(n_reg, 1100, 280), 0),
  elevation_m      = round(rnorm(n_reg, 680, 180), 0),
  vegetation_index = round(runif(n_reg, 0.12, 0.88), 3),
  distance_water_m = round(runif(n_reg, 25, 950), 0),
  stringsAsFactors = FALSE
)
env_regression$elevation_m   <- pmax(200, env_regression$elevation_m)
env_regression$temperature_c <- pmax(18, pmin(34, env_regression$temperature_c))
lam_reg <- 1.8 +
  ifelse(env_regression$habitat == "wetland",  1.1,
         ifelse(env_regression$habitat == "forest",   0.4, 0)) +
  -0.003 * env_regression$distance_water_m +
  0.5   * env_regression$vegetation_index +
  -0.002 * env_regression$elevation_m +
  0.001 * env_regression$rainfall_mm +
  rnorm(n_reg, 0, 0.25)

env_regression$abundance <- as.integer(rnbinom(n_reg, mu = exp(lam_reg), size = 3))

# ── 11. sampling_design ──────────────────────────────────────────────────────
# Simulated power curves for sample size chapter (Chapter 29)
# Shows statistical power as a function of sample size and effect size
n_vals  <- rep(seq(5, 100, by = 5), 3)
eff_vals <- rep(c(0.2, 0.5, 0.8), each = length(seq(5, 100, by = 5)))
power_vals <- mapply(function(n, eff) {
  round(pnorm(sqrt(n) * eff / sqrt(2) - qnorm(0.975)), 3)
}, n_vals, eff_vals)

sampling_design <- data.frame(
  n_sites       = n_vals,
  effect_size   = eff_vals,
  effect_label  = ifelse(eff_vals == 0.2, "small",
                  ifelse(eff_vals == 0.5, "medium", "large")),
  power         = pmax(0.01, pmin(0.999, power_vals)),
  stringsAsFactors = FALSE
)

# ── Save all datasets ─────────────────────────────────────────────────────────
datasets <- list(
  trap_data, trap_messy, site_env, survey_multi, species_records,
  abundance_matrix, pa_matrix, insect_counts, morphology,
  env_regression, sampling_design
)
names_list <- c(
  "trap_data","trap_messy","site_env","survey_multi","species_records",
  "abundance_matrix","pa_matrix","insect_counts","morphology",
  "env_regression","sampling_design"
)

for(i in seq_along(datasets)) {
  nm  <- names_list[i]
  obj <- datasets[[i]]
  assign(nm, obj)
  save(list = nm, file = paste0("data/", nm, ".rda"), compress = "bzip2")
  cat(sprintf("  Saved %-22s  [%d rows x %d cols]\n",
              paste0(nm, ".rda"), nrow(obj), ncol(obj)))
}

cat("\nAll", length(datasets), "datasets generated and saved to data/\n")
