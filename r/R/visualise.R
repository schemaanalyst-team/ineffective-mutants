#' FUNCTION: visualise_timetaken_dynamic_transacted_fast
#'
#' VISUALISE EXECUTION TIME
#'
#' DESCRIPTION: visualise_timetaken_dynamic_transacted_fast: Plot and save the box and whisker plot for the amount of TIMETAKEN to remove
#' STILLBORN mutants in the mutation analysis pipeline, across all of the FAST DBMSs and all CASESTUDIES, for DYNAMIC and TRANSACTED
#' @export

visualise_timetaken_dynamic_transacted_fast <- function(data) {
  d <- data %>% collect_dynamic_transacted() %>%
      collect_removers_dynamic_transacted() %>% collect_fast_databases()
  p <- visualise_plot_timetaken(d)
  name <- "../graphics/from-data/timetaken_dynamic_transacted_boxplot_fast.pdf"
  visualise_save_graphic(name, p, 5, 8)
  return(p)
}

#' FUNCTION: visualise_timetaken_dynamic_transacted_slow
#'
#' VISUALISE EXECUTION TIME
#'
#' DESCRIPTION: Plot and save the box and whisker plot for the amount of TIMETAKEN to remove
#' STILLBORN mutants in the mutation analysis pipeline, across all of the SLOW DBMSs and all CASESTUDIES, for DYNAMIC AND TRANSACTED
#' @export

visualise_timetaken_dynamic_transacted_slow <- function(data) {
  d <- data %>% collect_dynamic_transacted() %>%
      collect_removers_dynamic_transacted() %>% collect_slow_databases()
  p <- visualise_plot_timetaken_stack_pipeline(d)
  name <- "../graphics/from-data/timetaken_dynamic_transacted_boxplot_slow.pdf"
  visualise_save_graphic(name, p, 5, 8)
  return(p)
}

#' FUNCTION: visualise_timetaken_static
#'
#' VISUALISE EXECUTION TIME
#'
#' DESCRIPTION: Plot and save the box and whisker plot for the amount of TIMETAKEN to remove
#' STILLBORN mutants in the mutation analysis pipeline, across all of the DBMSs and all CASESTUDIES, for STATIC
#' @export

visualise_timetaken_static <- function(data) {
  d <- data %>% collect_static() %>% collect_removers_static()
  p <- visualise_plot_timetaken(d)
  name <- "../graphics/from-data/timetaken_static_boxplot.pdf"
  visualise_save_graphic(name, p, 5, 8)
  return(p)
}

#' FUNCTION:  visualise_plot_timetaken
#'
#' DESCRIPTION: Generally plot different types of box and whisker plots for the timetaken in mutant removal
#' @export

visualise_plot_timetaken <- function(data) {
  p <- ggplot2::ggplot(data, ggplot2::aes(x = schema,y = timetaken)) +
    ggplot2::facet_grid(dbms~pipeline, labeller = ggplot2::label_parsed) +
    ggplot2::geom_boxplot(outlier.size = 0.75, lwd=0.25) +
    ggplot2::theme_bw(base_size = 6) +
    ggplot2::theme(title = ggplot2::element_text(size=6)) +
    ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 45, hjust = 1, size=4)) +
    ggplot2::theme(axis.text.y = ggplot2::element_text(angle = 45, hjust = 1, size=4)) +
    ggplot2::xlab("Relational Schema") +
    ggplot2::ylab("Time (ms)") +
    ggplot2::scale_y_continuous(labels = scales::comma) +
    ggplot2::stat_summary(fun.y = mean, fill = "white", colour = "black", geom = "point", shape = 23, size = 1, show.legend = FALSE)
  return(p)
}

#' FUNCTION:  visualise_plot_timetaken_stack_pipeline
#'
#' DESCRIPTION: Generally plot different types of box and whisker plots for the timetaken in mutant removal,
#' essentially just changing the way that the facet_grid is produced, compared to the visualise_plot_timetaken
#' @export

