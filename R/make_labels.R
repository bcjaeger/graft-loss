##' .. content for \description{} (no empty lines) ..
##'
##' .. content for \details{} ..
##'
##' @title

make_labels <- function(
  colname_variable, 
  colname_label, 
  case = 'snake', 
  set_to_na = ''
) {

  # stored in private directory to prevent data leak
  variables <- read_sas('data/phts_txpl_ml.sas7bdat') %>% 
    map_chr(attr, 'label') %>% 
    enframe(name = colname_variable, value = colname_label) %>% 
    mutate(variable = clean_chr(variable)) %>% 
    add_row(variable = 'tx_mcsd',
            label = 'F1T MSCD at Transplant') %>% 
    filter(variable != 'txnomcsd',
           variable != 'lbun_r') %>% 
    mutate(label = str_remove(label, '^F\\d.|^F0'),
           label = trimws(label))
  
  categories <- c(
    'congenital_hd' = 'Congenital heart disease',
    'cardiomyopathy' = 'Cardiomyopathy',
    'no' = 'No',
    'yes' = 'Yes',
    'other' = 'Other'
  ) %>% 
    enframe(name = 'category', value = colname_label)

  list(variables = variables,
       categories = categories)
  
}
