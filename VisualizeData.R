setwd("C:/Users/Chuan/My Study/CourseRA/JHUa - Capstone Project/4 My Tasks/Task 0/R code")

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

data.twit <- data.twit[sample((1:length(data.twit)), size=10000)]
data.twit <- gsub(pattern="[^a-zA-Z ,.!?\'\"]", 
                  replacement="", 
                  data.twit) # remove non-english words

twits.vcorp <- VectorSource(data.twit)
twits.vcorp <- VCorpus(twits.vcorp)
twits.vcorp <- tm_map(twits.vcorp, removePunctuation)
twits.vcorp <- tm_map(twits.vcorp, content_transformer(tolower))
twits.vcorp <- tm_map(twits.vcorp, removeWords, stopwords("english"))
# twits.vcorp <- tm_map(twits.vcorp, removeWords, c("also", "but", "just",
#                                                   "however", "just"))
twits.vcorp <- tm_map(twits.vcorp, stripWhitespace)
library(SnowballC)
twits.vcorp <- tm_map(twits.vcorp, stemDocument)
twits.vcorp <- tm_map(twits.vcorp, removeNumbers)
library(lava)
twits.vcorp <- tm_map(twits.vcorp, content_transformer(trim))
twits.tdm <- TermDocumentMatrix(twits.vcorp)
twits.dtm <- DocumentTermMatrix(twits.vcorp)
library(Rgraphviz)
terms=findFreqTerms(twits.dtm, lowfreq=100)
plot(twits.dtm, terms[1:50], corThreshold=0.1)
freq <- sort(colSums(as.matrix(twits.dtm)), decreasing=TRUE)

library(wordcloud)
twits.matrix <- as.matrix(twits.tdm)
twits.vector <- sort(rowSums(twits.matrix),decreasing=TRUE)
twits.dframe <- data.frame(word = names(twits.vector),freq=twits.vector)
table(twits.dframe$freq)
pal2 <- brewer.pal(8,"Dark2")
png("./TwitsCloud.png", width=1280,height=800)
wordcloud(twits.dframe$word, twits.dframe$freq, scale=c(8,.2),
          min.freq=10, max.words=Inf, random.order=FALSE, 
          rot.per=.15, colors=pal2)
dev.off()
