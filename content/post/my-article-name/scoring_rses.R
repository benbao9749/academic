#' @title {Scoring the Rosenberg Self-Esteem Scale (RSES)}
#' @description {
#' The RSES is a 10-item psychometric scale that is designed to measure self-esteem.
#' It uses a scale of 0-30 where a score less than 15 may indicate a problematic low self esteem.
#' The RSES includes 10 items rated from 0 to 3 that are then added together.
#' If more than 2 items have not been answered, then the total score is not calculated.
#' }
#' @details
#' \itemize{
#' \item \code{Number of items:} {10}
#' \item \code{Item range:} {0 to 3}
#' \item \code{Reverse items:} {2, 5, 6, 8, 9}
#' \item \code{Score range:} {0 to 30}
#' \item \code{Cut-off-values:} {A score of less than 15 suggests low self-esteem may be an issue.}
#' \item \code{Minimal clinically important difference:} {none}
#' \item \code{Treatment of missing values:}
#' {If more than 2 items have not been answered, then the total score is not calculated.}
#' }
#' @references
#' Link to Questionnaire (\url{http://callhelpline.org.uk/Download/Rosenberg\%20Self-Esteem\%20Scale.pdf})
#'
#' Rosenberg M (1965). Society and the adolescent self-image. Princeton, New Jersey: Princeton University Press.
#'
#' von Collani, Herzberg (2003)  (\url{https://doi.org/10.1024//0170-1789.24.1.3})
#' @return The function returns 2 variables:
#' \itemize{
#'  \item \code{nvalid.rses:} Number of valid values (MAX=10)
#'  \item \code{score.rses:} RSES Score
#' }
#' @examples
#' \dontrun{
#' library(dplyr)
#' items.rses <- paste0("RSES_", seq(1, 10, 1))
#' scoring_rses(mydata, items = items.rses)
#' }
#' @param data a \code{\link{data.frame}} containing the RSES items
#' orderd from 1 to 10
#' @param items A character vector with the RSES item names ordered from 1 to 10,
#' or a numeric vector indicating the column numbers of the RSES items in \code{data}.
#' @param keep Logical, whether to keep the single items and  whether to return variables containing
#' the number of non-missing items on each scale for each respondent. The default is TRUE.
#' @param nvalid A numeric value indicating the number of non-missing items required for score
#' calculations. The default is 8.
#' @param digits Integer of length one: value to round to. No rounding by default.
#' @param reverse items to be scored reversely. These items can be specified either by name or by index.
#' Default: 2, 5, 6, 8, 9
#' @export
scoring_rses <- function(data, items = 1:10, keep = TRUE, nvalid = 8,
                         digits = NULL, reverse = c(2, 5, 6, 8, 9)) {
  library(dplyr, warn.conflicts = FALSE)
  if (min(data[, items], na.rm = T) < 0) {
    stop("Minimum possible value for RSES items is 0")
  } else if (max(data[, items], na.rm = T) > 3) {
    stop("Maximum possible value for RSES items is 3")
  }
  # check for number of specified items
  if (length(items) != 10) {
    stop("Number of items must be 10!")
  }
  items <- items
  items.rev <- items[reverse]
  data <- data %>%
    mutate_at(vars(items.rev), list(~ 3 - .)) %>%
    mutate(
      nvalid.rses = rowSums(!is.na(select(., items))),
      mean.temp = round(rowSums(select(., items), na.rm = TRUE) / nvalid.rses)
    ) %>%
    mutate_at(
      vars(items),
      list(~ ifelse(is.na(.), mean.temp, .))
    ) %>%
    mutate(
      score.temp = rowSums(select(., items), na.rm = TRUE),
      score.rses = ifelse(nvalid.rses >= nvalid, score.temp, NA)
    ) %>%
    select(-mean.temp, -score.temp)
  data
  # Keep single items and nvalid variables
  if (keep == FALSE) {
    data <- data %>% select(-items, -nvalid.rses)
  } else {
    data <- data
  }
  # Rounding
  if (is.numeric(digits) == TRUE) {
    data <- data %>% mutate_at(vars(score.rses), list(~ round(., digits)))
  } else {
    data <- data
  }
  data
}
NULL