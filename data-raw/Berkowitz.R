

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




load('Berkowitz_ngram.rda')
load('Berkowitz_combined.rda')
load('Berkowitz_phrase.rda')
load('Berkowitz_item.rda')
load('Berkowitz_file.rda')

use_data(combined_item_bank,
     ngram_item_bank,
     phrase_item_bank,
     item_item_bank,
     file_item_bank,
     compress = "xz", overwrite = TRUE)





#
# # Add first note
#
# remove_tags <- function(string, tag) {
#   stringr::str_remove(string, paste0("<",tag,">")) %>%
#     stringr::str_remove(., paste0("</",tag,">")) %>%
#     gsub(" ", "", .)
# }
#
#
# grab_first_note_of_music_xml <- function(f) {
#   f <- system.file(f, package = "Berkowitz")
#   t <- readLines(f)
#   step <- remove_tags(t[which.min(!grepl("step", t))], "step")
#   octave <- remove_tags(t[which.min(!grepl("octave", t))], "octave")
#   sci_no <- paste0(step, octave)
# }
#
#
# Berkowitz_files_with_first_note <- Berkowitz("files") %>%
#   mutate(first_note = stringr::str_replace(musicxml_file,
#                                            "item_banks",
#                                            "extdata"),
#          first_note = purrr::map(first_note, grab_first_note_of_music_xml),
#          first_note_midi = itembankr::sci_notation_to_midi(first_note))
#
#
# usethis::use_data(Berkowitz_files_with_first_note, overwrite = TRUE)





