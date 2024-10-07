current_working_dir <- dirname(rstudioapi::getActiveDocumentContext()$path)
setwd(current_working_dir)

source("../data pipeline/meta_data.R")

## reading habits subset

MD_Reading = MD[c("READ1.BOOKS", "READ1.MAGA", "READ1.GAMES", "READ1.SMEDIA", "READ1.APPS", "READ1.WEB")]

## change data type to character

MD_Reading$READ1.BOOKS = as.character(MD_Reading$READ1.BOOKS)
MD_Reading$READ1.MAGA = as.character(MD_Reading$READ1.MAGA)
MD_Reading$READ1.GAMES = as.character(MD_Reading$READ1.GAMES)
MD_Reading$READ1.SMEDIA = as.character(MD_Reading$READ1.SMEDIA)
MD_Reading$READ1.APPS = as.character(MD_Reading$READ1.APPS)
MD_Reading$READ1.WEB = as.character(MD_Reading$READ1.WEB)

## calculate values for reading habit matrix

Books_1 <- sum(MD_Reading$READ1.BOOKS == 1, na.rm=TRUE)
Books_2 <- sum(MD_Reading$READ1.BOOKS == 2, na.rm=TRUE)
Books_3 <- sum(MD_Reading$READ1.BOOKS == 3, na.rm=TRUE)
Books_4 <- sum(MD_Reading$READ1.BOOKS == 4, na.rm=TRUE)
Books_5 <- sum(MD_Reading$READ1.BOOKS == 5, na.rm=TRUE)
Books_6 <- sum(MD_Reading$READ1.BOOKS == 6, na.rm=TRUE)

Maga_1 <- sum(MD_Reading$READ1.MAGA == 1, na.rm=TRUE)
Maga_2 <- sum(MD_Reading$READ1.MAGA == 2, na.rm=TRUE)
Maga_3 <- sum(MD_Reading$READ1.MAGA == 3, na.rm=TRUE)
Maga_4 <- sum(MD_Reading$READ1.MAGA == 4, na.rm=TRUE)
Maga_5 <- sum(MD_Reading$READ1.MAGA == 5, na.rm=TRUE)
Maga_6 <- sum(MD_Reading$READ1.MAGA == 6, na.rm=TRUE)

Games_1 <- sum(MD_Reading$READ1.GAMES == 1, na.rm=TRUE)
Games_2 <- sum(MD_Reading$READ1.GAMES == 2, na.rm=TRUE)
Games_3 <- sum(MD_Reading$READ1.GAMES == 3, na.rm=TRUE)
Games_4 <- sum(MD_Reading$READ1.GAMES == 4, na.rm=TRUE)
Games_5 <- sum(MD_Reading$READ1.GAMES == 5, na.rm=TRUE)
Games_6 <- sum(MD_Reading$READ1.GAMES == 6, na.rm=TRUE)

Smedia_1 <- sum(MD_Reading$READ1.SMEDIA == 1, na.rm=TRUE)
Smedia_2 <- sum(MD_Reading$READ1.SMEDIA == 2, na.rm=TRUE)
Smedia_3 <- sum(MD_Reading$READ1.SMEDIA == 3, na.rm=TRUE)
Smedia_4 <- sum(MD_Reading$READ1.SMEDIA == 4, na.rm=TRUE)
Smedia_5 <- sum(MD_Reading$READ1.SMEDIA == 5, na.rm=TRUE)
Smedia_6 <- sum(MD_Reading$READ1.SMEDIA == 6, na.rm=TRUE)

Apps_1 <- sum(MD_Reading$READ1.APPS == 1, na.rm=TRUE)
Apps_2 <- sum(MD_Reading$READ1.APPS == 2, na.rm=TRUE)
Apps_3 <- sum(MD_Reading$READ1.APPS == 3, na.rm=TRUE)
Apps_4 <- sum(MD_Reading$READ1.APPS == 4, na.rm=TRUE)
Apps_5 <- sum(MD_Reading$READ1.APPS == 5, na.rm=TRUE)
Apps_6 <- sum(MD_Reading$READ1.APPS == 6, na.rm=TRUE)

Web_1 <- sum(MD_Reading$READ1.WEB == 1, na.rm=TRUE)
Web_2 <- sum(MD_Reading$READ1.WEB == 2, na.rm=TRUE)
Web_3 <- sum(MD_Reading$READ1.WEB == 3, na.rm=TRUE)
Web_4 <- sum(MD_Reading$READ1.WEB == 4, na.rm=TRUE)
Web_5 <- sum(MD_Reading$READ1.WEB == 5, na.rm=TRUE)
Web_6 <- sum(MD_Reading$READ1.WEB == 6, na.rm=TRUE)


## Create data frame from data

var = c("Books_1", "Books_2", "Books_3", "Books_4", "Books_5", "Books_6", "Maga_1", "Maga_2", "Maga_3", "Maga_4", "Maga_5", "Maga_6", "Games_1", "Games_2", "Games_3", "Games_4", "Games_5", "Games_6", "Smedia_1", "Smedia_2", "Smedia_3", "Smedia_4", "Smedia_5", "Smedia_6", "Apps_1", "Apps_2", "Apps_3", "Apps_4", "Apps_5", "Apps_6", "Web_1", "Web_2", "Web_3", "Web_4", "Web_5", "Web_6")

