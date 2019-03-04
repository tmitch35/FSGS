#set wd
getwd()
setwd("/Users/thomasmitchell/Desktop/Research/FSGS_fall_2018")

#load R packages for analyzing spatial data
library(ape)
library(spdep)
library(ncf)
library(lctools)
library(sp)
library(ggplot2)
library(gg3D)
library(maptools)
library(rgdal)
library(RColorBrewer)
library(Hmisc)
library(devtools)
library(ggpubr)
library(plyr)
library(dplyr)
library(raster)
library(spatstat)

#load .CSV file (practice data) for exploratory plots  
practice_data <- read.csv("~/Desktop/Research/Fieldwork Spreadsheets/Fall 2018/Excel Files for Analysis/Fall_2018_Data_for_R_Practice.csv")

#subset (by population) for exploratory plots and Spearman's Rank-Order Correlation tests
jwdc <- subset(practice_data, pop=="JWDC")
jwdc[-c(101), ]
jwdc <- jwdc[-c(101), ]
ps <- subset(practice_data, pop=="PS")

#generate summary statistics for "JWDC" & "PS"
summary(jwdc)
summary(ps)

#subset for spatial autocorrelation analysis (by population, removing the unmapped individual in JWDC)
jwdc.xy <- subset(practice_data, pop=="JWDC")
jwdc.xy[-c(101), ]
jwdc.xy <- jwdc[-c(101), ]
ps.xy <- subset(practice_data, pop=="PS")

#subset to remove NA's from 'total_flowers_per_plant' (and do the same for other columns as needed)
tfpp_no_na_jwdc.xy <- jwdc.xy[!is.na(jwdc.xy$total_flowers_per_plant), ]
tfpp_no_na_ps.xy <- ps.xy[!is.na(ps.xy$total_flowers_per_plant), ]

#set spatial coordinates to create a spatial object in R
coordinates(tfpp_no_na_jwdc.xy) = c(4,5)
coordinates(tfpp_no_na_ps.xy) = c(4,5)

#create distance matrices for subsets containing no NA values for 'total_flowers_per_plant'
tfpp_no_na_jwdc_d.matrix <- spDists(coordinates(tfpp_no_na_jwdc.xy), coordinates(tfpp_no_na_jwdc.xy))
tfpp_no_na_ps_d.matrix <- spDists(coordinates(tfpp_no_na_ps.xy), coordinates(tfpp_no_na_ps.xy))

#another way to do the same thing (useful for certain packages)
tfpp_no_na_jwdc.dists <- as.matrix(dist(cbind(tfpp_no_na_jwdc.xy$x_meters, tfpp_no_na_jwdc.xy$y_meters)))
tfpp_no_na_jwdc.dists.inv <- 1/tfpp_no_na_jwdc.dists
diag(tfpp_no_na_jwdc.dists.inv) <- 0

tfpp_no_na_ps.dists <- as.matrix(dist(cbind(tfpp_no_na_ps.xy$x_meters, tfpp_no_na_ps.xy$y_meters)))
tfpp_no_na_ps.dists.inv <- 1/tfpp_no_na_ps.dists
diag(tfpp_no_na_ps.dists.inv) <- 0

#determine a distance range for Moran's I by computing a correlogram ==> pop = "JWDC" & variable = "total_flowers_per_plant"
#see https://gdmdata.com/media/documents/handouts/2017ASA_FarmToTable_Spatial_correlation.pdf for tutorial/syntax
tfpp.0.5.clg <- correlog(tfpp_no_na_jwdc.xy$x_meters, tfpp_no_na_jwdc.xy$y_meters, tfpp_no_na_jwdc.xy$total_flowers_per_plant, increment=0.5, resamp=500, quiet=TRUE)
par(mfrow=c(1,1))
plot(tfpp.0.5.clg) #why does this correlogram look so messed up? consider limiting x axis to 20 meters
plot(tfpp.0.5.clg, xlim=c(0,20))

