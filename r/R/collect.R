#' FUNCTION: collect_dynamic_transacted
#'
#' DESCRIPTION: Collect only the data values that are for the "dynamic" or "transacted" removers
#' @export

collect_dynamic_transacted <- function(data) {
  dynamic_transacted_data <- data %>%
    dplyr::filter(pipeline %in% c("AllOperatorsNoFKANormalisedWithRemoversDBMSRemovers",
                                  "AllOperatorsNoFKANormalisedWithRemoversTransactedDBMSRem"))
  return(dynamic_transacted_data)
}

#' FUNCTION: collect_static
#'
#' DESCRIPTION: Collect only the data values that are for the "static" remover
#' @export

collect_static <- function(data) {
  static_data <- data %>%
    dplyr::filter(pipeline %in% c("AllOperatorsNoFKANormalisedWithClassifiers"))
  return(static_data)
}

#' FUNCTION: collect_removers_dynamic_transacted
#'
#' DESCRIPTION: Collect only the data values that are for "remover" aspects of the mutation pipeline
#' @export

collect_removers_dynamic_transacted <- function(data) {
  removers_data <- data %>%
    dplyr::filter(type == "removed") %>%
    dplyr::filter(pipeline %in% c("AllOperatorsNoFKANormalisedWithRemoversDBMSRemovers",
                                  "AllOperatorsNoFKANormalisedWithRemoversTransactedDBMSRem")) %>%
    dplyr::filter(operator %in% c("DBMSRemover", "DBMSTransactedRemover"))
  return(removers_data)
}

#' FUNCTION: collect_hypersql
#'
#' DESCRIPTION: Collect on the data values related to the HyperSQL database
#' @export

collect_hypersql <- function(d) {
 ds <- d %>% dplyr::filter(dbms == "HyperSQL")
 return(ds)
}

#' FUNCTION: collect_postgres
#'
#' DESCRIPTION: Collect on the data values related to the PostgreSQL database
#' @export

collect_postgres <- function(d) {
 ds <- d %>% dplyr::filter(dbms == "Postgres")
 return(ds)
}

#' FUNCTION: collect_sqlite
#'
#' DESCRIPTION: Collect on the data values related to the SQLite database
#' @export

collect_sqlite <- function(d) {
 ds <- d %>% dplyr::filter(dbms == "SQLite")
 return(ds)
}

#' FUNCTION: collect_hypersql_postgres
#'
#' DESCRIPTION: Collect the data values that are related to two DBMSs, both Postgres and HyperSQL
#' @export

collect_hypersql_postgres <- function(d) {
  dh <- d %>% collect_hypersql()
  dp <- d %>% collect_postgres()
  return(dplyr::bind_rows(dh, dp))
}


#' FUNCTION:  collect_removers_static_hypersql
#'
#' DESCRIPTION: Collect only the data values that are for static analysis with the HyperSQL DBMS
#' @export

collect_removers_static_hypersql <- function(d) {
  dsh <- d %>% collect_static() %>% collect_hypersql() %>%
    dplyr::filter(type == "removed") %>% dplyr::filter(operator %in% c("HyperSQLRemover"))
  return(dsh)
}

#' FUNCTION:  collect_removers_static_postgres
#'
#' DESCRIPTION: Collect only the data values that are for static analysis with the PostgreSQL DBMS
#' @export

collect_removers_static_postgres <- function(d) {
  dsh <- d %>% collect_static() %>% collect_postgres() %>%
    dplyr::filter(type == "removed") %>% dplyr::filter(operator %in% c("PostgresRemover"))
  return(dsh)
}

#' FUNCTION: collect_removers_static
#'
#' DESCRIPTION: Collect only the data values that are for "remover" aspects of the mutation pipeline; could be refactored!
#' @export

