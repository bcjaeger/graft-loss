##' .. content for \description{} (no empty lines) ..
##'
##' .. content for \details{} ..
##'
##' @param data 
##'
##' @title

make_recipe <- function(data, dummy_code = TRUE) {
  
  naming_fun <- function(var, lvl, ordinal = FALSE, sep = '..'){
    dummy_names(var = var, lvl = lvl, ordinal = ordinal, sep = sep)
  }

  rc <- recipe(time + status ~ ., data) %>%  
    update_role(ID, new_role = 'Patient identifier') %>% 
    step_medianimpute(all_numeric(), -all_outcomes()) %>% 
    step_modeimpute(all_nominal(), -all_outcomes()) %>% 
    step_nzv(all_predictors(), freq_cut = 1000, unique_cut = 0.025) %>% 
    #step_other(all_nominal(), -all_outcomes(), other = 'Other') %>% 
    step_novel(all_nominal(), -all_outcomes())
  
  if(dummy_code){
    rc %>%
      step_dummy(
        all_nominal(), -all_outcomes(), 
        naming = naming_fun,
        one_hot = FALSE
      )
  } else {
    rc
  }

}
