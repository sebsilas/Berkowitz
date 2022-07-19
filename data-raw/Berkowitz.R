
library(tidyverse)

#load(file = 'data/Berkowitz_files_db.rda')
#load(file = 'data/Berkowitz_freq_db.rda')
#load(file = 'data/Berkowitz_ngram_db.rda')


Berkowitz <- create_item_bank_from_files(corpus_name = "Berkowitz",
                                         midi_file_dir = "berkowitz_midi_rhythmic_100bpm_small",
                                         musicxml_file_dir = "berkowitz_musicxml_small",
                                         prefix = "inst")



Berkowitz_s2 <- split_item_bank_into_ngrams(Berkowitz)
Berkowitz_s3 <- count_freqs(Berkowitz_s2)
Berkowitz_s4 <- get_melody_features(Berkowitz_s3, mel_sep = ",", durationMeasures = TRUE)

Berkowitz_s5 <- create_phrases_db(corpus_name = "Berkowitz",
                                  midi_file_dir = add_prefix(paste0('item_banks/', "Berkowitz", '/', "berkowitz_midi_rhythmic_100bpm_small"), "inst"),
                                  prefix = "inst",
                                  compute_melody_features = TRUE)




Berkowitz <- corpus_to_item_bank(corpus_name = "Berkowitz",
                               midi_file_dir = "berkowitz_midi_rhythmic_100bpm_small",
                               musicxml_file_dir = "berkowitz_musicxml_small",
                               prefix = "inst")


#Berkowitz("files")


remove_tags <- function(string, tag) {
  stringr::str_remove(string, paste0("<",tag,">")) %>%
    stringr::str_remove(., paste0("</",tag,">")) %>%
    gsub(" ", "", .)
}


grab_first_note_of_music_xml <- function(f) {
  f <- system.file(f, package = "Berkowitz")
  t <- readLines(f)
  step <- remove_tags(t[which.min(!grepl("step", t))], "step")
  octave <- remove_tags(t[which.min(!grepl("octave", t))], "octave")
  sci_no <- paste0(step, octave)
}

Berkowitz_files_with_first_note <- Berkowitz("files") %>%
  mutate(first_note = stringr::str_replace(musicxml_file,
                                           "item_banks",
                                           "extdata"),
  first_note = purrr::map(first_note, grab_first_note_of_music_xml),
  first_note_midi = itembankr::sci_notation_to_midi(first_note))


usethis::use_data(Berkowitz_files_with_first_note, overwrite = TRUE)