collect_removers_static <- function(data) {
  # collect the data specifically for the static removal with HyperSQL
  removers_data_hsqldb <- data %>% collect_removers_static_hypersql()

  # collect the data specifically for the static removal with Postgres
  removers_data_postgres <- data %>%
    dplyr::filter(dbms == "Postgres") %>%
    dplyr::filter(type == "removed") %>%
    dplyr::filter(operator %in% c("PostgresRemover"))

  # collect the data specifically for the static removal with SQLite
  removers_data_sqlite <- data %>%
    dplyr::filter(dbms == "SQLite") %>%
    dplyr::filter(type == "removed") %>%
    dplyr::filter(operator %in% c("SQLiteClassifier"))

  # create the final data set by binding the rows from the three created before this one
  removers_data <- dplyr::bind_rows(removers_data_hsqldb, removers_data_postgres, removers_data_sqlite)
  return(removers_data)
}

collect_removers_static_sqlite <- function(data) {
  # collect the data specifically for the static removal with SQLite
  removers_data_sqlite <- data %>% collect_static() %>%
    dplyr::filter(dbms == "SQLite") %>%
    dplyr::filter(type == "removed") %>%
    dplyr::filter(operator %in% c("SQLiteClassifier"))
  return(removers_data_sqlite)
}

#' FUNCTION: collect_fast_databases
#'
#' DESCRIPTION: Collect only the two fast databases (i.e., HyperSQL and SQLite)
#' @export

collect_fast_databases <- function(data) {
  fast_data <- data %>%
    dplyr::filter(dbms %in% c("HyperSQL", "SQLite"))
  return(fast_data)
}

#' FUNCTION:  collect_slow_databases
#'
#' DESCRIPTION: Collect the slow database (i.e., Postgres)
#' @export

collect_slow_databases <- function(data) {
  slow_data <- data %>%
    dplyr::filter(dbms %in% c("Postgres"))
  return(slow_data)
}

#' FUNCTION:  collect_strict_databases
#'
#' DESCRIPTION: Collect the strict databases (i.e., Postgres and HyperSQL)
#' @export

collect_strict_databases <- function(d) {
  dc <- d %>% dplyr::filter(pipeline %in% c("AllOperatorsNoFKANormalisedWithClassifiers")) %>%
    dplyr::filter(type %in% c("removed")) %>% dplyr::filter(operator %in% c("PostgresRemover", "HyperSQLRemover"))
  return(dc)
}

## REMOVING mutants
## Posted in Slack on 15/07/2016
## So my reading is:
## - for stillborn mutants, use HyperSQL/PostgresRemover
## - for impaired mutants use SQLiteClassifier
## - for equivalent mutants, add EquivalentMutantClassifier to impaired
## - for redundant mutants, add RedundantMutantClassifier to equivalent

#' FUNCTION: collect_removers_stillborn
#'
#' DESCRIPTION: Collect the removers that are for stillborn mutants SQLite dbms has NO stillborn mutants.
#' @export

collect_removers_stillborn <- function(d) {
  static_hypersql_removers <- d %>% collect_removers_static_hypersql()
  static_postgres_removers <- d %>% collect_removers_static_postgres()
  dbms_remover <- d %>% collect_removers_dynamic_transacted()
  removers_data <- dplyr::bind_rows(static_hypersql_removers, static_postgres_removers, dbms_remover)
  return(removers_data)
}

#' FUNCTION: collect_removers_impaired
#'
#' DESCRIPTION: Collect the removers that are for impaired mutants. Only SQLite dbms has impaired mutants
#' We need to first remove stillborn because mutant removal is an iterative process.
#' The removal processes are not independent of eachother --- they build on the last stage.
#' @export

collect_removers_impaired <- function(d) {
  imp <- d %>% collect_static() %>%
    dplyr::filter(type == "removed") %>%
    dplyr::filter(operator %in% c("SQLiteClassifier"))
  return(imp)
}

#' FUNCTION: collect_removers_equivalent
#'
#' DESCRIPTION: Collect the removers that are for equivalent mutants
#' We need to first remove stillborn and impaired because mutant removal is an iterative process.
#' The removal processes are not independent of eachother --- they build on the last stage.
#' @export

collect_removers_equivalent <- function(d) {
  equ = d %>% collect_static() %>%
    dplyr::filter(type == "removed") %>%
    dplyr::filter(operator %in% c("EquivalentMutantClassifier"))
  return(equ)
}