value <- c(Books_1, Books_2, Books_3, Books_4, Books_5, Books_6, Maga_1, Maga_2, Maga_3, Maga_4, Maga_5, Maga_6, Games_1, Games_2, Games_3, Games_4, Games_5, Games_6, Smedia_1, Smedia_2, Smedia_3, Smedia_4, Smedia_5, Smedia_6, Apps_1, Apps_2, Apps_3, Apps_4, Apps_5, Apps_6, Web_1, Web_2, Web_3, Web_4, Web_5, Web_6)

label <- rep(c("Books", "Magazines", "Games", "SocialMedia", "Apps", "Web"), each = 6)

ReadingData <- data.frame(var, value, label)


## Create barplot

cat <- rep(c("1: no time","2: less than one hour","3: 1-4 hours","4: 4-7 hours","5: 7-10 hours","6: more than 10 hours"), times = 6)

Readplot <- ggplot(
  ReadingData, aes(x = var,
                   y = value,
                   fill = cat)) +
  facet_grid(~ label, switch = "x", scales = "free", space = "free") +
  scale_fill_manual(values = c("#612158","#a11035", "#cc071e", "#f6a800", "#bdcd00", "#57ab27")) +
  theme_minimal() +
  geom_col() +
  geom_text(aes(label = round(value / 575, 2)), angle = 90, hjust = 'left') +
            # hjust = 'right') +
  ylab("# of participants") + # y-axis label
  xlab("Media type") + # x-axis label
  labs(fill = "Time spent reading",
       title = "Reading Habits") + # legend label
  theme(axis.text.x = element_blank(), # within the theme() element, you can define all sorts of different things.
        # panel.grid = element_blank(),
        legend.position = "right") # we want our legend to be at the top

Readplot



### Reading habits grouped

## Group reading times

Books_less <- sum(MD_Reading$READ1.BOOKS <= 2, na.rm=TRUE)
Books_more <- sum(MD_Reading$READ1.BOOKS >= 5, na.rm=TRUE)

Maga_less <- sum(MD_Reading$READ1.MAGA <= 2, na.rm=TRUE)
Maga_more <- sum(MD_Reading$READ1.MAGA >= 5, na.rm=TRUE)

Games_less <- sum(MD_Reading$READ1.GAMES <= 2, na.rm=TRUE)
Games_more <- sum(MD_Reading$READ1.GAMES >= 5, na.rm=TRUE)

Smedia_less <- sum(MD_Reading$READ1.SMEDIA <= 2, na.rm=TRUE)
Smedia_more <- sum(MD_Reading$READ1.SMEDIA >= 5, na.rm=TRUE)

Apps_less <- sum(MD_Reading$READ1.APPS <= 2, na.rm=TRUE)
Apps_more <- sum(MD_Reading$READ1.APPS >= 5, na.rm=TRUE)

Web_less <- sum(MD_Reading$READ1.WEB <= 2, na.rm=TRUE)
Web_more <- sum(MD_Reading$READ1.WEB >= 5, na.rm=TRUE)

## create data frame with calculated values of meta-data for less and more plot

var2 = c("Books_less", "Books_more", "Maga_less", "Maga_more", "Games_less", "Games_more", "Smedia_less", "Smedia_more", "Apps_less", "Apps_more", "Web_less", "Web_more")

value2 <- c(Books_less, Books_more, Maga_less, Maga_more, Games_less, Games_more, Smedia_less, Smedia_more, Apps_less, Apps_more, Web_less, Web_more)

label2 <- rep(c("Books", "Magazines", "Games", "SocialMedia", "Apps", "Web"), each = 2)

ReadingData2 <- data.frame(var2, value2, label2)

ReadingHabitsDataMoreLess <- matrix(c(Books_less, Books_more, Maga_less, Maga_more, Games_less, Games_more, Smedia_less, Smedia_more, Apps_less, Apps_more, Web_less, Web_more), ncol = 6, byrow=FALSE)


## Create small table for category names (used in argument legend.text = rownames)

cat2 <- rep(c("1 hour or less","7 hours or more"), times = 6)

## Create barplot

Readplot2 <- ggplot(
  ReadingData2, aes(x = var2,
                    y = value2,
                    fill = cat2)) +
  facet_grid(~ label2, switch = "x", scales = "free", space = "free") +
  scale_fill_manual(values = c("#cc071e", "#57ab27")) +
  theme_minimal() +
  ggtitle("Reading Habits") +
  geom_col() +
  ylab("# of participants") + # y-axis label
  xlab("Media type") + # x-axis label
  labs(fill = "Time spent reading") + # legend label
  theme(axis.text.x = element_blank(), # within the theme() element, you can define all sorts of different things.
        # panel.grid = element_blank(),
        legend.position = "right", # we want our legend to be at the top,
        plot.title = element_text(hjust = 0.5))


Readplot2