visualise_plot_timetaken_stack_pipeline <- function(data) {
  p <- ggplot2::ggplot(data, ggplot2::aes(x = schema,y = timetaken)) +
    ggplot2::facet_grid(pipeline~dbms, labeller = ggplot2::label_parsed) +
    ggplot2::geom_boxplot(outlier.size = 0.75, lwd=0.25) +
    ggplot2::theme_bw(base_size = 6) +
    ggplot2::theme(title = ggplot2::element_text(size=6)) +
    ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 45, hjust = 1, size=4)) +
    ggplot2::theme(axis.text.y = ggplot2::element_text(angle = 45, hjust = 1, size=4)) +
    ggplot2::xlab("Relational Schema") +
    ggplot2::ylab("Time (ms)") +
    ggplot2::scale_y_continuous(labels = scales::comma) +
    ggplot2::stat_summary(fun.y = mean, fill = "white", colour = "black", geom = "point", shape = 23, size = 1, show.legend = FALSE)
  return(p)
}

#' FUNCTION: visualise_timetaken_combined
#'
#' VISUALISE EXECUTION TIME
#'
#' DESCRIPTION: Create a plot that combines all of the three graphics for the timetaken data of STILLBORN mutant removal
#' @export

visualise_timetaken_combined <- function(top, bottom_left, bottom_right){
  name <- "../graphics/from-data/timetaken_combined_boxplot.pdf"
  pdf(name, height = 6, width = 8)
  grid::grid.newpage()
  grid::pushViewport(grid::viewport(layout=grid::grid.layout(2,2)))
  print(top, vp = useful::vplayout(1,1:2))
  print(bottom_left, vp = useful::vplayout(2,1))
  print(bottom_right, vp = useful::vplayout(2,2))
  dev.off()
}

## VISUALISE THE TIME TAKEN FOR MUTATION ANALYSIS

#' FUNCTION: visualise_mutation_timetaken_strict_avmdefaults
#'
#' DESCRIPTION: Plot and save a graph that shows the mutation TIMETAKEN for all of
#' the STRICT DBMSs and with all of the different REMOVERS (e.g., All, -E, -(E+R)) across all of the CASESTUDIES
#' @export

visualise_mutation_timetaken_strict_avmdefaults <- function(d, pos) {
  p <- visualise_plot_mutation_time(d, "AVM Defaults", pos)
  name <- "../graphics/from-data/mutation_timetaken_strict_avmdefaults.pdf"
  visualise_save_graphic(name, p, 5, 8)
  return(p)
}

#' FUNCTION: visualise_mutation_timetaken_avmdefaults
#'
#' DESCRIPTION: Plot and save a graph that shows the mutation TIMETAKEN for all of
#' the STRICT DBMSs and with all of the different REMOVERS (e.g., All, -E, -(E+R)) across all of the CASESTUDIES
#' @export

visualise_mutation_timetaken_avmdefaults <- function(d, pos) {
  p <- visualise_plot_mutation_time(d, "AVM Defaults", pos)
  name <- "../graphics/from-data/mutation_timetaken_avmdefaults.pdf"
  visualise_save_graphic(name, p, 5, 8)
  return(p)
}

#' FUNCTION: visualise_mutation_timetaken_strict_random
#'
#' DESCRIPTION: Plot and save a graph that shows the mutation TIMETAKEN for all of
#' the STRICT DBMSs and with all of the different REMOVERS (e.g., All, -E, -(E+R)) across all of the CASESTUDIES,
#' customized for a specific DATA GENERATOR that will be displayed in the plots title.
#' @export

visualise_mutation_timetaken_strict_random <- function(d, pos) {
  p <- visualise_plot_mutation_time(d, "Random", pos)
  name <- "../graphics/from-data/mutation_timetaken_strict_random.pdf"
  visualise_save_graphic(name, p, 5, 8)
  return(p)
}

