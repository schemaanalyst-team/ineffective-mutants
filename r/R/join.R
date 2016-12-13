## Join operations used when dealing with the mutation analysis pipeline data

#' FUNCTION: join_stillborn_equivalent_redundant
#'
#' DESCRIPTION: Join together three data tables when matching on the schema and the dbms
#' @export

join_stillborn_equivalent_redundant <- function(k, e, r) {
  k <- k %>% transform_remove_operator() %>% dplyr::ungroup() %>% transform_remove_pipeline()
  e <- e %>% transform_remove_operator() %>% dplyr::ungroup() %>% transform_remove_pipeline()
  r <- r %>% transform_remove_operator() %>% dplyr::ungroup() %>% transform_remove_pipeline()
  ke <- dplyr::left_join(k, e, by = c("schema" = "schema", "dbms" = "dbms"))
  ker <- dplyr::left_join(ke, r, by = c("schema" = "schema", "dbms" = "dbms"))
  return(ker)
}

#' FUNCTION: join_stillborn_impaired_equivalent_redundant
#'
#' DESCRIPTION: Join together four data tables when matching on the schema and the dbms
#' @export

join_stillborn_impaired_equivalent_redundant <- function(k, i, e, r) {
  k <- k %>% transform_remove_operator() %>% dplyr::ungroup() %>% transform_remove_pipeline()
  i <- i %>% transform_remove_operator() %>% dplyr::ungroup() %>% transform_remove_pipeline()
  e <- e %>% transform_remove_operator() %>% dplyr::ungroup() %>% transform_remove_pipeline()
  r <- r %>% transform_remove_operator() %>% dplyr::ungroup() %>% transform_remove_pipeline()
  ki <- dplyr::left_join(k, i, by = c("schema" = "schema", "dbms" = "dbms"))
  kie <- dplyr::left_join(ki, e, by = c("schema" = "schema", "dbms" = "dbms"))
  kier <- dplyr::left_join(kie, r, by = c("schema" = "schema", "dbms" = "dbms"))
  return(kier)
}

## Join operations used when dealing with the data sets describing what happened during mutation analysis

#' FUNCTION: join_mutation_analysis
#'
#' DESCRIPTION: Join together two data tables
#' @export

join_mutation_analysis <- function(a, b) {
  ajb <- dplyr::left_join(a, b, by = c("schema" = "schema", "dbms" = "dbms", "identifier" = "identifier"))
  return(ajb)
}

#' FUNCTION: join_mutation_analysis_stillborn_equivalent_redundant
#'
#' DESCRIPTION: Join together three mutation analysis data tables
#' @export

join_mutation_analysis_stillborn_equivalent_redundant <- function(s, e, r) {
  se <- dplyr::left_join(s, e, by = c("schema" = "schema", "dbms" = "dbms", "identifier" = "identifier"))
  ser <- dplyr::left_join(se, r, by = c("schema" = "schema", "dbms" = "dbms", "identifier" = "identifier"))
  return(ser)
}

#' FUNCTION: join_mutation_analysis_stillborn_impaired_equivalent_redundant
#'
#' DESCRIPTION: Join together four mutation analysis data tables
#' @export

join_mutation_analysis_stillborn_impaired_equivalent_redundant <- function(s, i, e, r) {
  si <- dplyr::left_join(s, i, by = c("schema" = "schema", "dbms" = "dbms", "identifier" = "identifier"))
  sie <- dplyr::left_join(si, e, by = c("schema" = "schema", "dbms" = "dbms", "identifier" = "identifier"))
  sier <- dplyr::left_join(sie, r, by = c("schema" = "schema", "dbms" = "dbms", "identifier" = "identifier"))
  return(sier)
}

## Join operations when dealing with data sets from multiple sources, such as the pipeline data file and then the mutation analysis file

#' FUNCTION: join_remover_and_mutation_analysis
#'
#' DESCRIPTION: Join together two data tables when matching on the schema and the dbms
#' @export

join_remover_and_mutation_analysis <- function(r, m) {
  return(dplyr::left_join(m, r, by = c("schema" = "schema", "dbms" = "dbms")))
}

#' FUNCTION: join_mutation_analysis_summary
#'
#' DESCRIPTION: Join together three data tables when matching on the schema and the dbms
#' @export

join_mutation_analysis_summary <- function(s, e, r) {
  se <- dplyr::left_join(s, e, by = c("schema" = "schema", "dbms" = "dbms"))
  ser <- dplyr::left_join(se, r, by = c("schema" = "schema", "dbms" = "dbms"))
  return(ser)
}

#' FUNCTION: join_mutation_score_killed_total_count
#'
#' DESCRIPTION: Join together two mutation analysis data tables
#' @export

join_mutation_score_killed_total_count <- function(k, tot) {
  kt <- dplyr::left_join(k, tot, by = c("schema" = "schema", "dbms" = "dbms"))
  return(kt)
}

#' FUNCTION: join_mutation_score
#'
#' DESCRIPTION: Join together four mutation analysis data tables
#' @export

join_mutation_score <- function(s, i, e, r) {
  si <- dplyr::left_join(s, i, by = c("schema" = "schema", "dbms" = "dbms"))
  sie <- dplyr::left_join(si, e, by = c("schema" = "schema", "dbms" = "dbms"))
  sier <- dplyr::left_join(sie, r, by = c("schema" = "schema", "dbms" = "dbms"))
  return(sier)
}
