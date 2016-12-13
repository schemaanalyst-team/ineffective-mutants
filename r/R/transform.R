## Standardization functions that make sure the same names are consistently across the data tables

#' FUNCTION: transform_standardise_schema
#'
#' DESCRIPTION: Make sure that we always use the word "schema" instead of "casestudy"
#' @export

transform_standardise_schema <- function(d) {
  dt <- d %>% dplyr::rename(schema = casestudy)
}

## Transformation functions that replace an NA (resulting from a join) with the value of zero (nothing of that category
## in the count, and thus the value of zero is precisely the correct one to use)

#' FUNCTION: transform_replace_NA_with_zero_rem_imp
#'
#' DESCRIPTION: Remove all of the NA values and replace them with a 0 value because no IMPAIRED mutants
#' @export

transform_replace_NA_with_zero_rem_imp <- function(d) {
  dt <- d %>% dplyr::mutate(rem_timetaken_imp = replace(rem_timetaken_imp, is.na(rem_timetaken_imp), 0))
  return(dt)
}

#' FUNCTION: transform_replace_NA_with_zero_s
#'
#' DESCRIPTION: Remove all of the NA values and replace them with a 0 value because no STILLBORN mutants
#' @export

transform_replace_NA_with_zero_s <- function(d) {
  dt <- d %>% dplyr::mutate(ma_timetaken_all = replace(ma_timetaken_all, is.na(ma_timetaken_all), 0))
  return(dt)
}

#' FUNCTION: transform_replace_NA_with_zero_i
#'
#' DESCRIPTION: Remove all of the NA values and replace them with a 0 value because no IMPAIRED mutants
#' @export

transform_replace_NA_with_zero_i <- function(d) {
  dt <- d %>% dplyr::mutate(ma_timetaken_i = replace(ma_timetaken_i, is.na(ma_timetaken_i), 0))
  return(dt)
}

#' FUNCTION: transform_replace_NA_with_zero_e
#'
#' DESCRIPTION: Remove all of the NA values and replace them with a 0 value because no EQUIVALENT mutants
#' @export

transform_replace_NA_with_zero_e <- function(d) {
  dt <- d %>% dplyr::mutate(ma_timetaken_e = replace(ma_timetaken_e, is.na(ma_timetaken_e), 0))
  return(dt)
}

#' FUNCTION: transform_replace_NA_with_zero_r
#'
#' DESCRIPTION: Remove all of the NA values and replace them with a 0 value because no REDUNDANT mutants
#' @export

transform_replace_NA_with_zero_r <- function(d) {
  dt <- d %>% dplyr::mutate(ma_timetaken_r = replace(ma_timetaken_r, is.na(ma_timetaken_r), 0))
  return(dt)
}

## Transformation functions that all in the correct summary values to a data frame, in preparation for graphing

#' FUNCTION: transform_add_all_time
#'
#' DESCRIPTION: Add the times running the entire mutation analysis, no subtractions allow, no additions from
#' other analysis either (adding in static analysis time would bias the results).
#' This is the same as all stillborn because stillborn mutants have already been removed
#' @export

transform_add_all_time <- function(d) {
  dt <- d %>% dplyr::mutate(timetype = "-(S)")
  # dt <- d %>% dplyr::mutate(timetype = "All")
  dt <- dt %>% dplyr::mutate(timetaken = ma_timetaken_all)
  return(dt)
}


#' FUNCTION: transform_add_impaired_time
#'
#' DESCRIPTION: The All time is lessened by not running impaired mutants, but we add on the cost of
#' @export

transform_add_impaired_time <- function(d) {
  dt <- d %>% dplyr::mutate(timetype = "-(S+I)")
  dt <- dt %>% dplyr::mutate(timetaken = (ma_timetaken_all - ma_timetaken_i) + (rem_timetaken_imp))
  return(dt)
}

#' FUNCTION: transform_add_equivalent_time
#'
#' DESCRIPTION: The All time is lessened by not running or equivalent mutants, but we add on the cost of
#' running two operators in the mutation analysis pipeline, the primary keys and the equivalent mutant remover
#' @export

transform_add_equivalent_time <- function(d) {
  dt <- d %>% dplyr::mutate(timetype = "-(S+I+E)")
  dt <- dt %>% dplyr::mutate(timetaken = (ma_timetaken_all - ma_timetaken_i - ma_timetaken_e) + (rem_timetaken_imp + rem_timetaken_equ))
  # dt <- dt %>% dplyr::mutate(timetaken = (ma_timetaken_all - ma_timetaken_e))
  return(dt)
}