#' FUNCTION: visualise_mutation_timetaken_random
#'
#' DESCRIPTION: Plot and save a graph that shows the mutation TIMETAKEN for all of
#' the STRICT DBMSs and with all of the different REMOVERS (e.g., All, -E, -(E+R)) across all of the CASESTUDIES,
#' customized for a specific DATA GENERATOR that will be displayed in the plots title.
#' @export

visualise_mutation_timetaken_random <- function(d, pos) {
  p <- visualise_plot_mutation_time(d, "Random", pos)
  name <- "../graphics/from-data/mutation_timetaken_random.pdf"
  visualise_save_graphic(name, p, 5, 8)
  return(p)
}

#' FUNCTION: visualise_mutation_timetaken_strict_avmdefaults_summary
#'
#' DESCRIPTION: Plot and save a graph that shows the mutation TIMETAKEN for all of
#' the STRICT DBMSs and with all of the different REMOVERS (e.g., All, -E, -(E+R)) across all of the CASESTUDIES
#' aggregated.
#' @export

visualise_mutation_timetaken_strict_avmdefaults_summary <- function(d, pos) {
  p <- visualise_plot_mutation_time_summary(d, "AVM Defaults", pos)
  name <- "../graphics/from-data/mutation_timetaken_strict_avmdefaults_summary_boxplot.pdf"
  visualise_save_graphic(name, p, 5, 5)
  return(p)
}

#' FUNCTION: visualise_mutation_timetaken_avmdefaults_summary
#'
#' DESCRIPTION: Plot and save a graph that shows the mutation TIMETAKEN for all of
#' the STRICT DBMSs and with all of the different REMOVERS (e.g., All, -E, -(E+R)) across all of the CASESTUDIES
#' aggregated.
#' @export

visualise_mutation_timetaken_avmdefaults_summary <- function(d, pos) {
  p <- visualise_plot_mutation_time_summary(d, "AVM Defaults", pos)
  name <- "../graphics/from-data/mutation_timetaken_avmdefaults_summary_boxplot.pdf"
  visualise_save_graphic(name, p, 5, 5)
  return(p)
}

#' FUNCTION: visualise_mutation_timetaken_strict_random_summary
#'
#' DESCRIPTION: Plot and save a graph that shows the mutation TIMETAKEN for all of
#' the STRICT DBMSs and with all of the different REMOVERS (e.g., All, -E, -(E+R)) across all of the CASESTUDIES,
#' customized for a specific DATA GENERATOR that will be displayed in the plots title.
#' @export

visualise_mutation_timetaken_strict_random_summary <- function(d, pos) {
  p <- visualise_plot_mutation_time_summary(d, "Random", pos)
  name <- "../graphics/from-data/mutation_timetaken_strict_random_summary_boxplot.pdf"
  visualise_save_graphic(name, p, 5, 5)
  return(p)
}

#' FUNCTION: visualise_mutation_timetaken_random_summary
#'
#' DESCRIPTION: Plot and save a graph that shows the mutation TIMETAKEN for all of
#' the STRICT DBMSs and with all of the different REMOVERS (e.g., All, -E, -(E+R)) across all of the CASESTUDIES,
#' customized for a specific DATA GENERATOR that will be displayed in the plots title.
#' @export

visualise_mutation_timetaken_random_summary <- function(d, pos) {
  p <- visualise_plot_mutation_time_summary(d, "Random", pos)
  name <- "../graphics/from-data/mutation_timetaken_random_summary_boxplot.pdf"
  visualise_save_graphic(name, p, 5, 5)
  return(p)
}

#' FUNCTION: visualise_plot_mutation_time
#'
#' DESCRIPTION: Generally plot a box and whisker plot of the mutation time taken for different
#' configurations; multiple functions will ultimately call this one to produce a different graph
#' In order for these individual schema plots to look good, height needs to be set to 10 in the visualise_graphic_save
#' function.
#' @export

