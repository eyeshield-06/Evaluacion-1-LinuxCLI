#!/usr/bin/env Rscript

df <- janitor::clean_names(readr::read_delim("dir/mcdonalds_menu.csv", delim = ",", col_names = TRUE))

write(colnames(df)[sapply(df, is.numeric)], stdout())
