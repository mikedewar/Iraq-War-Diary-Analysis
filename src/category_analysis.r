load('../cache/iraq_cleaned.data')

cat_table = table(iraq$category)

print("number of categories:")
print(length(cat_table))

print("most popular category:")
print(cat_table[cat_table==max(cat_table)])

print("second most popular category")
# element 42 is "IED explosion"
print(cat_table[cat_table==max(cat_table[-42])])

print("category with highest spatial spread")
spread <- function(cat){
    sum(c(
        abs(diff(range(iraq[iraq$category==cat,]$latitude))),
        abs(diff(range(iraq[iraq$category==cat,]$longitude)))
    ))
}
cats.df <- data.frame(cat_table,stringsAsFactors=FALSE)
colnames(cats.df)<-c('category','frequency')
cats.df$spread = sapply(names(cat_table),spread)
cat.spread = cats.df[cats.df$spread==max(cats.df$spread),]$category
print(cat.spread)
print("latitude/longitude spread:")
total_lat_spread = diff(range(iraq$latitude))
total_lon_spread = diff(range(iraq$latitude))
print(range(iraq[iraq$category==cat.spread,]$latitude))
print(range(iraq[iraq$category==cat.spread,]$longitude))
print("latitude/longitude spread as percentage of total:")
total_lat_spread = diff(range(iraq$latitude))
total_lon_spread = diff(range(iraq$longitude))
print(diff(range(iraq[iraq$category==cat.spread,]$latitude))/total_lat_spread)
print(diff(range(iraq[iraq$category==cat.spread,]$longitude))/total_lon_spread)
