library(ggplot2)
library(maptools)
library(spatstat)

load('../cache/iraq_cleaned.data') # iraq

# you need to run contractor_analysis.py first!
contractors <- read.csv("../cache/iraq_contractors.csv",stringsAsFactors=FALSE)

print("number of events involving the contractor keywords:")
print(nrow(contractors))

contractors$date <- as.Date(contractors$date)
p <- ggplot(contractors, aes(x=date))
p <- p + geom_density(aes(fill=as.factor(0)))
p <- p + geom_density(data=iraq, aes(x=date, fill=as.factor(1),alpha=0.5))
p <- p + scale_fill_discrete(
    legend=T,
    name="distribution of events",
    breaks=as.factor(c(0,1)), 
    labels=c('involving contractors','all')
)
p <- p + scale_alpha(legend=F)
p <- p + scale_x_date(limits=c(as.Date("2004-01-01"),as.Date("2010-01-01")))
p <- p + opts(panel.grid.major = theme_blank())
p <- p + opts(panel.grid.minor = theme_blank())
p <- p + opts(panel.background = theme_blank())
p <- p + opts(axis.title.x = theme_blank())
p <- p + opts(axis.title.y = theme_blank())
p <- p + opts(axis.ticks = theme_blank())
p <- p + opts(panel.border = theme_blank())
#p <- p + opts(axis.text.x = theme_blank())
p <- p + opts(axis.text.y = theme_blank())

ggsave(p,file="../graphs/contractors.png",width=7,height=3)



iraq.shp <- readShapePoly("../data/iraq.shp")
iraq.poly <- fortify.SpatialPolygons(iraq.shp)

p = ggplot(contractors)
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
ggsave(p,file="../graphs/contractors_spatial.png",width=5,height=5)
