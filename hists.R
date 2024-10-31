file_str <- readLines("./categories.txt")

file_str <- colnames(iris)[-5]

for(i in file_str) {
  hist(get(i, iris))
  Sys.sleep(1)
}
