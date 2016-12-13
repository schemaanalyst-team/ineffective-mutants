## Summarisation functions for the mutation analysis pipeline data set

#' FUNCTION:  summarise_mutation_analysis_pipeline
#'
#' DESCRIPTION: Summarise the data associated with the mutation analysis pipeline and the removers
#' @export

summarise_mutation_analysis_pipeline <- function(d) {
  s <- d %>% dplyr::group_by(schema, dbms, pipeline) %>% dplyr::filter(type %in% c("removed")) %>% dplyr::summarise(removal_mean_time=mean(timetaken))
  return(s)
}

#' FUNCTION: summarise_mutation_analysis_static_operator
#'
#' DESCRIPTION: Summarise the time required for running the static analysis during mutation analysis
#' @export

summarise_mutation_analysis_static_operator <- function(d) {
  s <- d %>% dplyr::group_by(schema, dbms, pipeline, operator) %>% dplyr::summarise(rem_timetaken_sta=mean(timetaken))
  return(s)
}

#' FUNCTION: summarise_mutation_analysis_stillborn_operator
#'
#' DESCRIPTION: Summarise the time required for analysing stillborn mutants during mutation analysis
#' This should not work! Stillborn mutants are not run during mutation analysis!
#' @export

summarise_mutation_analysis_stillborn_operator <- function(d) {
  s <- d %>% dplyr::group_by(schema, dbms, pipeline, operator) %>% dplyr::summarise(rem_timetaken_sti=mean(timetaken))
  return(s)
}

#' FUNCTION: summarise_mutation_analysis_impaired_operator
#'
#' DESCRIPTION: Summarise the time required for analysing impaired mutants during mutation analysis
#' @export

summarise_mutation_analysis_impaired_operator <- function(d) {
  s <- d %>% dplyr::group_by(schema, dbms, pipeline, operator) %>% dplyr::summarise(rem_timetaken_imp=mean(timetaken))
  return(s)
}

#' FUNCTION: summarise_mutation_analysis_equivalent_operator
#'
#' DESCRIPTION: Summarise the time required for analysing equivalent mutants during mutation analysis
#' @export

summarise_mutation_analysis_equivalent_operator <- function(d) {
  s <- d %>% dplyr::group_by(schema, dbms, pipeline, operator) %>% dplyr::summarise(rem_timetaken_equ=mean(timetaken))
  return(s)
}

#' FUNCTION: summarise_mutation_analysis_redundant_operator
#'
#' DESCRIPTION: Summarise the time required for analysing redundant mutants during mutation analysis
#' @export

summarise_mutation_analysis_redundant_operator <- function(d) {
  s <- d %>% dplyr::group_by(schema, dbms, pipeline, operator) %>% dplyr::summarise(rem_timetaken_red=mean(timetaken))
  return(s)
}

#' FUNCTION: summarise_mean_mutation_time
#'
#' DESCRIPTION: Summarise the data for running the stillborn, equivalent and redundant mutants for each schema
#' @export

summarise_mean_mutation_time <- function(d) {
  dna <- d %>% transform_replace_NA_with_zero_s() %>% transform_replace_NA_with_zero_e() %>% transform_replace_NA_with_zero_r()
  ds <- dna %>% dplyr::group_by(schema, dbms) %>% dplyr::summarise(mean_ma_timetaken = mean(ma_timetaken_all))
  return(ds)
}

#' FUNCTION: summarise_mean_impaired_time
#'
#' DESCRIPTION: Summarise the data for running the stillborn, impaired mutants for each schema
#' @export

summarise_mean_impaired_time <- function(d) {
  dna <- d %>% transform_replace_NA_with_zero_s() %>% transform_replace_NA_with_zero_e() %>% transform_replace_NA_with_zero_i()
  ds <- dna %>% dplyr::group_by(schema, dbms) %>% dplyr::summarise(mean_ma_timetaken = (mean(ma_timetaken_all) - mean(ma_timetaken_i) + mean(rem_timetaken_imp)))
  return(ds)
}

