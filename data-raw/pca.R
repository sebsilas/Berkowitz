
library(tidyverse)
library(psych)
library(EFAtools)
library(corrplot)


cor.mtest <- function(mat, ...) {
  mat <- as.matrix(mat)
  n <- ncol(mat)
  p.mat<- matrix(NA, n, n)
  diag(p.mat) <- 0
  for (i in 1:(n - 1)) {
    for (j in (i + 1):n) {
      tmp <- cor.test(mat[, i], mat[, j], ...)
      p.mat[i, j] <- p.mat[j, i] <- tmp$p.value
    }
  }
  colnames(p.mat) <- rownames(p.mat) <- colnames(mat)
  p.mat
}

Berkowitz_pca <- Berkowitz("main") %>%
  select(-c(start, midi_file, musicxml_file)) %>%
  unique() %>%
  rowwise() %>%
  mutate(unique_melody_name = paste0(melody, '|', durations)) %>%
  ungroup()

# old version of itembankr didn't have i.entropy:

Berkowitz_pca$i.entropy <- itembankr::get_interval_entropy(Berkowitz_pca$melody)

Berkowitz_pca %>% dplyr::select_if(is.numeric) %>% itembankr::hist_item_bank()

pca_vars <- Berkowitz_pca %>% select(tonalness, step.cont.loc.var, d.entropy, i.entropy,
                                     d.eq.trans)


p.mat <- cor.mtest(pca_vars)
M <- cor(pca_vars, use = "pairwise.complete.obs")
colnames(M) <- paste0("c", 1:ncol(M))
rownames(M) <- paste0('c', 1:nrow(M))

corrplot::corrplot(M, method = "number", p.mat = p.mat, sig.level = 0.05, type = "lower")

pca_vars %>% EFAtools::KMO()


pca_vars %>% fa.parallel()

pca1 <- pca_vars %>% principal(nfactors = 2)
print(pca1, cut = 0.3, sort = TRUE)


pca2 <- pca_vars %>% select(-tonalness) %>%  principal(nfactors = 2)
print(pca2, cut = 0.3, sort = TRUE)

# not great..
