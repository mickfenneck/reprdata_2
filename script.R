library(ggplot2)
library(grid)

data <- read.csv(bzfile("repdata-data-StormData.csv.bz2"))
str(data)

inj_event <- aggregate(INJURIES ~ EVTYPE, data=data, FUN=sum)
death_event <- aggregate(FATALITIES ~ EVTYPE, data=data, FUN=sum)

head(inj_event)
head(death_event)
max(inj_event$INJURIES)
max(death_event$FATALITIES)

inj_event_sorted <- inj_event[order(inj_event$INJURIES,decreasing=TRUE),]
death_event_sorted <- death_event[order(death_event$FATALITIES,decreasing=TRUE),]

most_inj <- inj_event_sorted[1:5,]
most_death <- death_event_sorted[1:5,]

most_death$EVTYPE <- as.character(most_death$EVTYPE)
most_death$EVTYPE <- as.factor(most_death$EVTYPE)
most_death$FATALITIES <- as.numeric(most_death$FATALITIES)

plot1 <- ggplot(most_death, aes(factor(EVTYPE), factor(FATALITIES))) + geom_bar() + xlab("Event Type") + ylab("Fatalities") + ggtitle("Most death")

most_inj$EVTYPE <- as.character(most_inj$EVTYPE)
most_inj$EVTYPE <- as.factor(most_inj$EVTYPE)
most_inj$INJURIES <- as.numeric(most_inj$INJURIES)

plot2 <- ggplot(most_inj, aes(factor(EVTYPE), factor(INJURIES))) + geom_bar() + xlab("Event Type") + ylab("Injuries") + ggtitle("Most injuries")

grid.newpage()
vplayout <- function(x, y) viewport(layout.pos.row = x, layout.pos.col = y)
pushViewport(viewport(layout = grid.layout(2, 1)))
print(plot1, vp = vplayout(1, 1))
print(plot2, vp = vplayout(2, 1))

#seleziono solo quelli con la b e poi raggruppo
datasub <- data[data$PROPDMGEXP=="B",c("EVTYPE","PROPDMG","PROPDMGEXP")]
damage_sorted <- datasub[order(datasub$PROPDMG,decreasing=TRUE),]

#aggrego e ordino
damage_aggr <- aggregate(PROPDMG ~ EVTYPE, data=damage_sorted,FUN=sum)
damage_aggr_ord <- damage_aggr[order(damage_aggr$PROPDMG,decreasing=TRUE),]
damage_aggr_ord <- damage_aggr_ord[1:5,]

ggplot(damage_aggr_ord, aes(factor(EVTYPE), factor(PROPDMG))) + geom_bar() + xlab("Event Type") + ylab("Dollars") + ggtitle("Damage")