#' FUNCTION: summarise_mean_equivalent_time
#'
#' DESCRIPTION: Summarise the data for running the stillborn, equivalent mutants for each schema
#' @export

summarise_mean_equivalent_time <- function(d) {
  dna <- d %>% transform_replace_NA_with_zero_s() %>% transform_replace_NA_with_zero_i() %>% transform_replace_NA_with_zero_e()
  ds <- dna %>% dplyr::group_by(schema, dbms) %>% dplyr::summarise(mean_ma_timetaken = (mean(ma_timetaken_all) - mean(ma_timetaken_i) - mean(ma_timetaken_e) + mean(rem_timetaken_imp) + mean(rem_timetaken_equ)))
  return(ds)
}

#' FUNCTION: summarise_mean_redundant_time
#'
#' DESCRIPTION: Summarise the data for running the stillborn, equivalent and redundant mutants for each schema
#' @export

summarise_mean_redundant_time <- function(d) {
  dna <- d %>% transform_replace_NA_with_zero_s() %>% transform_replace_NA_with_zero_i() %>% transform_replace_NA_with_zero_e() %>% transform_replace_NA_with_zero_r()
  ds <- dna %>% dplyr::group_by(schema, dbms) %>% dplyr::summarise(mean_ma_timetaken = (mean(ma_timetaken_all) - mean(ma_timetaken_i) - mean(ma_timetaken_e) - mean(ma_timetaken_r) + mean(rem_timetaken_imp) + mean(rem_timetaken_equ) + mean(rem_timetaken_red)))
  return(ds)
}


## Summarisation functions used for the data sets that are about mutation analysis time for a specific data generator

#' FUNCTION: summarise_total_mutation_time
#'
#' DESCRIPTION: Summarise the data associated with the mutation time, associated with running every type of mutant
#' @export

summarise_total_mutation_time <- function(d) {
  ds <- d %>% dplyr::group_by(schema, dbms, identifier) %>% dplyr::summarise(ma_timetaken_all = sum(time))
  return(ds)
}

#' FUNCTION: summarise_total_impaired_time
#'
#' DESCRIPTION: Summarise the data associated with running the impaired mutants alone
#' @export

summarise_total_impaired_time <- function(d) {
  ds <- d %>% dplyr::group_by(schema, dbms, identifier) %>% dplyr::summarise(ma_timetaken_i = sum(time))
  return(ds)
}

#' FUNCTION: summarise_total_equivalent_time
#'
#' DESCRIPTION: Summarise the data associated with running the equivalent mutants alone
#' @export

summarise_total_equivalent_time <- function(d) {
  ds <- d %>% dplyr::group_by(schema, dbms, identifier) %>% dplyr::summarise(ma_timetaken_e = sum(time))
  return(ds)
}

#' FUNCTION: summarise_total_redundant_time
#'
#' DESCRIPTION: Summarise the data associated with running the redundant mutants alone
#' @export

summarise_total_redundant_time <- function(d) {
  ds <- d %>% dplyr::group_by(schema, dbms, identifier) %>% dplyr::summarise(ma_timetaken_r = sum(time))
  return(ds)
}

## Summarisation functions used for the data sets that are about mutation score for a specific data generator

#' FUNCTION: summarise_total_mutation_score
#'
#' DESCRIPTION: Summarise the data associated with the mutation score, associated with running every type of mutant
#' @export

summarise_total_mutation_score <- function(d) {
  k <- d %>% collect_mutants_killed_count()
  tot <- d %>% collect_mutants_total_count()
  join_killed_total <- join_mutation_score_killed_total_count(k, tot) %>% plyr::rename(c("n.x"="killed", "n.y"="total"))
  ms <- join_killed_total %>% dplyr::group_by(schema, dbms) %>% dplyr::summarise(ma_ms_all = (killed / total) * 100)
  return(ms)
}

#' FUNCTION: summarise_impaired_mutation_score
#'
#' DESCRIPTION: Summarise the data associated with the mutation score, associated with running every type of mutant with impaired mutant removed
#' @export

