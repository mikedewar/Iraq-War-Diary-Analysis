library(ggplot2)
library(maptools)
library(spatstat)

load('../cache/iraq_cleaned.data') # iraq

# initialise the data frame
events_per_month = data.frame(
    date = seq(as.Date("2004-01-01"), len=12*6, by="1 month"),
    count = rep(0,12*6),
    stringsAsFactors=FALSE
)
# just look at IED explosions
iraq.IED_explosions = iraq[iraq$category=="ied explosion",]

print("number of IED explosions:")
print(nrow(iraq.IED_explosions))

print("number of IED explosions with one enemy kia:")
print(nrow(iraq.IED_explosions[iraq.IED_explosions$enemykia==1,]))

count = table(format.Date(iraq.IED_explosions$date,"%Y %m"))

print("month with most IED explosions:")
print(names(which(count==max(count))))

may_indices = (iraq.IED_explosions$date >= "2007-05-01") & (iraq.IED_explosions$date < "2007-06-01")
print("number of IED explosions during this month:")
print(sum(may_indices))

civkia = sum(iraq.IED_explosions[may_indices,]$civiliankia)
enkia = sum(iraq.IED_explosions[may_indices,]$enemykia)
frkia = sum(iraq.IED_explosions[may_indices,]$friendlykia)

print("civilian KIA")
print(civkia)

print("enemy KIA")
print(enkia)

print("friendly KIA")
print(frkia)

print("civilian / combatant ratio")
print(civkia / (enkia+frkia))


first_day_of_may_indices = (iraq.IED_explosions$date == "2007-05-01")
print("number of explosions on May 1st 2007")
print(sum(first_day_of_may_indices))
print("number of deaths on May 1st 2007")
civkia = sum(iraq.IED_explosions[first_day_of_may_indices,]$civiliankia)
enkia = sum(iraq.IED_explosions[first_day_of_may_indices,]$enemykia)
frkia = sum(iraq.IED_explosions[first_day_of_may_indices,]$friendlykia)
print(civkia+enkia+frkia)

iraq.IED_explosions[which(first_day_of_may_indices==T)[1],]

p <- ggplot(iraq.IED_explosions,aes(x=date))
p <- p + geom_histogram()
p <- p + scale_x_date(limits=c(as.Date("2004-01-01"),as.Date("2010-01-01")))
p <- p + theme_bw()
ggsave(file="../graphs/IED_explosions.png",width=7,height=3)


iraq.shp <- readShapePoly("../data/iraq.shp")
iraq.poly <- fortify.SpatialPolygons(iraq.shp)

p = ggplot(iraq.IED_explosions)
p = p + geom_path(
    data=iraq.poly,  
    aes(y=lat,x=long,group=group), 
    size=0.5,
    fill="black",
    alpha=0.2
)
p=p + geom_point(
    size=1,
    alpha=0.4,
    color="blue",
    aes(
        y=latitude,
        x=longitude,
    )
)
p <- p + theme_bw()
p <- p + opts(panel.grid.major = theme_blank())
p <- p + opts(panel.grid.minor = theme_blank())
p <- p + opts(panel.background = theme_blank())
p <- p + opts(axis.title.x = theme_blank())
p <- p + opts(axis.title.y = theme_blank())
p <- p + opts(axis.ticks = theme_blank())
p <- p + opts(panel.border = theme_blank())
p <- p + opts(axis.text.x = theme_blank())
p <- p + opts(axis.text.y = theme_blank())
ggsave(p,file="../graphs/IED_explosions_spatial.png",width=5,height=5)

