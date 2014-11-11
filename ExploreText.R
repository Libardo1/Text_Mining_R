setwd("C:/Users/Chuan/My Study/CourseRA/JHUa - Capstone Project/4 My Tasks/Task 0/R code")

file <- "../final/en_US/en_US.twitter.txt"
data.raw <- readLines(file)
length(data.raw)
# [1] 2360148

library(tm)
dir <- "../final/en_US"
ds  <- DirSource(directory=dir, encoding="UTF-8", mode="text")
data.raw <- VCorpus(ds, readerControl=list(language="lat"))
print(data.raw)
# <<VCorpus (documents: 3, metadata (corpus/indexed): 0/0)>>
summary(data.raw)
#                   Length Class             Mode
# en_US.blogs.txt   2      PlainTextDocument list
# en_US.news.txt    2      PlainTextDocument list
# en_US.twitter.txt 2      PlainTextDocument list
data.blog <- content(data.raw[[1]])
data.news <- content(data.raw[[2]])
data.twit <- content(data.raw[[3]])
row_wid.blog <- nchar(data.blog)
row_wid.news <- nchar(data.news)
row_wid.twit <- nchar(data.twit)
max(row_wid.blog)
# [1] 40833
max(row_wid.news)
# [1] 5760
max(row_wid.twit)
# [1] 140

num_love <- sum(grepl(pattern=" *love *", data.twit))
# [1] 90956
num_hate <- sum(grepl(pattern=" *hate *", data.twit))
# [1] 22138
num_love / num_hate
# [1] 4.108592
idx1 <- grep(pattern="biostats", data.twit)
# [1] 556872
data.twit[idx1]
# [1] "i know how you feel.. i have biostats on tuesday and i have yet to study =/"
sum(grepl(pattern="A computer once beat me at chess, but it was no match for me at kickboxing", data.twit))
# [1] 3
idx2 <- grep(pattern="A computer once beat me at chess, but it was no match for me at kickboxing", data.twit)
# [1]  519059  835824 2283423