summarise_impaired_mutation_score <- function(d) {
  k <- d %>% collect_mutants_killed_count()
  tot <- d %>% collect_mutants_total_count()
  join_killed_total <- join_mutation_score_killed_total_count(k, tot) %>% plyr::rename(c("n.x"="killed", "n.y"="total"))
  ms <- join_killed_total %>% dplyr::group_by(schema, dbms) %>% dplyr::summarise(ma_ms_imp = (killed / total) * 100)
  return(ms)
}

#' FUNCTION: summarise_equivalent_mutation_score
#'
#' DESCRIPTION: Summarise the data associated with the mutation score, associated with running every type of mutant with impaired and equivalent mutant removed
#' @export

summarise_equivalent_mutation_score <- function(d) {
  k <- d %>% collect_mutants_killed_count()
  tot <- d %>% collect_mutants_total_count()
  join_killed_total <- join_mutation_score_killed_total_count(k, tot) %>% plyr::rename(c("n.x"="killed", "n.y"="total"))
  ms <- join_killed_total %>% dplyr::group_by(schema, dbms) %>% dplyr::summarise(ma_ms_equ = (killed / total) * 100)
  return(ms)
}

#' FUNCTION: summarise_redundant_mutation_score
#'
#' DESCRIPTION: Summarise the data associated with the mutation score, associated with running every type of mutant with impaired, equivalent and redundant mutant removed
#' @export

summarise_redundant_mutation_score <- function(d) {
  k <- d %>% collect_mutants_killed_count()
  tot <- d %>% collect_mutants_total_count()
  join_killed_total <- join_mutation_score_killed_total_count(k, tot) %>% plyr::rename(c("n.x"="killed", "n.y"="total"))
  ms <- join_killed_total %>% dplyr::group_by(schema, dbms) %>% dplyr::summarise(ma_ms_red = (killed / total) * 100)
  return(ms)
}

#' FUNCTION: summarise_total_impaired_time
#'
#' DESCRIPTION: Summarise the data associated with running the impaired mutants alone
#' @export

summarise_total_impaired_time <- function(d) {
  ds <- d %>% dplyr::group_by(schema, dbms, identifier) %>% dplyr::summarise(ma_timetaken_i = sum(time))
  return(ds)
}

#' FUNCTION: summarise_total_equivalent_time
#'
#' DESCRIPTION: Summarise the data associated with running the equivalent mutants alone
#' @export

summarise_total_equivalent_time <- function(d) {
  ds <- d %>% dplyr::group_by(schema, dbms, identifier) %>% dplyr::summarise(ma_timetaken_e = sum(time))
  return(ds)
}

#' FUNCTION: summarise_total_redundant_time
#'
#' DESCRIPTION: Summarise the data associated with running the redundant mutants alone
#' @export

summarise_total_redundant_time <- function(d) {
  ds <- d %>% dplyr::group_by(schema, dbms, identifier) %>% dplyr::summarise(ma_timetaken_r = sum(time))
  return(ds)
}

#' FUNCTION: summarise_mutation_analysis_stillborn_equivalent_redundant_time
#'
#' DESCRIPTION: Summarise the data for running the stillborn, equivalent and redundant mutants for each schema
#' @export

summarise_mutation_analysis_stillborn_equivalent_redundant_time <- function(d) {
  dna <- d %>% transform_replace_NA_with_zero_s() %>% transform_replace_NA_with_zero_i() %>% transform_replace_NA_with_zero_e() %>% transform_replace_NA_with_zero_r()
  ds <- dna %>% dplyr::group_by(schema, dbms) %>% dplyr::summarise(mean_ma_timetaken_s = mean(ma_timetaken_all), mean_ma_timetaken_i = (mean_ma_timetaken_s - mean(ma_timetaken_i) + mean(rem_timetaken_imp)), mean_ma_timetaken_e = (mean_ma_timetaken_i - mean(ma_timetaken_e) + mean(rem_timetaken_equ)), mean_ma_timetaken_r = (mean_ma_timetaken_e - mean(ma_timetaken_r) + mean(rem_timetaken_red)))
  return(ds)
}
