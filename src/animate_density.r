library(ggplot2)
library(maptools)
library(spatstat)

source('plot_density.r')

load('../cache/iraq_cleaned.data') # iraq

# read the shape files
iraq.shp <- readShapePoly("../data/iraq.shp")
iraq.places <- as.data.frame(readShapePoints("../data/places.shp"))
colnames(iraq.places) <- c("osm_id", "name", "type", "population", "x", "y")

# Let's just look at IED explosions
iraq <- iraq[iraq$category=="ied explosion", ]
frame_no = 1

for (day in seq(min(iraq$date), max(iraq$date), by="1 day")){
    iraq.today <- iraq[iraq$date>(day-30) & iraq$date==day, ]
    print(nrow(iraq.today))
    p <- plot.density(iraq.today, iraq.shp, iraq.places, cmax=10)
    p <- p + geom_point(
        data=iraq[iraq$date==day, ], 
        aes(x=longitude,y=latitude)
    )
    ggsave(p,file=paste("../graphs/frames/iraq_", frame_no, ".png", sep=""))
    frame_no = frame_no + 1
}

#use this to build the movie
#ffmpeg -f image2 -r 10 -i ../graphs/frames/iraq_%d.png -b 600k iraq.mp4