#' FUNCTION: transform_add_equivalent_redundant_time
#'
#' DESCRIPTION: The All time is lessened by not running equivalent or redundant mutants, but we add on the cost of
#' running two operators in the mutation analysis pipeline, the primary keys and the equivalent mutant remover
#' @export

transform_add_equivalent_redundant_time <- function(d) {
  dt <- d %>% dplyr::mutate(timetype = "-(S+I+E+R)")
  dt <- dt %>% dplyr::mutate(timetaken = (ma_timetaken_all - ma_timetaken_i - ma_timetaken_e -  ma_timetaken_r) + (rem_timetaken_imp + rem_timetaken_equ + rem_timetaken_red))
  # dt <- dt %>% dplyr::mutate(timetaken = (ma_timetaken_all - ma_timetaken_e - ma_timetaken_r))
  return(dt)
}

## Transformation functions that all in the correct summary values to a data frame, in preparation for graphing

#' FUNCTION: transform_all_mutation_score
#'
#' DESCRIPTION: Calculate the mutation score from running the entire mutation analysis, no subtractions allow, no additions from
#' other analysis either (adding in static analysis time would bias the results).
#' This is the same as all stillborn because stillborn mutants have already been removed
#' @export

transform_all_mutation_score <- function(d) {
  dt <- d %>% dplyr::mutate(timetype = "-(S)")
  dt <- dt %>% plyr::rename(c("ma_ms_all" = "mutation_score"))
  return(dt)
}


#' FUNCTION: transform_impaired_mutation_score
#'
#' DESCRIPTION: The All score is made more accurate by not running impaired mutants
#' @export

transform_impaired_mutation_score <- function(d) {
  dt <- d %>% dplyr::mutate(timetype = "-(S+I)")
  dt <- dt %>% plyr::rename(c("ma_ms_imp" = "mutation_score"))
  # dt <- dt %>% dplyr::mutate(mutation_score = ma_ms_imp)
  return(dt)
}

#' FUNCTION: transform_equivalent_mutation_score
#'
#' DESCRIPTION: The All mutation scores are further increased in accuracy by not running impaired or equivalent mutants,
#' @export

transform_equivalent_mutation_score <- function(d) {
  dt <- d %>% dplyr::mutate(timetype = "-(S+I+E)")
  dt <- dt %>% plyr::rename(c("ma_ms_equ" = "mutation_score"))
  # dt <- dt %>% dplyr::mutate(mutation_score = ma_ms_equ)
  return(dt)
}

#' FUNCTION: transform_redundant_mutation_score
#'
#' DESCRIPTION: The All mutation score is further increased by not running impaired, equivalent or redundant mutants
#' @export

transform_redundant_mutation_score <- function(d) {
  dt <- d %>% dplyr::mutate(timetype = "-(S+I+E+R)")
  dt <- dt %>% plyr::rename(c("ma_ms_red" = "mutation_score"))
  # dt <- dt %>% dplyr::mutate(mutation_score = ma_ms_red)
  return(dt)
}

## Transformation functions that move around the attributes so that they are easier to see during debugging

#' FUNCTION: transform_move_timings
#'
#' DESCRIPTION: Move any variable that starts with the word "time" to the front of the data frame
#' @export

transform_move_timings <- function(d) {
  dt <- d %>% dplyr::select(dplyr::starts_with("time"), dplyr::everything())
  return(dt)
}

#' FUNCTION: transform_move_characteristics
#'
#' DESCRIPTION: Move the characteristics of a data row to the font of a data frame
#' @export

transform_move_characteristics <- function(d) {
  dt <- d %>% dplyr::select(identifier, schema, dbms, dplyr::everything())
  return(dt)
}

## TRANSFORMATION FUNCTIONS THAT REMOVE OR MOVE AROUND ATTRIBUTES, NOT USED FREQUENTLY OR AT ALL

#' FUNCTION: transform_remove_operator
#'
#' DESCRIPTION: Remove the operator column, normally before preparing to join data frames together
#' @export

transform_remove_operator <- function(d) {
  return(d %>% dplyr::select(-operator))
}

#' FUNCTION: transform_remove_pipeline
#'
#' DESCRIPTION: Remove the pipeline column, normally before preparing to join data frames together
#' @export

transform_remove_pipeline <- function(d) {
  return(d %>% dplyr::select(-pipeline))
}
