plot.density <- function(iraq,iraq.shp,iraq.places,cmin=0,cmax=10){
    #
    iraq.poly <- fortify.SpatialPolygons(iraq.shp)
    # TODO make a polygon window (rather than the current square one!)
    #win = as(iraq.shp, "owin")
    win = owin(xrange=c(38.79684,48.56856), yrange=c(28.98695,37.37804))
    # form a points object
    iraq.points = as.ppp(ppp(
        iraq$longitude,
        iraq$latitude,
        window=win
    ))
    # find its density
    d = density(iraq.points,0.2)
    # convert to a matrix and transpose
    img = t(as.matrix(d))
    # flatten for ggplot
    df = expand.grid(x=d$xcol, y=d$yrow)
    # pull out the image values
    df$z = melt(img)$value
    # threshold
    cmin = 0
    cmax = 1000
    df$z[df$z > cmax] = cmax
    df$z[df$z < cmin] = cmin
    # build up the plot
    p = ggplot(df,aes(x=x,y=y))
    # this is the density
    p = p + geom_tile(aes(fill=z))
    p = p + scale_fill_gradient(
        "Intensity",
        low="white",
        high="red",
        limits=c(cmin, cmax),
        legend=FALSE # the legend is a bit hard to interpret
    )
    # this is the admin boundaries
    p = p + geom_path(
        data=iraq.poly,  
        aes(y=lat,x=long,group=group), 
        size=0.5,
        fill="black",
        alpha=0.4
    )
    # this is the palce names and labels
    for (i in seq(nrow(iraq.places))){
        if (iraq.places[i,]$type=="city"){
            p = p + geom_text(
                data = iraq.places[i,], 
                aes(x=x, y=y, label=name),
                size=6,
                legend=FALSE
            ) + scale_size(legend=FALSE)
            p = p + geom_point(data = iraq.places[i,], aes(x=x, y=y), legend=FALSE)
        }
    }
    return(p)
}