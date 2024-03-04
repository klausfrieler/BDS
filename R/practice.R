practice <- function() {
  #message("Added practice pages")
  ret <- psychTestR::one_button_page(body = shiny::div(
    psychTestR::i18n("INSTRUCTIONS"),
    style = "margin-left:15%; margin-right:15%;margin-bottom:20px;text-align:justify"),
    button_text = psychTestR::i18n("CONTINUE"))

  BDS_sample_items <- BDS::BDS_item_bank %>% filter(training == 1)
  for(i in 1:2){
    stimulus <- get_stimulus(BDS_sample_items[i,], i, 2, training = T)
    #browser()
    correct_answer <- BDS_sample_items[i,]$answer
    #messagef("Correct answer '%s' (0x%s)", correct_answer, data.table::address(correct_answer))

    on_complete <-    function(state, answer, ...){
      #browser()
      psychTestR::set_global(key = "last_correct", value = answer$correct[1], state = state)
    }
    label <- paste0("s", i)
    ex <- BDS_page(label = label,
                   stimulus = stimulus,
                   seq_len = nchar(correct_answer),
                   get_answer = get_answer(correct_answer),
                   on_complete = on_complete,
                   save_answer = F)
    ret <- c(ret, ex)
    sample_feedback <- psychTestR::reactive_page(function(state, ...) {
      answer <- ifelse(psychTestR::get_global("last_correct", state), "CORRECT", "INCORRECT")
      psychTestR::one_button_page(
        body = psychTestR::i18n(answer),
        button_text = psychTestR::i18n("CONTINUE")
      )
    }
    )
    ret <-c(ret, sample_feedback)
  }
  ret <- c(ret, psychTestR::one_button_page( body = psychTestR::i18n("CONTINUE_MAIN_TEST"),
                                             button_text = psychTestR::i18n("CONTINUE")
  ))
  ret
}
