#' FUNCTION: read_analyse_pipeline
#' READ THE DATA FOR THE MUTATION ANALYSIS PIPELINE
#'
#' DESCRIPTION: read in the data file containing the data about:
#' -- time taken to detect stillborn mutants using the
#'       -- Dynamic
#'       -- Transaction
#'       -- Static
#' methods. This data is recorded for all schemas and for all three DBMSs.
#' @export

read_analyse_pipeline <- function() {
  f <- system.file("extdata", "analyse-pipeline.dat", package="ineffectivemutants")
  d <- readr::read_csv(f)
  return(dplyr::tbl_df(d))
}

#' FUNCTION: read_hypersql_avmdefaults
#' READ THE DATA FOR THE TIME TAKEN TO PERFORM MUTATION ANALYSIS
#'
#' DESCRIPTION: Read in the data file containing the data about:
#' -- time taken to run the mutation analysis for each
#'       -- Operator
#'       -- Type of mutant
#' @export

read_hypersql_avmdefaults <- function() {
  f <- system.file("extdata", "hypersql-avmdefaults.dat", package="ineffectivemutants")
  d <- readr::read_csv(f)
  return(dplyr::tbl_df(d))
}

#' FUNCTION: read_hypersql_random
#'
#' DESCRIPTION: Read in the data file containing the data about:
#' -- time taken to run the mutation analysis for each
#'       -- Operator
#'       -- Type of mutant
#' @export

read_hypersql_random <- function() {
  f <- system.file("extdata", "hypersql-random.dat", package="ineffectivemutants")
  d <- readr::read_csv(f)
  return(dplyr::tbl_df(d))
}

#' FUNCTION: read_postgres_avmdefaults
#'
#' DESCRIPTION: Read in the data file containing the data about:
#' -- time taken to run the mutation analysis for each
#'       -- Operator
#'       -- Type of mutant
#' @export

read_postgres_avmdefaults <- function() {
  f <- system.file("extdata", "postgres-avmdefaults.dat", package="ineffectivemutants")
  d <- readr::read_csv(f)
  return(dplyr::tbl_df(d))
}

#' FUNCTION: read_postgres_random
#'
#' DESCRIPTION: Read in the data file containing the data about:
#' -- time taken to run the mutation analysis for each
#'       -- Operator
#'       -- Type of mutant
#' @export

read_postgres_random <- function() {
  # f <- paste(goback, datadir, postgres_random_file, sep=forwardslash)
  f <- system.file("extdata", "postgres-random.dat", package="ineffectivemutants")
  d <- readr::read_csv(f)
  return(dplyr::tbl_df(d))
}

#' FUNCTION: read_sqlite_avmdefaults
#'
#' DESCRIPTION: Read in the data file containing the data about:
#' -- time taken to run the mutation analysis for each
#'       -- Operator
#'       -- Type of mutant
#' @export

read_sqlite_avmdefaults <- function() {
  f <- system.file("extdata", "sqlite-avmdefaults.dat", package="ineffectivemutants")
  d <- readr::read_csv(f)
  return(dplyr::tbl_df(d))
}

#' FUNCTION: read_sqlite_random
#'
#' DESCRIPTION: Read in the data file containing the data about:
#' -- time taken to run the mutation analysis for each
#'       -- Operator
#'       -- Type of mutant
#' @export

read_sqlite_random <- function() {
  f <- system.file("extdata", "sqlite-random.dat", package="ineffectivemutants")
  d <- readr::read_csv(f)
  return(dplyr::tbl_df(d))
}

#' FUNCTION: read_strict_avmdefaults
#'
#' DESCRIPTION: Read in the two data files for the DBMS that are strict in their interpretation of the SQL
#' standard (e.g., HyperSQL and Postgres) since they are always grouped in the analysis of times and scores
#' @export

read_strict_avmdefaults <- function() {
  h <- read_hypersql_avmdefaults()
  p <- read_postgres_avmdefaults()
  hp <- dplyr::bind_rows(h, p)
  return(hp)
}

#' FUNCTION: read_strict_random
#'
#' DESCRIPTION: Read in the two data files for the DBMS that are strict in their interpretation of the SQL
#' standard (e.g., HyperSQL and Postgres) since they are always grouped in the analysis of times and scores
#' @export

read_strict_random <- function() {
  h <- read_hypersql_random()
  p <- read_postgres_random()
  hp <- dplyr::bind_rows(h, p)
  return(hp)
}

#' FUNCTION: read_sqlite_ineffective
#' READ THE DATA FOR THE INEFFECTIVE MUTANTS
#'
#' DESCRIPTION: read in the data file containing the data about:
#' -- time taken to detect stillborn mutants using the
#'       -- Dynamic
#'       -- Transaction
#'       -- Static
#' methods. This data is recorded for all schemas and for just SQLite DBMS.
#' @export

read_sqlite_ineffective <- function() {
  f <- system.file("extdata", "sqlite-ineffective-mutants.dat", package="ineffectivemutants")
  d <- readr::read_csv(f)
  return(dplyr::tbl_df(d))
}