tfpp.0.75.clg <- correlog(tfpp_no_na_jwdc.xy$x_meters, tfpp_no_na_jwdc.xy$y_meters, tfpp_no_na_jwdc.xy$total_flowers_per_plant, increment=0.75, resamp=500, quiet=TRUE)
par(mfrow=c(1,1))
plot(tfpp.0.75.clg) #why does this correlogram look so messed up? consider limiting x axis to 20 meters
plot(tfpp.0.75.clg, xlim=c(0,20))

tfpp.1.clg <- correlog(tfpp_no_na_jwdc.xy$x_meters, tfpp_no_na_jwdc.xy$y_meters, tfpp_no_na_jwdc.xy$total_flowers_per_plant, increment=1, resamp=500, quiet=TRUE)
par(mfrow=c(1,1))
plot(tfpp.1.clg) #why does this correlogram look so messed up? consider limiting x axis to 20 meters
plot(tfpp.1.clg, xlim=c(0,20))

#determine a distance range for Moran's I by computing a correlogram ==> pop = "PS" & variable = "total_flowers_per_plant"
#see https://gdmdata.com/media/documents/handouts/2017ASA_FarmToTable_Spatial_correlation.pdf for tutorial/syntax
ps.tfpp.0.5.clg <- correlog(tfpp_no_na_ps.xy$x_meters, tfpp_no_na_ps.xy$y_meters, tfpp_no_na_ps.xy$total_flowers_per_plant, increment=0.5, resamp=500, quiet=TRUE)
par(mfrow=c(1,1))
plot(ps.tfpp.0.5.clg) #this correlogram looks right

ps.tfpp.0.75.clg <- correlog(tfpp_no_na_ps.xy$x_meters, tfpp_no_na_ps.xy$y_meters, tfpp_no_na_ps.xy$total_flowers_per_plant, increment=0.75, resamp=500, quiet=TRUE)
par(mfrow=c(1,1))
plot(ps.tfpp.0.75.clg) #this correlogram looks right

ps.tfpp.1.clg <- correlog(tfpp_no_na_ps.xy$x_meters, tfpp_no_na_ps.xy$y_meters, tfpp_no_na_ps.xy$total_flowers_per_plant, increment=1, resamp=500, quiet=TRUE)
par(mfrow=c(1,1))
plot(ps.tfpp.1.clg) #this correlogram looks right

#EXAMPLE: Global Moran's I (calculated w/ 'ape' package) for 'total_flowers_per_plant' in "JWDC"
#employs IDW matrix (but could try other methods)
#may need to standardize by row for intuitive visualizations, subsequent LISA statistics, etc. 
#may rely on assumption of normality
#may be inappropriate for applications NOT involving phylogenetic trees
#may require edge correction
Moran.I(tfpp_no_na_jwdc.xy$total_flowers_per_plant, tfpp_no_na_jwdc.dists.inv, alternative = "two.sided")

jwdc.dists.inv.listw <- mat2listw(tfpp_no_na_jwdc.dists.inv)
moran.test(tfpp_no_na_jwdc.xy$total_flowers_per_plant, jwdc.dists.inv.listw, alternative = "two.sided")

#check results w/ MC simulations
#do I need to do 1 run per plant???
jwdc.mc.1 <- moran.mc(tfpp_no_na_jwdc.xy$total_flowers_per_plant, listw = jwdc.dists.inv.listw, nsim = 199, alternative = "greater")
jwdc.mc.1

jwdc.mc.2 <- moran.mc(tfpp_no_na_jwdc.xy$total_flowers_per_plant, listw = jwdc.dists.inv.listw, nsim = 199, alternative = "greater")
jwdc.mc.2