#' FUNCTION: collect_removers_redundant
#'
#' DESCRIPTION: Collect the removers that are for redundant mutants
#' We need to first remove stillborn, impaired and equivalent because mutant removal is an iterative process.
#' The removal processes are not independent of eachother --- they build on the last stage.
#' @export

collect_removers_redundant <- function(d) {
  red <- d %>% collect_static() %>%
    dplyr::filter(type == "removed") %>%
    dplyr::filter(operator %in% c("RedundantMutantClassifier"))
return(red)
}

#' FUNCTION:  collect_mutants_stillborn
#'
#' DESCRIPTION: Collect the mutants that are stillborn
#' @export

collect_mutants_stillborn <- function(d) {
  de <- d %>% dplyr::filter(type %in% c("STILLBORN"))
  return(de)
}

#' FUNCTION:  collect_mutants_impaired
#'
#' DESCRIPTION: Collect the mutants that are run and yet are impaired
#' @export

collect_mutants_impaired <- function(d) {
  de <- d %>% dplyr::filter(type %in% c("IMPAIRED"))
  return(de)
}

#' FUNCTION:  collect_mutants_equivalent
#'
#' DESCRIPTION: Collect the mutants that are run and yet are equivalent
#' @export

collect_mutants_equivalent <- function(d) {
  de <- d %>% dplyr::filter(type %in% c("EQUIVALENT"))
  return(de)
}

#' FUNCTION: collect_mutants_redundant
#'
#' DESCRIPTION: Collect the mutants that are run and yet are redundant
#' @export

collect_mutants_redundant <- function(d) {
  de <- d %>% dplyr::filter(type %in% c("DUPLICATE"))
  return(de)
}

#' FUNCTION:  collect_remove_mutants_impaired
#'
#' DESCRIPTION: Collect the mutants that are run and yet are impaired and remove them
#' @export

collect_remove_mutants_impaired <- function(d) {
  de <- d %>% dplyr::filter(!(type %in% c("IMPAIRED")))
  return(de)
}

#' FUNCTION:  collect_remove_mutants_impaired_equivalent
#'
#' DESCRIPTION: Collect the mutants that are run and yet are equivalent, includes imparied mutants and remove them
#' @export

collect_remove_mutants_impaired_equivalent <- function(d) {
  de <- d %>% dplyr::filter(!(type %in% c("EQUIVALENT", "IMPAIRED")))
  return(de)
}

#' FUNCTION:  collect_remove_mutants_impaired_equivalent_redundant
#'
#' DESCRIPTION: Collect the mutants that are run and yet are redundant, includes imparied and equivalent mutants and remove them
#' @export

collect_remove_mutants_impaired_equivalent_redundant <- function(d) {
  de <- d %>% dplyr::filter(!(type %in% c("DUPLICATE", "EQUIVALENT", "IMPAIRED")))
  return(de)
}

#' FUNCTION: collect_mutants_killed_count
#'
#' DESCRIPTION: Collect the mutants that are run and are killed
#' @export

collect_mutants_killed_count <- function(d) {
  de <- d %>% dplyr::group_by(schema, dbms) %>% dplyr::filter(killed %in% c("true")) %>% dplyr::count()
  return(de)
}

#' FUNCTION: collect_mutants_total_count
#'
#' DESCRIPTION: Collect the mutants that are run and are killed and alive
#' @export

collect_mutants_total_count <- function(d) {
  tot <- d %>% dplyr::group_by(schema, dbms) %>% dplyr::filter(killed %in% c("true", "false")) %>% dplyr::count()
  return(tot)
}

#' FUNCTION: collect_minus_stillborn_equivalent_redundant
#'
#' DESCRIPTION: Collect only the data for -(S), -(S+I+E), and -(S+I+E+R). This is used to remove the
#' -(S+I) data from the strict dbms data because it is identical to the -(S) data.
#' @export

collect_minus_stillborn_equivalent_redundant <- function(d) {
  de <- d %>% dplyr::filter(timetype %in% c("-(S)", "-(S+I+E)", "-(S+I+E+R)"))
  return(de)
}

