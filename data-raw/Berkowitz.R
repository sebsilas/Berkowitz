

library(tidyverse)
library(itembankr)

setwd('/Users/sebsilas/Berkowitz/data-raw/')

# Test with small

create_item_bank(name = "Berkowitz_test",
                   midi_file_dir = "/Users/sebsilas/Berkowitz/data-raw/berkowitz_midi_rhythmic_100bpm_small",
                   musicxml_file_dir = "/Users/sebsilas/Berkowitz/data-raw/berkowitz_musicxml_small",
                   input = "files",
                   output = "all")



load(file = 'Berkowitz_test_combined.rda')
load(file = 'Berkowitz_test_file.rda')
load(file = 'Berkowitz_test_item.rda')
load(file = 'Berkowitz_test_ngram.rda')
load(file = 'Berkowitz_test_phrase.rda')

is(combined_item_bank, "item_bank")

# See which compression method wins
# save(combined_item_bank, file = "Berkowitz_test_gzip.rda", compress = "gzip")
# save(combined_item_bank, file = "Berkowitz_test_bzip2.rda", compress = "bzip2")
# save(combined_item_bank, file = "Berkowitz_test_xz.rda", compress = "xz")

# xz wins (same found with WJD)



# Create real df


create_item_bank(name = "Berkowitz",
                 midi_file_dir = "/Users/sebsilas/Berkowitz/data-raw/berkowitz_midi_rhythmic_100bpm",
                 musicxml_file_dir = "/Users/sebsilas/Berkowitz/data-raw/berkowitz_musicxml",
                 input = "files",
                 output = "all")




load('data-raw/Berkowitz_ngram.rda')
load('data-raw/Berkowitz_combined.rda')
load('data-raw/Berkowitz_phrase.rda')
load('data-raw/Berkowitz_item.rda')
load('data-raw/Berkowitz_file.rda')


# Add difficulties

# Only the ngram_item_bank has log_freq column


ngram_item_bank <- ngram_item_bank %>%
  tibble::as_tibble()



arrhythmic_difficulty <- predict(Berkowitz::lm2.2,
                      newdata = ngram_item_bank,
                      re.form = NA) %>% # this instructs the model to predict without random effects )
                      as.numeric %>%
                      magrittr::multiply_by(-1) %>%
                      scales::rescale()

rhythmic_difficulty <- predict(Berkowitz::lm3.2,
                                 newdata = ngram_item_bank,
                                 re.form = NA) %>% # this instructs the model to predict without random effects )
  as.numeric %>%
  magrittr::multiply_by(-1) %>%
  scales::rescale()


arrhythmic_difficulty_percentile <- ecdf(arrhythmic_difficulty)
rhythmic_difficulty_percentile <- ecdf(rhythmic_difficulty)


get_arrhythmic_difficulty_percentile <- function(v) {
  round(arrhythmic_difficulty_percentile(v) * 100, 2)
}

get_rhythmic_difficulty_percentile <- function(v) {
  round(rhythmic_difficulty_percentile(v) * 100, 2)
}




ngram_item_bank <- ngram_item_bank %>%
  mutate(arrhythmic_difficulty = round(arrhythmic_difficulty, 2),
         rhythmic_difficulty = round(rhythmic_difficulty, 2)) %>%
  rowwise() %>%
  mutate(arrhythmic_difficulty_percentile = get_arrhythmic_difficulty_percentile(arrhythmic_difficulty),
         rhythmic_difficulty_percentile = get_arrhythmic_difficulty_percentile(rhythmic_difficulty)) %>%
  ungroup() %>%
  itembankr::set_item_bank_class(extra = "ngram_item_bank")


# Manually add name

attr(ngram_item_bank, "item_bank_name") <- "Berkowitz"
attr(ngram_item_bank, "item_bank_type") <- "ngram"

attr(phrase_item_bank, "item_bank_name") <- "Berkowitz"
attr(phrase_item_bank, "item_bank_type") <- "phrase"

use_data(combined_item_bank,
     ngram_item_bank,
     phrase_item_bank,
     item_item_bank,
     file_item_bank,
     compress = "xz", overwrite = TRUE)