jwdc.mc.3 <- moran.mc(tfpp_no_na_jwdc.xy$total_flowers_per_plant, listw = jwdc.dists.inv.listw, nsim = 199, alternative = "greater")
jwdc.mc.3
#EXAMPLE: Global Moran's I (calculated w/ 'ape' package) for 'total_flowers_per_plant' in "PS"
#employs IDW matrix (but could try other methods)
#may need to standardize by row for intuitive visualizations, subsequent LISA statistics, etc. 
#may rely on assumption of normality
#may be inappropriate for applications NOT involving phylogenetic trees
#may require edge correction
Moran.I(tfpp_no_na_ps.xy$total_flowers_per_plant, tfpp_no_na_ps.dists.inv, alternative = "two.sided")

ps.dists.inv.listw <- mat2listw(tfpp_no_na_ps.dists.inv)
moran.test(tfpp_no_na_ps.xy$total_flowers_per_plant, ps.dists.inv.listw, alternative = "two.sided")

#another method for producing correlograms ==> CHECK SYNTAX...no weighting or 'nb' objects???
#see https://rstudio-pubs-static.s3.amazonaws.com/278910_3ebade4ad6a14f8f9ac6e05eb16b5a21.html for tutorial
tfpp_ps_corr <- spline.correlog(x=tfpp_no_na_ps.xy$x_meters, y=tfpp_no_na_ps.xy$x_meters, z=tfpp_no_na_ps.xy$total_flowers_per_plant, 
                                resamp = 500, xmax = 2, quiet = T )
plot(tfpp_ps_corr) #this doesn't look right...

x <- tfpp_ps_corr$real$predicted$x
y <- tfpp_ps_corr$real$predicted$y
lCI <- tfpp_ps_corr$boot$boot.summary$predicted$y["0.025",]
uCI <- tfpp_ps_corr$boot$boot.summary$predicted$y["0.975",]
xx <- c(x,rev(x))
yy <- c(lCI,rev(uCI))
plot(x,y, xlim = c(0,2), ylim = c(-1, 1), type = "n", 
     xlab = "Distance (m)", ylab = "Moran's I")
polygon(xx,yy,col="grey",border=NA)
abline(h=0,lty="dashed")
lines(x,y)


#check results w/ MC simulations
#do I need to do 1 run per plant???
ps.mc.1 <- moran.mc(tfpp_no_na_ps.xy$total_flowers_per_plant, listw = ps.dists.inv.listw, nsim = 199, alternative = "greater")
ps.mc.1

ps.mc.2 <- moran.mc(tfpp_no_na_ps.xy$total_flowers_per_plant, listw = ps.dists.inv.listw, nsim = 199, alternative = "greater")
ps.mc.2

ps.mc.3 <- moran.mc(tfpp_no_na_ps.xy$total_flowers_per_plant, listw = ps.dists.inv.listw, nsim = 199, alternative = "greater")
ps.mc.3
#identify neighbors at JWDC by physical distance & create a correlogram
jwdc_xy <- data.frame(tfpp_no_na_jwdc.xy$x_meters,tfpp_no_na_jwdc.xy$y_meters)
jwdc_xy
ps_xy <- data.frame(tfpp_no_na_ps.xy$x_meters,tfpp_no_na_ps.xy$y_meters)
ps_xy

#style = "W" = row-standardized weights (sums over all links to n)
#style = "B" = binary coding 
#style = "C" = globally standardised (sums over all links to n); include style="C" (after specifying glist) to REMOVE row-standardization
#style = "U" = equal to C divided by the number of neighbours (sums over all links to unity)
#style = "S" = variance-stabilizing coding scheme proposed by Tiefelsdorf et al. 1999, p. 167-168 (sums over all links to n).

jwdc.nb <- dnearneigh(as.matrix(jwdc_xy), d1=0, d2=1)
jwdc.sp.cor <- sp.correlogram(jwdc.nb, z.value, order=15,
                         method="I", 
                         randomisation = T)
plot(jwdc.sp.cor)

jwdc_d0to1 <- dnearneigh(coordinates(tfpp_no_na_jwdc.xy), 0, 1)
class(jwdc_d0to1)
jwdc_d0to1

