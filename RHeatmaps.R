#########################################################
### A) Installing and loading required packages
#########################################################

if (!require("gplots")) {
  install.packages("gplots", dependencies = TRUE)
  library(gplots)
}
if (!require("RColorBrewer")) {
  install.packages("RColorBrewer", dependencies = TRUE)
  library(RColorBrewer)
}

#########################################################
### B) Reading in data and transform it into matrix format
#########################################################

data <-read.csv2("DataforHeatmapIII.csv")
rnames <- data[,1]                            # assign labels in column 1 to "rnames"
mat_data <- data.matrix(data[,2:17])  # transform column 2-1ncol(data) into a matrix
rownames(mat_data) <- rnames                  # assign row names
data



#########################################################
### C) Customizing and plotting the heat map
#########################################################


# creates a own color palette from red to green
my_palette <- colorRampPalette(c("green", "black", "red"))(n = 250)

# (optional) defines the color breaks manually for a "skewed" color transition
# col_breaks = c(seq(-1,0,length=100),  # for red
#             seq(0.01,0.7,length=100),           # for yellow
#             seq(0.71,1,length=100))             # for green



heatmap.2(mat_data,
          scale= "row",
          labRow = "",
          main = "All genes", # heat map title
          density.info="none",  # turns off density plot inside color legend
          trace="none",         # turns off trace lines inside the heat map
          margins =c(12,9),     # widens margins around plot
          col=my_palette,       # use on color palette defined earlier
          # breaks=col_breaks,    # enable color transition at specified limits
          #dendrogram="column",     # only draw a row dendrogram
          #Rowv= "NA",             # turn off row clustering
          #Colv="NA",            # turn off column clustering/ put TRUE to 
          
)

