# ya gots ta run the robot_analysis.py and contractor_analysis.py files before this one
library(ggplot2)
library(maptools)
library(spatstat)

load('../cache/iraq_cleaned.data') # iraq
robots <- read.csv("../cache/iraq_robots.csv",stringsAsFactors=FALSE)
contractors <- read.csv("../cache/iraq_contractors.csv",stringsAsFactors=FALSE)


contractors$date <- as.Date(contractors$date)
robots$date <- as.Date(robots$date)
p <- ggplot(iraq, aes(x=date))
p <- p + geom_density(aes(fill=as.factor(0)))
p <- p + geom_density(data=robots, aes(x=date, fill=as.factor(1),alpha=0.5))
p <- p + geom_density(data=contractors, aes(x=date, fill=as.factor(2),alpha=0.5))
p <- p + scale_fill_discrete(
    legend=T,
    name="distribution of events",
    breaks=as.factor(c(0,1,2)), 
    labels=c('all','involving drones','involving contractors')
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

ggsave(p,file="../graphs/robots_contractors.png",width=7,height=3)
