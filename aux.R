#!/usr/bin/env Rscript

library(dplyr)
db <- read.csv("./dir/mcdonalds_menu.csv")
aux <- read.csv("./aux.csv", head = FALSE, sep = ":") %>%
  mutate(V1 = V1 - 1)

for(i in aux$V1) {
  db$Calper100g[i] <- db$Calories[i] / aux$V2[aux$V1 == i] * 100
}

db$Calper100g[-aux$V1] <- NA

write.csv(x = db, file = "./mcdonalds_menu_2.csv")
