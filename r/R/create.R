#' FUNCTION: create_pipeline_graphs
#'
#' DESCRIPTION: Create all of the graphs for the time take in the mutation analysis pipeline for dynamic and static
#' @export

create_pipeline_graphs <- function() {
  pipeline_data <- read_analyse_pipeline() %>% transform_standardise_schema()
  top <- visualise_timetaken_dynamic_transacted_fast(pipeline_data)
  bottom_left <- visualise_timetaken_dynamic_transacted_slow(pipeline_data)
  bottom_right <- visualise_timetaken_static(pipeline_data)
  visualise_timetaken_combined(top, bottom_left, bottom_right)
}

#' FUNCTION:  create_mutation_time_graphs
#'
#' DESCRIPTION: Create all of the graphs for the time taken to perform mutation analysis
#' @export

create_mutation_time_graphs <- function() {
  # 1. Read in the mutation analysis pipeline data, needed for the Equivalent and Redundant data values
  pipeline_data <- read_analyse_pipeline() %>% transform_standardise_schema()
  pipeline_data_strict_summary <- pipeline_data %>% collect_strict_databases() %>% summarise_mutation_analysis_pipeline()
  pipeline_data_sqlite_summary <- pipeline_data %>% collect_removers_static_sqlite() %>% summarise_mutation_analysis_pipeline()
  print("preliminary steps complete")

  # 1a. Summarise the various analysis times for the HyperSQL, Postgres and SQLite DBMSs
  #### Stillborn mutant analysis
  pipeline_data_static_hp_stillborn <- pipeline_data %>% collect_hypersql_postgres() %>% collect_removers_stillborn() %>% summarise_mutation_analysis_stillborn_operator()
  pipeline_data_static_s_stillborn <- pipeline_data %>% collect_sqlite() %>% summarise_mutation_analysis_stillborn_operator()
  #### Impaired mutant analysis
  pipeline_data_static_hp_impaired <- pipeline_data %>% collect_hypersql_postgres() %>% collect_removers_impaired() %>% summarise_mutation_analysis_impaired_operator()
  pipeline_data_static_s_impaired <- pipeline_data %>% collect_sqlite() %>% collect_removers_impaired() %>% summarise_mutation_analysis_impaired_operator()
  #### Equivalent mutant analysis
  pipeline_data_static_hp_equivalent <- pipeline_data %>% collect_hypersql_postgres() %>% collect_removers_equivalent() %>% summarise_mutation_analysis_equivalent_operator()
  pipeline_data_static_s_equivalent <- pipeline_data %>% collect_sqlite() %>% collect_removers_equivalent() %>% summarise_mutation_analysis_equivalent_operator()
  #### Redundant mutant analysis
  pipeline_data_static_hp_redundant <- pipeline_data %>% collect_hypersql_postgres() %>% collect_removers_redundant() %>% summarise_mutation_analysis_redundant_operator()
  pipeline_data_static_s_redundant <- pipeline_data %>% collect_sqlite() %>% collect_removers_redundant() %>% summarise_mutation_analysis_redundant_operator()
  #### Create the single data frame that contains all of the summary values
  pipeline_data_static_hp_join <- join_stillborn_impaired_equivalent_redundant(pipeline_data_static_hp_stillborn, pipeline_data_static_hp_impaired, pipeline_data_static_hp_equivalent, pipeline_data_static_hp_redundant) %>% transform_replace_NA_with_zero_rem_imp()
  pipeline_data_static_s_join <- join_stillborn_impaired_equivalent_redundant(pipeline_data_static_s_stillborn, pipeline_data_static_s_impaired, pipeline_data_static_s_equivalent, pipeline_data_static_s_redundant)
  print("step 1 complete")

  # 2a. Read in and then calculate the mutation data for the AVM
  mutation_data_strict_avm <- read_strict_avmdefaults()
  mutation_data_sqlite_avm <- read_sqlite_avmdefaults()
  #### Calculate the time to run the ALL mutation analysis (i.e., the ALL time)
  mutation_data_strict_summary_avm_all <- mutation_data_strict_avm %>% summarise_total_mutation_time()
  mutation_data_sqlite_summary_avm_all <- mutation_data_sqlite_avm %>% summarise_total_mutation_time()
  #### Calculate the time associated with running the IMPAIRED mutants, they can be subtracted off
  mutation_data_strict_summary_avm_impaired <- mutation_data_strict_avm %>% collect_mutants_impaired() %>% summarise_total_impaired_time()
  mutation_data_sqlite_summary_avm_impaired <- mutation_data_sqlite_avm %>% collect_mutants_impaired() %>% summarise_total_impaired_time()
  #### Calculate the time associated with running the EQUIVALENT mutants, they can be subtracted off
  mutation_data_strict_summary_avm_equivalent <- mutation_data_strict_avm %>% collect_mutants_equivalent() %>% summarise_total_equivalent_time()
  mutation_data_sqlite_summary_avm_equivalent <- mutation_data_sqlite_avm %>% collect_mutants_equivalent() %>% summarise_total_equivalent_time()
  #### Calculate the time associated with running the REDUNDANT mutants, they can be subtracted off
  mutation_data_strict_summary_avm_redundant <- mutation_data_strict_avm %>% collect_mutants_redundant() %>% summarise_total_redundant_time()
  mutation_data_sqlite_summary_avm_redundant <- mutation_data_sqlite_avm %>% collect_mutants_redundant() %>% summarise_total_redundant_time()
  print("step 2a complete")

  # 2b. Read in and then calculate the mutation data for the RANDOM
  mutation_data_strict_ran <- read_strict_random()
  mutation_data_sqlite_ran <- read_sqlite_random()
  #### Calculate the time to run the ALL mutation analysis (i.e., the ALL time)
  mutation_data_strict_summary_ran_all <- mutation_data_strict_ran %>% summarise_total_mutation_time()
  mutation_data_sqlite_summary_ran_all <- mutation_data_sqlite_ran %>% summarise_total_mutation_time()
  #### Calculate the time associated with running the IMPAIRED mutants, they can be subtracted off
  mutation_data_strict_summary_ran_impaired <- mutation_data_strict_ran %>% collect_mutants_impaired() %>% summarise_total_impaired_time()
  mutation_data_sqlite_summary_ran_impaired <- mutation_data_sqlite_ran %>% collect_mutants_impaired() %>% summarise_total_impaired_time()
  #### Calculate the time associated with running the EQUIVALENT mutants, they can be subtracted off
  mutation_data_strict_summary_ran_equivalent <- mutation_data_strict_ran %>% collect_mutants_equivalent() %>% summarise_total_equivalent_time()
  mutation_data_sqlite_summary_ran_equivalent <- mutation_data_sqlite_ran %>% collect_mutants_equivalent() %>% summarise_total_equivalent_time()
  #### Calculate the time associated with running the REDUNDANT mutants, they can be subtracted off
  mutation_data_strict_summary_ran_redundant <- mutation_data_strict_ran %>% collect_mutants_redundant() %>% summarise_total_redundant_time()
  mutation_data_sqlite_summary_ran_redundant <- mutation_data_sqlite_ran %>% collect_mutants_redundant() %>% summarise_total_redundant_time()
  print("step 2b complete")

  # 3a. Perform the joins for the AVM's mutation data
  mutation_data_all_join_strict_avm <- join_mutation_analysis_stillborn_impaired_equivalent_redundant(mutation_data_strict_summary_avm_all, mutation_data_strict_summary_avm_impaired, mutation_data_strict_summary_avm_equivalent, mutation_data_strict_summary_avm_redundant) %>%
    transform_replace_NA_with_zero_i() %>% transform_replace_NA_with_zero_e() %>% transform_replace_NA_with_zero_r()
  mutation_data_all_join_sqlite_avm <- join_mutation_analysis_stillborn_impaired_equivalent_redundant(mutation_data_sqlite_summary_avm_all, mutation_data_sqlite_summary_avm_impaired, mutation_data_sqlite_summary_avm_equivalent, mutation_data_sqlite_summary_avm_redundant) %>%
    transform_replace_NA_with_zero_i() %>% transform_replace_NA_with_zero_e() %>% transform_replace_NA_with_zero_r()
  print("step 3a complete")

  # 3b. Perform the joins for the RANDOM's mutation data
  mutation_data_all_join_strict_ran <- join_mutation_analysis_stillborn_impaired_equivalent_redundant(mutation_data_strict_summary_ran_all, mutation_data_strict_summary_ran_impaired, mutation_data_strict_summary_ran_equivalent, mutation_data_strict_summary_ran_redundant) %>%
    transform_replace_NA_with_zero_i() %>% transform_replace_NA_with_zero_e() %>% transform_replace_NA_with_zero_r()
  mutation_data_all_join_sqlite_ran <- join_mutation_analysis_stillborn_impaired_equivalent_redundant(mutation_data_sqlite_summary_ran_all, mutation_data_sqlite_summary_ran_impaired, mutation_data_sqlite_summary_ran_equivalent, mutation_data_sqlite_summary_ran_redundant) %>%
    transform_replace_NA_with_zero_i() %>% transform_replace_NA_with_zero_e() %>% transform_replace_NA_with_zero_r()
  print("step 3b complete")

  # 4a. Combine the data about the cost of removing certain mutants with the AVM's mutant running time data
  hp_join_mer_avm <- join_remover_and_mutation_analysis(pipeline_data_static_hp_join, mutation_data_all_join_strict_avm)
  s_join_mer_avm <- join_remover_and_mutation_analysis(pipeline_data_static_s_join, mutation_data_all_join_sqlite_avm)
  print("step 4a complete")

  # 4b. Combine the data about the cost of removing certain mutants with the RANDOM's mutant running time data
  hp_join_mer_ran <- join_remover_and_mutation_analysis(pipeline_data_static_hp_join, mutation_data_all_join_strict_ran)
  s_join_mer_ran <- join_remover_and_mutation_analysis(pipeline_data_static_s_join, mutation_data_all_join_sqlite_ran)
  print("step 4b complete")

  # 5a. Add the new timetaken variables to the joined data frame for AVM, in preparing for graphing
  # HyperSQL and Postgres
  hp_join_mer_avm_all <- hp_join_mer_avm %>% transform_add_all_time()
  hp_join_mer_avm_imp <- hp_join_mer_avm %>% transform_add_impaired_time()
  hp_join_mer_avm_equ <- hp_join_mer_avm %>% transform_add_equivalent_time()
  hp_join_mer_avm_red <- hp_join_mer_avm %>% transform_add_equivalent_redundant_time()
  final_data_strict_avm <- dplyr::bind_rows(hp_join_mer_avm_all, hp_join_mer_avm_imp,  hp_join_mer_avm_equ, hp_join_mer_avm_red) %>% transform_move_timings() %>% transform_move_characteristics()
  final_data_strict_avm_all_summary <- final_data_strict_avm %>% summarise_mean_mutation_time() %>% dplyr::mutate(timetype = "-(S)")
  final_data_strict_avm_equ_summary <- final_data_strict_avm %>% summarise_mean_equivalent_time() %>% dplyr::mutate(timetype = "-(S+I+E)")
  final_data_strict_avm_red_summary <- final_data_strict_avm %>% summarise_mean_redundant_time() %>% dplyr::mutate(timetype = "-(S+I+E+R)")
  final_data_strict_avm_summary <- dplyr::bind_rows(final_data_strict_avm_all_summary, final_data_strict_avm_equ_summary, final_data_strict_avm_red_summary)
  print(final_data_strict_avm %>% summarise_mutation_analysis_stillborn_equivalent_redundant_time())

  # SQLite
  s_join_mer_avm_all <- s_join_mer_avm %>% transform_add_all_time()
  s_join_mer_avm_imp <- s_join_mer_avm %>% transform_add_impaired_time()
  s_join_mer_avm_equ <- s_join_mer_avm %>% transform_add_equivalent_time()
  s_join_mer_avm_red <- s_join_mer_avm %>% transform_add_equivalent_redundant_time()
  final_data_sqlite_avm <- dplyr::bind_rows(s_join_mer_avm_all, s_join_mer_avm_imp,  s_join_mer_avm_equ, s_join_mer_avm_red) %>% transform_move_timings() %>% transform_move_characteristics()
  final_data_sqlite_avm_all_summary <- final_data_sqlite_avm %>% summarise_mean_mutation_time() %>% dplyr::mutate(timetype = "-(S)")
  final_data_sqlite_avm_imp_summary <- final_data_sqlite_avm %>% summarise_mean_impaired_time() %>% dplyr::mutate(timetype = "-(S+I)")
  final_data_sqlite_avm_equ_summary <- final_data_sqlite_avm %>% summarise_mean_equivalent_time() %>% dplyr::mutate(timetype = "-(S+I+E)")
  final_data_sqlite_avm_red_summary <- final_data_sqlite_avm %>% summarise_mean_redundant_time() %>% dplyr::mutate(timetype = "-(S+I+E+R)")
  final_data_sqlite_avm_summary <- dplyr::bind_rows(final_data_sqlite_avm_all_summary, final_data_sqlite_avm_imp_summary, final_data_sqlite_avm_equ_summary, final_data_sqlite_avm_red_summary)
  print(final_data_sqlite_avm %>% summarise_mutation_analysis_stillborn_equivalent_redundant_time())
  print("step 5a complete")

  # 5b. Add the new timetaken variables to the joined data frame for RANDOM, in preparing for graphing
  # HyperSQL and Postgres
  hp_join_mer_strict_ran_all <- hp_join_mer_ran %>% transform_add_all_time()
  hp_join_mer_strict_ran_imp <- hp_join_mer_ran %>% transform_add_impaired_time()
  hp_join_mer_strict_ran_equ <- hp_join_mer_ran %>% transform_add_equivalent_time()
  hp_join_mer_strict_ran_red <- hp_join_mer_ran %>% transform_add_equivalent_redundant_time()
  final_data_strict_ran <- dplyr::bind_rows(hp_join_mer_strict_ran_all, hp_join_mer_strict_ran_imp, hp_join_mer_strict_ran_equ, hp_join_mer_strict_ran_red) %>% transform_move_timings() %>% transform_move_characteristics()
  final_data_strict_ran_all_summary <- final_data_strict_ran %>% summarise_mean_mutation_time() %>% dplyr::mutate(timetype = "-(S)")
  final_data_strict_ran_equ_summary <- final_data_strict_ran %>% summarise_mean_equivalent_time() %>% dplyr::mutate(timetype = "-(S+I+E)")
  final_data_strict_ran_red_summary <- final_data_strict_ran %>% summarise_mean_redundant_time() %>% dplyr::mutate(timetype = "-(S+I+E+R)")
  final_data_strict_ran_summary <- dplyr::bind_rows(final_data_strict_ran_all_summary, final_data_strict_ran_equ_summary, final_data_strict_ran_red_summary)
  print(final_data_strict_ran_summary)

  # SQLite
  s_join_mer_sqlite_ran_all <- s_join_mer_ran %>% transform_add_all_time()
  s_join_mer_sqlite_ran_imp <- s_join_mer_ran %>% transform_add_impaired_time()
  s_join_mer_sqlite_ran_equ <- s_join_mer_ran %>% transform_add_equivalent_time()
  s_join_mer_sqlite_ran_red <- s_join_mer_ran %>% transform_add_equivalent_redundant_time()
  final_data_sqlite_ran <- dplyr::bind_rows(s_join_mer_sqlite_ran_all, s_join_mer_sqlite_ran_imp, s_join_mer_sqlite_ran_equ, s_join_mer_sqlite_ran_red) %>% transform_move_timings() %>% transform_move_characteristics()
  final_data_sqlite_ran_all_summary <- final_data_sqlite_ran %>% summarise_mean_mutation_time() %>% dplyr::mutate(timetype = "-(S)")
  final_data_sqlite_ran_imp_summary <- final_data_sqlite_ran %>% summarise_mean_impaired_time() %>% dplyr::mutate(timetype = "-(S+I)")
  final_data_sqlite_ran_equ_summary <- final_data_sqlite_ran %>% summarise_mean_equivalent_time() %>% dplyr::mutate(timetype = "-(S+I+E)")
  final_data_sqlite_ran_red_summary <- final_data_sqlite_ran %>% summarise_mean_redundant_time() %>% dplyr::mutate(timetype = "-(S+I+E+R)")
  final_data_sqlite_ran_summary <- dplyr::bind_rows(final_data_sqlite_ran_all_summary, final_data_sqlite_ran_imp_summary, final_data_sqlite_ran_equ_summary, final_data_sqlite_ran_red_summary)
  print(final_data_sqlite_ran %>% summarise_mutation_analysis_stillborn_equivalent_redundant_time())
  print("step 5b complete")

  # 6a. Create the plot for all of the three different types of timings, both of the DBMSs, and the AVM data generator
  print("Working on creating strict and sqlite AVM visualizations")
  h_avm <- visualise_mutation_timetaken_strict_avmdefaults(final_data_strict_avm_summary %>% collect_hypersql() %>% collect_minus_stillborn_equivalent_redundant(), "bottom")
  p_avm <- visualise_mutation_timetaken_strict_avmdefaults(final_data_strict_avm_summary %>% collect_postgres() %>% collect_minus_stillborn_equivalent_redundant(), "middle")
  h_avm_summary <- visualise_mutation_timetaken_strict_avmdefaults_summary(final_data_strict_avm_summary %>% collect_hypersql() %>% collect_minus_stillborn_equivalent_redundant(), "bottom")
  p_avm_summary <- visualise_mutation_timetaken_strict_avmdefaults_summary(final_data_strict_avm_summary %>% collect_postgres() %>% collect_minus_stillborn_equivalent_redundant(), "middle")
  s_avm <- visualise_mutation_timetaken_avmdefaults(final_data_sqlite_avm_summary, "top")
  s_avm_summary <- visualise_mutation_timetaken_avmdefaults_summary(final_data_sqlite_avm_summary, "top")
  print("step 6a complete")

  # 6b. Create the plot for all of the three different types of timings, both of the DBMSs, and the RANDOM data generator
  print("Working on creating strict and sqlite RANDOM visualizations")
  h_ran <- visualise_mutation_timetaken_strict_random(final_data_strict_ran_summary %>% collect_hypersql() %>% collect_minus_stillborn_equivalent_redundant(), "bottom")
  p_ran <- visualise_mutation_timetaken_strict_random(final_data_strict_ran_summary %>% collect_postgres() %>% collect_minus_stillborn_equivalent_redundant(), "middle")
  h_ran_summary <- visualise_mutation_timetaken_strict_random_summary(final_data_strict_ran_summary %>% collect_hypersql() %>% collect_minus_stillborn_equivalent_redundant(), "bottom")
  p_ran_summary <- visualise_mutation_timetaken_strict_random_summary(final_data_strict_ran_summary %>% collect_postgres() %>% collect_minus_stillborn_equivalent_redundant(), "middle")
  s_ran <- visualise_mutation_timetaken_random(final_data_sqlite_ran_summary, "top")
  s_ran_summary <- visualise_mutation_timetaken_random_summary(final_data_sqlite_ran_summary, "top")
  print("step 6b complete")

  # 7a. Combine the AVM plots
  avm_combined <- visualise_combined("mutation_timetaken_avm_combined.pdf", s_avm, p_avm, h_avm, 5, 8)
  avm_summary_combined <- visualise_combined("mutation_timetaken_avm_summary_combined.pdf", s_avm_summary, p_avm_summary, h_avm_summary, 5, 5)
  print("step 7a complete")

  # 7b. Combine the RANDOM plots
  ran_combined <- visualise_combined("mutation_timetaken_random_combined.pdf", s_ran, p_ran, h_ran, 5, 8)
  ran_summary_combined <- visualise_combined("mutation_timetaken_random_summary_combined.pdf", s_ran_summary, p_ran_summary, h_ran_summary, 5, 5)
  print("step 7b complete")
}

