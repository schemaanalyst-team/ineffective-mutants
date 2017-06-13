a.test <- function(sample1, sample2) {

  #transformed_sample1 <- round(sample1/100)
  #transformed_sample2 <- round(sample2/100)

  transformed_sample1 <- sample1
  transformed_sample2 <- sample2

  all <- c(transformed_sample1, transformed_sample2)

  ranks <- rank(all, ties.method="average")
  rank.sum <- sum(ranks[1:length(transformed_sample1)])

  m <- length(transformed_sample1)
  n <- length(transformed_sample2)
  a <- ((rank.sum / m - (m + 1.0) / 2.0) / n)

  size <- "none"
  if (a < 0.44 || a > 0.56) {
      size <- "small"
  }
  if (a < 0.36 || a > 0.64) {
      size <- "medium"
  }
  if (a < 0.29 || a > 0.71) {
      size <- "large"
  }

  return (list(value = a,
               size = size,
               rank.sum = rank.sum))
}