
library(tidyverse)
library(itembankr)

# Test with small

Berkowitz <- corpus_to_item_bank(name = "Berkowitz",
                               midi_file_dir = "/Users/sebsilas/Berkowitz/data-raw/berkowitz_midi_rhythmic_100bpm_small",
                               musicxml_file_dir = "/Users/sebsilas/Berkowitz/data-raw/berkowitz_musicxml_small",
                               input = "files",
                               output = "all")


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


# add i.entropy

getwd()
load('data/Berkowitz.rda')
phr.length.limits <- c(2,140)

files_db <- Berkowitz("files")

ngram_db <- Berkowitz("ngram") %>%
  rowwise() %>%
  mutate(i.entropy = compute.entropy(itembankr::rel_to_abs_mel(str_mel_to_vector(melody)), phr.length.limits[2]-1)) %>%
  ungroup()

hist(ngram_db$i.entropy)

main_db <- Berkowitz("main")  %>%
  rowwise() %>%
  mutate(i.entropy = compute.entropy(itembankr::rel_to_abs_mel(str_mel_to_vector(melody)), phr.length.limits[2]-1)) %>%
  ungroup()

hist(main_db$i.entropy)

phrases_db <- Berkowitz("phrases")  %>%
  rowwise() %>%
  mutate(i.entropy = compute.entropy(itembankr::rel_to_abs_mel(str_mel_to_vector(melody)), phr.length.limits[2]-1)) %>%
  ungroup()

hist(phrases_db$i.entropy)

Berkowitz <- function(key) {
  l <- list("files" = files_db,
            "ngram" = ngram_db,
            "main" = main_db,
            "phrases" = phrases_db)
  l[[key]]
}

use_data(Berkowitz, files_db, ngram_db, main_db, phrases_db, overwrite = TRUE)