visualise_plot_mutation_time <- function(d, generator, pos = "bottom") {
  if (pos == "top") {
    p <- ggplot2::ggplot(d, ggplot2::aes(x = schema, y = mean_ma_timetaken, fill = timetype)) +
    ggplot2::facet_grid(dbms~.) +
    ggplot2::geom_bar(stat = "identity", position = "dodge") +
    ggplot2::scale_fill_grey(start = 0.8, end = 0.2, labels = c("-(S)    ", "-(S+I)     ", "-(S+I+E)    ", "-(S+I+E+R)    ")) +
    ggplot2::scale_y_log10(labels = scales::comma) +
    ggplot2::theme_bw(base_size = 6) +
    ggplot2::theme(legend.position = "top") +
    ggplot2::theme(legend.key = element_rect(fill = "transparent", colour = "transparent")) +
    ggplot2::guides(fill = guide_legend(title = "Mutant Removal Stage", title.position = "left")) +
    ggplot2::theme(legend.margin = unit("0", "mm")) +
    ggplot2::theme(legend.position = "top") +
    ggplot2::theme(title = ggplot2::element_text(size=6)) +
    ggplot2::theme(axis.title.x = element_blank()) +
    ggplot2::theme(axis.text.x = element_blank()) +
    ggplot2::theme(axis.ticks.x = element_blank()) +
    ggplot2::theme(axis.text.y = ggplot2::element_text(angle = 45, hjust = 1, size=4)) +
    ggplot2::theme(axis.title.y=element_text(margin=margin(0,15.5,0,0))) +
    ggplot2::labs(title = generator) +
    ggplot2::ylab("")
    return(p)
  } else if (pos == "middle") {
    p <- ggplot2::ggplot(d, ggplot2::aes(x = schema, y = mean_ma_timetaken, fill = timetype)) +
    ggplot2::facet_grid(dbms~.) +
    ggplot2::geom_bar(stat = "identity", position = "dodge") +
    ggplot2::scale_y_log10(labels = scales::comma) +
    ggplot2::scale_fill_grey(start = 0.8, end = 0.2) +
    ggplot2::theme_bw(base_size = 6) +
    ggplot2::theme(legend.position = "none") +
    ggplot2::theme(legend.key = element_rect(fill = "transparent", colour = "transparent")) +
    ggplot2::theme(axis.title.x = element_blank()) +
    ggplot2::theme(axis.text.x = element_blank()) +
    ggplot2::theme(axis.ticks.x = element_blank()) +
    ggplot2::theme(axis.text.y = ggplot2::element_text(angle = 45, hjust = 1, size=4)) +
    ggplot2::theme(axis.title.y=element_text(margin=margin(0,10,0,0))) +
    ggplot2::ylab("Mutation Analysis Time (ms)")
    return(p)
  } else {
    p <- ggplot2::ggplot(d, ggplot2::aes(x = schema, y = mean_ma_timetaken, fill = timetype)) +
    ggplot2::facet_grid(dbms~.) +
    ggplot2::geom_bar(stat = "identity", position = "dodge") +
    ggplot2::scale_y_log10(labels = scales::comma) +
    ggplot2::scale_fill_grey(start = 0.8, end = 0.2) +
    ggplot2::theme_bw(base_size = 6) +
    ggplot2::theme(legend.position = "none") +
    ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 45, hjust = 1, size=4)) +
    ggplot2::theme(axis.text.y = ggplot2::element_text(angle = 45, hjust = 1, size=4)) +
    ggplot2::theme(axis.title.y=element_text(margin=margin(0,15.5,0,0))) +
    ggplot2::xlab("Schema") +
    ggplot2::ylab("")
    return(p)
  }
}

