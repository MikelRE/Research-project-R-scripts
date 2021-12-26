library (ggplot2)
library(ggrepel)#For organizing the labels of gene names


#I open the csv file containing the data 
EM <- read.csv2("D_KpLPSNutlin_vs_Nutlin.csv")

#########################################################################################
#########################################################################################

# add a new column to CSV. By default set all the values to NO.
#We will use this to differenciate between up/downregulated genes and the 
#ones that are not differentially expressed.
EM$diffexpressed <- "NO"
# if Log2_Fold_Change > 0.263 (log2(1.2)) and pvalue < 0.05, set as "UP" 
EM$diffexpressed[EM$Log2_Fold_Change > 0.263 & EM$p.value < 0.05] <- "UP"
# if Log2_Fold_Change < -0.3219 (log2(0.8)) and pvalue < 0.05, set as "DOWN"
EM$diffexpressed[EM$Log2_Fold_Change < -0.3219 & EM$p.value < 0.05] <- "DOWN"


EM$P53 <- NA
#Highlight TP53. If Gene_names=TP53 set as p53
EM$P53[EM$Gene_names=="TP53"] <- "p53"

####################################################################################
####################################################################################
#For including gene names from comma separated text file.
gene_list <- read.table ("Nut_inflam_top10.txt", header=FALSE, sep= ",")
#I create a new row in which im going to include the names of the genes I want to label.
EM$labels<- NA

#To remove the non differentially expressed from the charts:
for (i in 1:length(gene_list))
    {EM$labels[EM$Gene_names==gene_list[[i]]] <- gene_list[[i]]
    }


for (i in 1:length(EM$diffexpressed))
  if (EM$diffexpressed[[i]] == "NO")
  {
    {EM$labels[[i]]<- NA
    
    }
  }



# Create a new column "delabel" to EM, that will contain the name of genes differentially expressed (NA in case they are not)
#EM$delabel <- NA
#EM$delabel[EM$diffexpressed != "NO"] <- EM$Gene_names[EM$diffexpressed != "NO"]


#Plotting
#p <- ggplot(data=EM, aes(x=Log2_Fold_Change,y=minusLogp))+
  #geom_point(size=1)

# Re-plot but this time color the points with "diffexpressed"
p <- ggplot(data=EM, aes(x=Log2_Fold_Change,y=minusLogp, col=diffexpressed,label=labels))+ 
    geom_point() + theme_minimal()

p2 <- p + geom_vline(xintercept=c(-0.3219, 0.263), col="black") +
  geom_hline(yintercept=-log10(0.05), col="black")

#Changing the colour of the dots
colors <- c("dark green", "red", "grey")
names(colors) <- c("DOWN", "UP", "NO")
p3 <- p2 + scale_color_manual(values = colors)

#Adding title and axis names and changing legend name
p4<- p3 + labs(title="LPS+Nut vs Nut", y="-log(p-val)", x = "Log2(Fold Change)",colour = "Differential \nexpression")
#Adding gene name labels
p5<- p4 + geom_label_repel(min.segment.length = 0, seed = 42, box.padding = 0.5,
                           point.padding = 1e-06,
                           show.legend = FALSE,
                           force_pull = 3,
                           label.size = NA,
                           fill = alpha(c("white"),0.7),
                           segment.size = 0.7,
                           fontface = 'bold', color = 'black',
                           arrow = arrow(length = unit(0.01, 'npc'))
                           
                           ) 
p5


