# colnames are id,date,type,category,latitude,longitude
iraq = read.csv(
    file='../cache/iraq_cleaned.csv', 
    stringsAsFactors=FALSE
)
# reject any events with locations outside the bounding box
xrange=c(38.79684,48.56856)
yrange=c(28.98695,37.37804)
iraq <- iraq[(iraq$longitude>xrange[1]) & (iraq$longitude<xrange[2]),]
iraq <- iraq[(iraq$latitude>yrange[1]) & (iraq$latitude<yrange[2]),]
# let's turn the type into a factor (there are 10)
iraq$type           <- factor(iraq$type)
# let's turn the type into a factor (there are 10)
iraq$category       <- factor(iraq$category)
# turn the date string into R Dates
iraq$date           <- as.Date(iraq$date)
# turn killed/wounded numbers into ints
iraq$friendlykia    <- as.integer(iraq$friendlykia)
iraq$hostnationwia  <- as.integer(iraq$hostnationwia)
iraq$hostnationkia  <- as.integer(iraq$hostnationkia)
iraq$civilianwia    <- as.integer(iraq$civilianwia)
iraq$civiliankia    <- as.integer(iraq$civiliankia)
iraq$enemywia       <- as.integer(iraq$enemywia)
iraq$enemykia       <- as.integer(iraq$enemykia)
iraq$enemydetained  <- as.integer(iraq$enemydetained)
# save the cleaned up file in the cache
save(iraq,file='../cache/iraq_cleaned.data')