#' FUNCTION: visualise_plot_mutation_time_summary
#'
#' DESCRIPTION: Generally plot a box and whisker plot of the mutation time taken for different
#' configurations; multiple functions will ultimately call this one to produce a different graph
#' This function aggregates all times across all schemas and removes outliers. Particularly,
#' this function is usual to show the decrease in mutation analysis time across mutant removal
#' stages.
#' @export

visualise_plot_mutation_time_summary <- function(d, generator, pos = "bottom") {
  if (pos == "top") {
    p <- ggplot2::ggplot(d, ggplot2::aes(x = timetype, y = mean_ma_timetaken)) +
    ggplot2::facet_grid(dbms~.) +
    ggplot2::geom_boxplot(outlier.colour = NA, fill = NA) +
    ggplot2::scale_y_log10(labels = scales::comma) +
    ggplot2::geom_jitter(width = 0.25) +
    ggplot2::theme_bw(base_size = 6) +
    ggplot2::theme(title = ggplot2::element_text(size=6)) +
    ggplot2::theme(axis.title.x = element_blank()) +
    ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 45, hjust = 1, size=4)) +
    ggplot2::theme(axis.text.y = ggplot2::element_text(angle = 45, hjust = 1, size=4)) +
    ggplot2::theme(axis.title.y=element_text(margin=margin(0,10,0,0))) +
    ggplot2::ggtitle(generator) +
    ggplot2::ylab("")
    return(p)
  } else if (pos == "middle") {
    p <- ggplot2::ggplot(d, ggplot2::aes(x = timetype, y = mean_ma_timetaken)) +
    ggplot2::facet_grid(dbms~.) +
    ggplot2::geom_boxplot(outlier.colour = NA, fill = NA) +
    ggplot2::scale_y_log10(labels = scales::comma) +
    ggplot2::geom_jitter(width = 0.25) +
    ggplot2::theme_bw(base_size = 6) +
    ggplot2::theme(axis.title.x = element_blank()) +
    ggplot2::theme(axis.text.x = element_blank()) +
    ggplot2::theme(axis.ticks.x = element_blank()) +
    ggplot2::theme(axis.text.y = ggplot2::element_text(angle = 45, hjust = 1, size=4)) +
    ggplot2::theme(axis.title.y=element_text(margin=margin(0,10,0,0))) +
    ggplot2::ylab("Mutation Analysis Time (ms)")
    return(p)
  } else {
    p <- ggplot2::ggplot(d, ggplot2::aes(x = timetype, y = mean_ma_timetaken)) +
    ggplot2::facet_grid(dbms~.) +
    ggplot2::geom_boxplot(outlier.colour = NA, fill = NA) +
    ggplot2::scale_y_log10(labels = scales::comma) +
    ggplot2::geom_jitter(width = 0.25) +
    ggplot2::theme_bw(base_size = 6) +
    ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 45, hjust = 1, size=4)) +
    ggplot2::theme(axis.text.y = ggplot2::element_text(angle = 45, hjust = 1, size=4)) +
    ggplot2::theme(axis.title.y=element_text(margin=margin(0,5.5,0,0))) +
    ggplot2::xlab("Mutant Removal Stage") +
    ggplot2::ylab("")
    return(p)
  }
}

#' FUNCTION: visualise_mutation_score_strict_avmdefaults
#'
#' DESCRIPTION: Plot and save a graph that shows the mutation SCORE for all of
#' the STRICT DBMSs and with all of the different REMOVERS (e.g., -S, -(S+I+E), -(S+I+E+R)) across all of the CASESTUDIES
#' @export

visualise_mutation_score_strict_avmdefaults <- function(d, pos) {
  p <- visualise_plot_mutation_score(d, "AVM Defaults", pos)
  name <- "../graphics/from-data/mutation_score_strict_avmdefaults.pdf"
  visualise_save_graphic(name, p, 3, 8)
  return(p)
}

