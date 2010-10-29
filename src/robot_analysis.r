# ya gots ta run the robot_analysis.py file before this one
library(ggplot2)

robots <- read.csv("../cache/iraq_robots.csv",stringsAsFactors=FALSE)

robots$date <- as.Date(robots$date)
p <- ggplot(robots, aes(x=date))
p <- p + geom_density(aes(fill=as.factor(0)))
p <- p + geom_density(data=iraq, aes(x=date, fill=as.factor(1),alpha=0.5))
p <- p + scale_fill_discrete(
    legend=T,
    name="distribution of events",
    breaks=as.factor(c(0,1)), 
    labels=c('involving drones','all')
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

ggsave(p,file="../graphs/robots.png",width=7,height=3)


print("number of enemy deaths in events associated with robots:")
print(sum(robots$enemykia))

print("number of friendly deaths in events associated with robots:")
print(sum(robots$friendly))

print("number of civilian deaths in events associated with robots:")
print(sum(robots$civiliankia))