#make box plots of total_flowers_per_plant by sex and pop (F & H only)
fh_only <- subset(practice_data, sex=="H" | sex=="F")
fh_only_no_na <- fh_only[!is.na(fh_only$total_flowers_per_plant), ]

#mean
mean_tfpp_fh_only <- with(fh_only_no_na, tapply(total_flowers_per_plant,list(pop,sex),mean))
mean_tfpp_fh_only  

#standard deviation
sd_tfpp_fh_only <- with(fh_only_no_na, tapply(total_flowers_per_plant,list(pop,sex),sd))
sd_tfpp_fh_only

#standard error
error_tfpp_fh_only <- with(fh_only_no_na,tapply(total_flowers_per_plant,list(pop,sex),sd)/sqrt(tapply(total_flowers_per_plant,list(pop,sex),length)))
error_tfpp_fh_only 

group_by(fh_only_no_na, pop) %>%
  summarise(
    count = n(),
    mean = mean(total_flowers_per_plant, na.rm = TRUE),
    sd = sd(total_flowers_per_plant, na.rm = TRUE),
    median = median(total_flowers_per_plant, na.rm = TRUE),
    IQR = IQR(total_flowers_per_plant, na.rm = TRUE)
  )

tfpp_boxplot <- ggboxplot(fh_only_no_na, x = "pop", y = "total_flowers_per_plant", 
          color = "sex", palette = c("coral1", "deepskyblue3"),
          order = c("JWDC", "PS"),
          ylab = "Total Flowers Per Plant", xlab = "Population",
          legend.title = "Plant Sex",
          legend = c(.85,.85))

ggpar(tfpp_boxplot) + 
  font("legend.title", size = 14, face = "bold") +
  font("legend.text", size = 14) +
  font("xlab", size = 16, face = "bold") +
  font("ylab", size = 16, face = "bold") +
  font("xy.text", size = 14)

#make box plots of tot_plant_height_cm by sex and pop (F & H only)
practice_data[-c(101), ]
practice_data <- practice_data[-c(101), ]
fh_only_height <- subset(practice_data, sex=="H" | sex=="F")
fh_only_height_no_na <- fh_only_height[!is.na(fh_only_height$tot_plant_height_cm), ]

group_by(fh_only_height_no_na, pop) %>%
  summarise(
    count = n(),
    mean = mean(tot_plant_height_cm, na.rm = TRUE),
    sd = sd(tot_plant_height_cm, na.rm = TRUE),
    median = median(tot_plant_height_cm, na.rm = TRUE),
    IQR = IQR(tot_plant_height_cm, na.rm = TRUE)
  )

tph_boxplot <- ggboxplot(fh_only_height_no_na, x = "pop", y = "tot_plant_height_cm", 
                          color = "sex", palette = c("coral1", "deepskyblue3"),
                          order = c("JWDC", "PS"),
                          ylab = "Total Plant Height (cm)", xlab = "Population",
                          legend.title = "Plant Sex",
                          legend = c(.85,.85))

ggpar(tph_boxplot) + 
  font("legend.title", size = 14, face = "bold") +
  font("legend.text", size = 14) +
  font("xlab", size = 16, face = "bold") +
  font("ylab", size = 16, face = "bold") +
  font("xy.text", size = 14)

#null model for tfpp
tfpp_model <- aov(total_flowers_per_plant~pop*sex, data = fh_only_no_na)
summary(tfpp_model)
#NO significant interaction; simplify model
new_tfpp_model <- aov(total_flowers_per_plant~pop+sex, data = fh_only_no_na)
summary(new_tfpp_model)
#pop is SIGNIFICANT; sex is NOT SIGNIFICANT; simplify model
simplest_tfpp_model <- lm(total_flowers_per_plant~pop, data = fh_only_no_na)
summary(simplest_tfpp_model)
#test model assumptions
shapiro.test(resid(simplest_tfpp_model))
par(mfrow=c(1,2)) 
plot(simplest_tfpp_model,which=c(1,2))
#data violate assumptions!!!