#' FUNCTION: visualise_mutation_score_avmdefaults
#'
#' DESCRIPTION: Plot and save a graph that shows the mutation SCORE for all of
#' the STRICT DBMSs and with all of the different REMOVERS (e.g., -S, -(S+I+E), -(S+I+E+R)) across all of the CASESTUDIES
#' @export

visualise_mutation_score_avmdefaults <- function(d, pos) {
  p <- visualise_plot_mutation_score(d, "AVM Defaults", pos)
  name <- "../graphics/from-data/mutation_score_avmdefaults.pdf"
  visualise_save_graphic(name, p, 3, 8)
  return(p)
}

#' FUNCTION: visualise_mutation_score_strict_random
#'
#' DESCRIPTION: Plot and save a graph that shows the mutation SCORE for all of
#' the STRICT DBMSs and with all of the different REMOVERS (e.g., -S, -(S+I+E), -(S+I+E+R)) across all of the CASESTUDIES
#' @export

visualise_mutation_score_strict_random <- function(d, pos) {
  p <- visualise_plot_mutation_score(d, "Random", pos)
  name <- "../graphics/from-data/mutation_score_strict_random.pdf"
  visualise_save_graphic(name, p, 3, 8)
  return(p)
}

#' FUNCTION: visualise_mutation_score_random
#'
#' DESCRIPTION: Plot and save a graph that shows the mutation SCORE for all of
#' the STRICT DBMSs and with all of the different REMOVERS (e.g., -S, -(S+I+E), -(S+I+E+R)) across all of the CASESTUDIES
#' @export

visualise_mutation_score_random <- function(d, pos) {
  p <- visualise_plot_mutation_score(d, "Random", pos)
  name <- "../graphics/from-data/mutation_score_random.pdf"
  visualise_save_graphic(name, p, 3, 8)
  return(p)
}

#' FUNCTION: visualise_mutation_score_strict_avmdefaults_summary
#'
#' DESCRIPTION: Plot and save a graph that shows the mutation SCORE for all of
#' the STRICT DBMSs and with all of the different REMOVERS (e.g., -S, -(S+I+E), -(S+I+E+R)) across all of the CASESTUDIES
#' @export

visualise_mutation_score_strict_avmdefaults_summary <- function(d, pos) {
  p <- visualise_plot_mutation_score_summary(d, "AVM Defaults", pos)
  name <- "../graphics/from-data/mutation_score_strict_avmdefaults_summary_boxplot.pdf"
  visualise_save_graphic(name, p, 3, 5)
  return(p)
}

#' FUNCTION: visualise_mutation_score_avmdefaults_summary
#'
#' DESCRIPTION: Plot and save a graph that shows the mutation SCORE for all of
#' the STRICT DBMSs and with all of the different REMOVERS (e.g., -S, -(S+I+E), -(S+I+E+R)) across all of the CASESTUDIES
#' @export

visualise_mutation_score_avmdefaults_summary <- function(d, pos) {
  p <- visualise_plot_mutation_score_summary(d, "AVM Defaults", pos)
  name <- "../graphics/from-data/mutation_score_avmdefaults_summary_boxplot.pdf"
  visualise_save_graphic(name, p, 3, 5)
  return(p)
}

#' FUNCTION: visualise_mutation_score_strict_random_summary
#'
#' DESCRIPTION: Plot and save a graph that shows the mutation SCORE for all of
#' the STRICT DBMSs and with all of the different REMOVERS (e.g., -S, -(S+I+E), -(S+I+E+R)) across all of the CASESTUDIES
#' @export

visualise_mutation_score_strict_random_summary <- function(d, pos) {
  p <- visualise_plot_mutation_score_summary(d, "Random", pos)
  name <- "../graphics/from-data/mutation_score_strict_random_summary_boxplot.pdf"
  visualise_save_graphic(name, p, 3, 5)
  return(p)
}

