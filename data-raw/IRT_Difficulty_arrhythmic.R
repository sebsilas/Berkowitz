
options(scipen = 999)

library(tidyverse)
library(magrittr)


##

Berkowitz_IRT_arrhythmic <- ngram_item_bank %>%
  tibble::as_tibble() %>%
  dplyr::filter(N > 2)

Berkowitz_IRT_arrhythmic_phrases <- phrase_item_bank %>%
  tibble::as_tibble() %>%
  dplyr::filter(N > 2)


Berkowitz_IRT_arrhythmic <- Berkowitz_IRT_arrhythmic %>%
  select(melody, N, step.cont.loc.var, tonalness, log_freq)

Berkowitz_IRT_arrhythmic_phrases <- Berkowitz_IRT_arrhythmic_phrases %>%
  select(melody, N, step.cont.loc.var, tonalness) %>%
  mutate(log_freq = NA)


Berkowitz_IRT_arrhythmic <- Berkowitz_IRT_arrhythmic %>%
  rbind(Berkowitz_IRT_arrhythmic_phrases)



difficulty <- predict(Berkowitz::lm2.2,
                      newdata = Berkowitz_IRT_arrhythmic,
                      re.form = NA) # this instructs the model to predict without random effects )

difficulty <- difficulty %>% as.numeric %>%
  multiply_by(-1) %>%
  scales::rescale()

Berkowitz_IRT_arrhythmic$difficulty <- as.numeric(difficulty)

Berkowitz_IRT_arrhythmic <- Berkowitz_IRT_arrhythmic %>% unique()

use_data(Berkowitz_IRT_arrhythmic, overwrite = TRUE)

# scaled

Berkowitz_IRT_arrhythmic_scaled <- Berkowitz_IRT_arrhythmic %>%
  select(melody, N, step.cont.loc.var, tonalness, log_freq) %>%
  mutate(across(N:log_freq, ~ as.numeric(scale(.x))))

difficulty <- predict(Berkowitz::lm2.2_scaled,
                      newdata = Berkowitz_IRT_arrhythmic_scaled,
                      re.form = NA) # this instructs the model to predict without random effects )

difficulty <- difficulty %>% as.numeric %>%
  multiply_by(-1) %>%
  scale()

Berkowitz_IRT_arrhythmic_scaled$difficulty <- as.numeric(difficulty)

Berkowitz_IRT_arrhythmic_scaled <- Berkowitz_IRT_arrhythmic_scaled %>% unique()

Berkowitz_IRT_arrhythmic_scaled %>% select(-melody) %>% itembankr::hist_item_bank()


Berkowitz_IRT_arrhythmic_scale_factors <- Berkowitz_IRT_arrhythmic %>%
  summarise(across(N:log_freq, range, na.rm = TRUE))

use_data(Berkowitz_IRT_arrhythmic_scaled, overwrite = TRUE)
use_data(Berkowitz_IRT_arrhythmic_scale_factors, overwrite = TRUE)



# length only


load(file = 'data/lm_arrhythmic_length_only.rda')
load(file = 'data/Berkowitz_arrhythmic_mixed_effects_model_scaled.rda')


Berkowitz_IRT_arrhythmic <- Berkowitz("main") %>%
  dplyr::filter(N > 2)


Berkowitz_IRT_arrhythmic_length_only <- Berkowitz_IRT_arrhythmic %>%
  select(melody, N)

difficulty <- predict(lm_arrhythmic_length_only,
                      newdata = Berkowitz_IRT_arrhythmic,
                      re.form = NA) # this instructs the model to predict without random effects )

difficulty <- difficulty %>% as.numeric %>%
  multiply_by(-1) %>%
  scales::rescale()

Berkowitz_IRT_arrhythmic_length_only$difficulty <- as.numeric(difficulty)

Berkowitz_IRT_arrhythmic_length_only <- Berkowitz_IRT_arrhythmic_length_only %>% unique()

use_data(Berkowitz_IRT_arrhythmic_length_only, overwrite = TRUE)


