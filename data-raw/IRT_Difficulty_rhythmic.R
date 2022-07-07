
library(tidyverse)
library(magrittr)

Berkowitz_IRT_rhythmic <- Berkowitz("main") %>%
  mutate(i.entropy = itembankr::get_interval_entropy(melody))


Berkowitz_IRT_rhythmic <- Berkowitz_IRT_rhythmic %>%
  select(melody, N, step.cont.loc.var, log_freq, d.entropy, i.entropy)


Berkowitz_IRT_rhythmic$difficulty <- predict(Berkowitz::lm3.2,
  newdata = Berkowitz_IRT_rhythmic,
re.form = NA) %>% # this instructs the model to predict without random effects )
as.numeric %>% scale()


hist(Berkowitz_IRT_rhythmic$difficulty)

Berkowitz_IRT_rhythmic <- Berkowitz_IRT_rhythmic %>%
  select(melody, difficulty) %>%
  unique() %>%
  rename(answer = melody) %>%
  mutate(discrimination = 1, guessing = 1, inattention = 1)



use_data(Berkowitz_IRT_rhythmic, overwrite = TRUE)