#' FUNCTION: visualise_mutation_score_random_summary
#'
#' DESCRIPTION: Plot and save a graph that shows the mutation SCORE for all of
#' the STRICT DBMSs and with all of the different REMOVERS (e.g., -S, -(S+I+E), -(S+I+E+R)) across all of the CASESTUDIES
#' @export

visualise_mutation_score_random_summary <- function(d, pos) {
  p <- visualise_plot_mutation_score_summary(d, "Random", pos)
  name <- "../graphics/from-data/mutation_score_random_summary.pdf"
  visualise_save_graphic(name, p, 3, 5)
  return(p)
}

#' FUNCTION: visualise_plot_mutation_score
#'
#' DESCRIPTION: Generally plot the mutation score for each schema at different stages of mutant removal
#' function.
#' @export

visualise_plot_mutation_score <- function(d, generator, pos = "bottom") {
  if (pos == "top") {
    p <- ggplot2::ggplot(d, ggplot2::aes(x = schema, y = mutation_score, fill = timetype)) +
    ggplot2::facet_grid(dbms~.) +
    ggplot2::geom_bar(stat = "identity", position = "dodge") +
    ggplot2::scale_fill_grey(start = 0.8, end = 0.2, labels = c("-(S)    ", "-(S+I)     ", "-(S+I+E)    ", "-(S+I+E+R)    ")) +
    ggplot2::theme_bw(base_size = 6) +
    ggplot2::theme(legend.position = "top") +
    ggplot2::theme(legend.key = element_rect(fill = "transparent", colour = "transparent")) +
    ggplot2::guides(fill = guide_legend(title = "Mutant Removal Stage", title.position = "left")) +
    # ggplot2::theme(legend.margin = unit("0", "mm")) +
    ggplot2::theme(legend.key = element_rect(size = 5),
                   legend.key.size = unit(1.5, 'lines')) +
    ggplot2::theme(legend.position = "top") +
    ggplot2::theme(title = ggplot2::element_text(size=6)) +
    ggplot2::theme(axis.title.x = element_blank()) +
    ggplot2::theme(axis.text.x = element_blank()) +
    ggplot2::theme(axis.ticks.x = element_blank()) +
    ggplot2::theme(axis.text.y = ggplot2::element_text(angle = 45, hjust = 1, size=4)) +
    ggplot2::labs(title = generator) +
    ggplot2::ylab("")
    return(p)
  } else if (pos == "middle") {
    p <- ggplot2::ggplot(d, ggplot2::aes(x = schema, y = mutation_score, fill = timetype)) +
    ggplot2::facet_grid(dbms~.) +
    ggplot2::geom_bar(stat = "identity", position = "dodge") +
    ggplot2::scale_fill_grey(start = 0.8, end = 0.2) +
    ggplot2::theme_bw(base_size = 6) +
    ggplot2::theme(legend.position = "none") +
    ggplot2::theme(legend.key = element_rect(fill = "transparent", colour = "transparent")) +
    ggplot2::theme(title = ggplot2::element_text(size=6)) +
    ggplot2::theme(axis.title.x = element_blank()) +
    ggplot2::theme(axis.text.x = element_blank()) +
    ggplot2::theme(axis.ticks.x = element_blank()) +
    ggplot2::theme(axis.text.y = ggplot2::element_text(angle = 45, hjust = 1, size=4)) +
    ggplot2::ylab("Mutation Score")
    return(p)
  } else {
    p <- ggplot2::ggplot(d, ggplot2::aes(x = schema, y = mutation_score, fill = timetype)) +
    ggplot2::facet_grid(dbms~.) +
    ggplot2::geom_bar(stat = "identity", position = "dodge") +
    ggplot2::scale_fill_grey(start = 0.8, end = 0.2) +
    ggplot2::theme_bw(base_size = 6) +
    ggplot2::theme(legend.position = "none") +
    ggplot2::theme(title = ggplot2::element_text(size=6)) +
    ggplot2::theme(axis.title.y = element_text("")) +
    ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 45, hjust = 1, size=4)) +
    ggplot2::theme(axis.text.y = ggplot2::element_text(angle = 45, hjust = 1, size=4)) +
    ggplot2::xlab("Schema") +
    ggplot2::ylab("")
    return(p)
  }
}

