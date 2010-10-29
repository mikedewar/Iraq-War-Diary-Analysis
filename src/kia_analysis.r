library(ggplot2)
load('../cache/iraq_cleaned.data') # iraq

# let's find the number of enemy KIA each month
months = seq(min(iraq$date), max(iraq$date), by="1 month")
e.kia = rep(0,length(months))
f.kia = rep(0,length(months))
c.kia = rep(0,length(months))
h.kia = rep(0,length(months))
i = 1
for (month in months){
    iraq.month <- iraq[iraq$date>=month & iraq$date<month+31, ]
    e.kia[i] = sum(iraq.month$enemykia)
    f.kia[i] = sum(iraq.month$friendlykia)
    c.kia[i] = sum(iraq.month$civiliankia)
    h.kia[i] = sum(iraq.month$hostnationkia)
    i = i + 1
}

kia = data.frame(
    date = months,
    enemy = e.kia,
    friendly = f.kia,
    civilian = c.kia,
    hostnation = h.kia
    #ratio.ef = e.kia/f.kia,
    #ratio.cf = c.kia/(e.kia+f.kia)
)


p <- ggplot(kia, aes(x=date))
p <- p + geom_line(aes(y=enemy, color=as.factor(0)))
p <- p + geom_line(aes(y=friendly, color=as.factor(1)))
p <- p + geom_line(aes(y=civilian, color=as.factor(2)))
p <- p + geom_line(aes(y=hostnation, color=as.factor(3)))
p <- p + scale_color_discrete(
    legend=T,
    name="killed in action",
    breaks=as.factor(c(0,1,2,3)), 
    labels=c('enemy','friendly', 'civilian', 'host nation')
)
p <- p + ylab('count')
p <- p + theme_bw()
p <- p + opts(panel.grid.minor = theme_blank())
ggsave(p, file="../graphs/deaths.png", width=7, height=3)

print('total number of deaths reported by the joint forces:')
print(sum(iraq$enemykia)+sum(iraq$friendlykia)+sum(iraq$civiliankia)+sum(iraq$hostnationkia))

print('total number of civilian deaths reported by the joint forces:')
print(sum(iraq$civiliankia))

print('total number of enemy deaths reported by the joint forces:')
print(sum(iraq$enemykia))

print('total number of friendly deaths reported by the joint forces:')
print(sum(iraq$friendlykia))

print('total number of host nation deaths reported by the joint forces:')
print(sum(iraq$hostnationkia))