#' FUNCTION:  create_mutation_score_graphs
#'
#' DESCRIPTION: Create all of the graphs for the mutation scores throughout the mutant removal stages
#' @export

create_mutation_score_graphs <- function() {
  # 1. Read in the mutation analysis pipeline data, needed for the Equivalent and Redundant data values
  pipeline_data <- read_analyse_pipeline() %>% transform_standardise_schema()
  pipeline_data_strict_summary <- pipeline_data %>% collect_strict_databases() %>% summarise_mutation_analysis_pipeline()
  pipeline_data_sqlite_summary <- pipeline_data %>% collect_sqlite() %>% summarise_mutation_analysis_pipeline()
  print("preliminary steps complete")

  # 2a. Read in and then calculate the mutation data for the AVM
  mutation_data_strict_avm <- read_strict_avmdefaults()
  mutation_data_sqlite_avm <- read_sqlite_avmdefaults()
  #### Calculate the time to run the ALL mutation analysis (i.e., the ALL time)
  mutation_data_strict_avm_all <- mutation_data_strict_avm %>% summarise_total_mutation_score() %>% transform_all_mutation_score()
  mutation_data_sqlite_avm_all <- mutation_data_sqlite_avm %>% summarise_total_mutation_score() %>% transform_all_mutation_score()
  #### Calculate the time associated with running the IMPAIRED mutants, they can be subtracted off
  mutation_data_strict_avm_impaired <- mutation_data_strict_avm %>% collect_remove_mutants_impaired() %>% summarise_impaired_mutation_score() %>% transform_impaired_mutation_score()
  mutation_data_sqlite_avm_impaired <- mutation_data_sqlite_avm %>% collect_remove_mutants_impaired() %>% summarise_impaired_mutation_score() %>% transform_impaired_mutation_score()
  #### Calculate the time associated with running the EQUIVALENT mutants, they can be subtracted off
  mutation_data_strict_avm_equivalent <- mutation_data_strict_avm %>% collect_remove_mutants_impaired_equivalent() %>% summarise_equivalent_mutation_score() %>% transform_equivalent_mutation_score()
  mutation_data_sqlite_avm_equivalent <- mutation_data_sqlite_avm %>% collect_remove_mutants_impaired_equivalent() %>% summarise_equivalent_mutation_score() %>% transform_equivalent_mutation_score()
  #### Calculate the time associated with running the REDUNDANT mutants, they can be subtracted off
  mutation_data_strict_avm_redundant <- mutation_data_strict_avm %>% collect_remove_mutants_impaired_equivalent_redundant() %>% summarise_redundant_mutation_score() %>% transform_redundant_mutation_score()
  mutation_data_sqlite_avm_redundant <- mutation_data_sqlite_avm %>% collect_remove_mutants_impaired_equivalent_redundant() %>% summarise_redundant_mutation_score() %>% transform_redundant_mutation_score()
  #### Join all of the mutation data
  join_mutation_data_strict_avm <- dplyr::bind_rows(mutation_data_strict_avm_all, mutation_data_strict_avm_impaired, mutation_data_strict_avm_equivalent, mutation_data_strict_avm_redundant)
  join_mutation_data_sqlite_avm <- dplyr::bind_rows(mutation_data_sqlite_avm_all, mutation_data_sqlite_avm_impaired, mutation_data_sqlite_avm_equivalent, mutation_data_sqlite_avm_redundant)
  print(join_mutation_data_strict_avm)
  print(join_mutation_data_sqlite_avm)
  print("step 2a complete")

  # 2b. Read in and then calculate the mutation data for the RANDOM
  mutation_data_strict_ran <- read_strict_random()
  mutation_data_sqlite_ran <- read_sqlite_random()
  #### Calculate the time to run the ALL mutation analysis (i.e., the ALL time)
  mutation_data_strict_ran_all <- mutation_data_strict_ran %>% summarise_total_mutation_score() %>% transform_all_mutation_score()
  mutation_data_sqlite_ran_all <- mutation_data_sqlite_ran %>% summarise_total_mutation_score() %>% transform_all_mutation_score()
  #### Calculate the time associated with running the IMPAIRED mutants, they can be subtracted off
  mutation_data_strict_ran_impaired <- mutation_data_strict_ran %>% collect_remove_mutants_impaired() %>% summarise_impaired_mutation_score() %>% transform_impaired_mutation_score()
  mutation_data_sqlite_ran_impaired <- mutation_data_sqlite_ran %>% collect_remove_mutants_impaired() %>% summarise_impaired_mutation_score() %>% transform_impaired_mutation_score()
  #### Calculate the time associated with running the EQUIVALENT mutants, they can be subtracted off
  mutation_data_strict_ran_equivalent <- mutation_data_strict_ran %>% collect_remove_mutants_impaired_equivalent() %>% summarise_equivalent_mutation_score() %>% transform_equivalent_mutation_score()
  mutation_data_sqlite_ran_equivalent <- mutation_data_sqlite_ran %>% collect_remove_mutants_impaired_equivalent() %>% summarise_equivalent_mutation_score() %>% transform_equivalent_mutation_score()
  #### Calculate the time associated with running the REDUNDANT mutants, they can be subtracted off
  mutation_data_strict_ran_redundant <- mutation_data_strict_ran %>% collect_remove_mutants_impaired_equivalent_redundant() %>% summarise_redundant_mutation_score() %>% transform_redundant_mutation_score()
  mutation_data_sqlite_ran_redundant <- mutation_data_sqlite_ran %>% collect_remove_mutants_impaired_equivalent_redundant() %>% summarise_redundant_mutation_score() %>% transform_redundant_mutation_score()
  #### Join all of the mutation data
  join_mutation_data_strict_ran <- dplyr::bind_rows(mutation_data_strict_ran_all, mutation_data_strict_ran_impaired, mutation_data_strict_ran_equivalent, mutation_data_strict_ran_redundant)
  join_mutation_data_sqlite_ran <- dplyr::bind_rows(mutation_data_sqlite_ran_all, mutation_data_sqlite_ran_impaired, mutation_data_sqlite_ran_equivalent, mutation_data_sqlite_ran_redundant)
  print(join_mutation_data_strict_ran)
  print(join_mutation_data_sqlite_ran)
  print("step 2b complete")

  # 3a. Create the plot for all of the three different types of mutation score calculations, both of the DBMSs, and the AVM data generator
  h_avm <- visualise_mutation_score_strict_avmdefaults(join_mutation_data_strict_avm %>% collect_hypersql() %>% collect_minus_stillborn_equivalent_redundant(), "bottom")
  p_avm <- visualise_mutation_score_strict_avmdefaults(join_mutation_data_strict_avm %>% collect_postgres() %>% collect_minus_stillborn_equivalent_redundant(), "middle")
  h_avm_summary <- visualise_mutation_score_strict_avmdefaults_summary(join_mutation_data_strict_avm %>% collect_hypersql() %>% collect_minus_stillborn_equivalent_redundant(), "bottom")
  p_avm_summary <- visualise_mutation_score_strict_avmdefaults_summary(join_mutation_data_strict_avm %>% collect_postgres() %>% collect_minus_stillborn_equivalent_redundant(), "middle")
  s_avm <- visualise_mutation_score_avmdefaults(join_mutation_data_sqlite_avm, "top")
  s_avm_summary <- visualise_mutation_score_avmdefaults_summary(join_mutation_data_sqlite_avm, "top")
  print("step 3a complete")

  # 3b. Create the plot for all of the three different types of timings, both of the DBMSs, and the RANDOM data generator
  h_ran <- visualise_mutation_score_strict_random(join_mutation_data_strict_ran %>% collect_hypersql() %>% collect_minus_stillborn_equivalent_redundant(), "bottom")
  p_ran <- visualise_mutation_score_strict_random(join_mutation_data_strict_ran %>% collect_postgres() %>% collect_minus_stillborn_equivalent_redundant(), "middle")
  h_ran_summary <- visualise_mutation_score_strict_random_summary(join_mutation_data_strict_ran %>% collect_hypersql() %>% collect_minus_stillborn_equivalent_redundant(), "bottom")
  p_ran_summary <- visualise_mutation_score_strict_random_summary(join_mutation_data_strict_ran %>% collect_postgres() %>% collect_minus_stillborn_equivalent_redundant(), "middle")
  s_ran <- visualise_mutation_score_random(join_mutation_data_sqlite_ran, "top")
  s_ran_summary <- visualise_mutation_score_random_summary(join_mutation_data_sqlite_ran, "top")
  print("step 3b complete")

  # 4a. Combine the AVM plots
  avm_combined <- visualise_combined("mutation_score_avm_combined.pdf", s_avm, p_avm, h_avm, 6, 8)
  avm_summary_combined <- visualise_combined("mutation_score_avm_summary_combined.pdf", s_avm_summary, p_avm_summary, h_avm_summary, 5, 5)
  print("step 4a complete")

  # 4b. Combine the RANDOM plots
  ran_combined <- visualise_combined("mutation_score_random_combined.pdf", s_ran, p_ran, h_ran, 6, 8)
  ran_summary_combined <- visualise_combined("mutation_score_random_summary_combined.pdf", s_ran_summary, p_avm_summary, h_ran_summary, 5, 5)
  print("step 4b complete")
}