#' FUNCTION: visualise_plot_mutation_score_summary
#'
#' DESCRIPTION: Generally plot the mutation score for each schema at different stages of mutant removal
#' function.
#' @export

visualise_plot_mutation_score_summary <- function(d, generator, pos = "bottom") {
  if (pos == "top") {
    p <- ggplot2::ggplot(d, ggplot2::aes(x = timetype, y = mutation_score)) +
    ggplot2::facet_grid(dbms~.) +
    ggplot2::geom_boxplot(outlier.colour = NA, fill = NA) +
    ggplot2::geom_jitter(width = 0.25) +
    ggplot2::theme_bw(base_size = 6) +
    ggplot2::theme(title = ggplot2::element_text(size=6)) +
    ggplot2::theme(axis.title.x = element_blank()) +
    ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 45, hjust = 1, size=4)) +
    ggplot2::theme(axis.text.y = ggplot2::element_text(angle = 45, hjust = 1, size=4)) +
    ggplot2::ggtitle(generator) +
    ggplot2::ylab("")
    return(p)
  } else if (pos == "middle") {
    p <- ggplot2::ggplot(d, ggplot2::aes(x = timetype, y = mutation_score)) +
    ggplot2::facet_grid(dbms~.) +
    ggplot2::geom_boxplot(outlier.colour = NA, fill = NA) +
    ggplot2::geom_jitter(width = 0.25) +
    ggplot2::theme_bw(base_size = 6) +
    ggplot2::theme(axis.title.x = element_blank()) +
    ggplot2::theme(axis.text.x = element_blank()) +
    ggplot2::theme(axis.ticks.x = element_blank()) +
    ggplot2::theme(axis.text.y = ggplot2::element_text(angle = 45, hjust = 1, size=4)) +
    ggplot2::ylab("Mutation Score")
    return(p)
  } else {
    p <- ggplot2::ggplot(d, ggplot2::aes(x = timetype, y = mutation_score)) +
    ggplot2::facet_grid(dbms~.) +
    ggplot2::geom_boxplot(outlier.colour = NA, fill = NA) +
    ggplot2::geom_jitter(width = 0.25) +
    ggplot2::theme_bw(base_size = 6) +
    ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 45, hjust = 1, size=4)) +
    ggplot2::theme(axis.text.y = ggplot2::element_text(angle = 45, hjust = 1, size=4)) +
    ggplot2::xlab("Mutant Removal Stage") +
    ggplot2::ylab("")
    return(p)
  }
}

#' FUNCTION: visualise_combined
#'
#' VISUALISE EXECUTION TIME
#'
#' DESCRIPTION: Create a plot that combines all of the two graphics for the timetaken data
#' This function will be used for the "detailed" plots i.e., individual schema plots and the
#' summary plots.
#' @export

visualise_combined <- function(n, top, middle, bottom, h, w) {
  name <- paste("../graphics/from-data/", n, sep = "")
  p <- ggdraw() +
    cowplot::draw_plot(top, 0, 0.61, 1, 0.36) +
    cowplot::draw_plot(middle, 0, 0.35, 1, 0.26) +
    cowplot::draw_plot(bottom, 0, 0, 1, 0.35)
  visualise_save_graphic(name, p, h, w)
  # p <- cowplot::plot_grid(top, middle, bottom, ncol = 1, nrow = 3, align = "v")
  # return(p)
}

#' FUNCTION: visualise_save_graphic
#'
#' Saves the provided graphic to the provided name.
#' @export

visualise_save_graphic <- function(save_name, save_plot, h, w) {
  ggplot2::ggsave(save_name, save_plot, height = h, width = w)
}