with(fh_only_no_na,tapply(total_flowers_per_plant,sex,mean))
with(fh_only_no_na,tapply(total_flowers_per_plant,sex,sd))

#check out Olson et al. (2006)...am I inflating type I error???
#could also try a Mann-Whitney U test
kruskal.test(total_flowers_per_plant ~ pop, data = fh_only_no_na)
#NOT significant!
kruskal.test(total_flowers_per_plant ~ sex, data = fh_only_no_na)
#NOT significant!

jwdc_fh_only <- subset(jwdc, sex=="H" | sex=="F")
jwdc_fh_only_no_na <- jwdc_fh_only[!is.na(jwdc_fh_only$total_flowers_per_plant), ]
summary(jwdc_fh_only_no_na)

ps_fh_only <- subset(ps, sex=="H" | sex=="F")
ps_fh_only_no_na <- ps_fh_only[!is.na(ps_fh_only$total_flowers_per_plant), ]
summary(ps_fh_only_no_na)

#null model for tph
tph_model <- aov(tot_plant_height_cm~pop*sex, data = fh_only_height_no_na)
summary(tph_model)
#NO significant interaction; simplify model
new_tph_model <- aov(tot_plant_height_cm~pop+sex, data = fh_only_height_no_na)
summary(new_tph_model)
#pop is SIGNIFICANT; sex is NOT SIGNIFICANT; simplify model
simplest_tph_model <- lm(tot_plant_height_cm~pop, data = fh_only_height_no_na)
summary(simplest_tph_model)
#test model assumptions
shapiro.test(resid(simplest_tph_model))
par(mfrow=c(1,2)) 
plot(simplest_tph_model,which=c(1,2))
#data violate assumptions!!!

#check out Olson et al. (2006)...am I inflating type I error???
#could also try a Mann-Whitney U test
kruskal.test(tot_plant_height_cm ~ pop, data = fh_only_height_no_na)
#whoa...SIGNIFICANT???
kruskal.test(tot_plant_height_cm ~ sex, data = fh_only_height_no_na)
#whoa...SIGNIFICANT???

jwdc_fh_only_height <- subset(jwdc, sex=="H" | sex=="F")
jwdc_fh_only_height_no_na <- jwdc_fh_only_height[!is.na(jwdc_fh_only_height$tot_plant_height_cm), ]
summary(jwdc_fh_only_height_no_na)

ps_fh_only_height <- subset(ps, sex=="H" | sex=="F")
ps_fh_only_height_no_na <- ps_fh_only_height[!is.na(ps_fh_only_height$tot_plant_height_cm), ]
summary(ps_fh_only_height_no_na)

#calculate nn distance summaries
jwdc_fh_only.xy <- subset(jwdc.xy, sex=="H" | sex=="F")
coordinates(jwdc_fh_only.xy) = c(4,5)
nns_jwdc <- nndist(jwdc_fh_only$x_meters,jwdc_fh_only$y_meters)
summary(nns_jwdc)
summary(jwdc_fh_only)

mean(nndist(nns_jwdc, k=1)) #these values are INCORRECT...maybe ==> fix it!
mean(nndist(nns_jwdc, k=2)) #these values are INCORRECT...maybe ==> fix it!
#create loop function to continue to k=98 (i.e., n-1)

ps_fh_only.xy <- subset(ps.xy, sex=="H" | sex=="F")
coordinates(ps_fh_only.xy) = c(4,5)
nns_ps <- nndist(ps_fh_only$x_meters,ps_fh_only$y_meters)
summary(nns_ps)
summary(ps_fh_only)

mean(nndist(nns_ps, k=1)) #these values are INCORRECT...maybe ==> fix it!
mean(nndist(nns_ps, k=2)) #these values are INCORRECT...maybe ==> fix it!
#create loop function to continue to k=157 (i.e., n-1)

#look at lines 244 and 269 in "Population Maps and Exploratory Analyses.R" for help w/ syntax
