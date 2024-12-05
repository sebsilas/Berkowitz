

#' Predict arrhythmic difficulty scores
#'
#' @param data
#'
#' @return
#' @export
#'
#' @examples
predict_arrhythmic_difficulty <- function(data) {

  stopifnot(
    length(setdiff(names(df), c('N', 'step.cont.loc.var', 'tonalness', 'log_freq'))) == 0
  )
  predict(musicassessr::lm2.2,
          newdata = data,
          re.form = NA) %>%
    as.numeric() %>%
    magrittr::multiply_by(-1)
}

#' Predict rhythmic difficulty scores
#'
#' @param data
#'
#' @return
#' @export
#'
#' @examples
predict_rhythmic_difficulty <- function(data) {

  stopifnot(
    length(setdiff(names(df), c('N', 'step.cont.loc.var', 'log_freq', 'd.entropy', 'i.entropy '))) == 0
  )
  predict(musicassessr::lm3.2,
          newdata = data,
          re.form = NA) %>%
    as.numeric() %>%
    magrittr::multiply_by(-1)
}

