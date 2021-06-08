library(tidyverse)
library(psychTestR)
source("R/options.R")
source("R/main_test.R")
source("R/item_page.R")
source("R/feedback.R")
source("R/utils.R")


#' BDS
#'
#' This function defines a BDS  module for incorporation into a
#' psychTestR timeline.
#' Use this function if you want to include the BDS in a
#' battery of other tests, or if you want to add custom psychTestR
#' pages to your test timeline.
#' For demoing the BDS, consider using \code{\link{BDS_demo}()}.
#' For a standalone implementation of the BDS,
#' consider using \code{\link{BDS_standalone}()}.
#' @param num_items (Integer scalar) Number of items in the test.
#' @param with_training (Logical scalar) Whether to include the training phase.
#' @param with_welcome (Logical scalar) Whether to show a welcome page.
#' @param with_finish (Logical scalar) Whether to show a finished page.
#' @param label (Character scalar) Label to give the BDS results in the output file.
#' @param feedback (Function) Defines the feedback to give the participant
#' at the end of the test.
#' @param dict The psychTestR dictionary used for internationalisation.
#' @export
BDS <- function(num_items = 18L,
                with_welcome = TRUE,
                with_training = TRUE,
                with_finish = TRUE,
                label = "BDS",
                feedback = NULL,
                dict = BDS::BDS_dict) {
  stopifnot(purrr::is_scalar_character(label),
            purrr::is_scalar_integer(num_items) || purrr::is_scalar_double(num_items),
            psychTestR::is.timeline(feedback) ||
              is.list(feedback) ||
              psychTestR::is.test_element(feedback) ||
              is.null(feedback))

  psychTestR::join(
    psychTestR::begin_module(label),
    if (with_welcome) BDS_welcome_page(),
    if (with_training) psychTestR::new_timeline(practice(), dict = dict),
    psychTestR::new_timeline(
      main_test(label = label, num_items_in_test = num_items),
      dict = dict),
    scoring(),
    psychTestR::elt_save_results_to_disk(complete = TRUE),
    feedback,
    if(with_finish) BDS_finished_page(),
    psychTestR::end_module())
}
