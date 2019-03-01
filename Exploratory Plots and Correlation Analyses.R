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

#make plots to check for correlations among (approximately) continuous variables
pairs(practice_data[,7:11])
pairs(jwdc[,7:11])
pairs(ps[,7:11])

#make plots to compare 1) total_flowers_per_plant, 2) stem_length_cm, 3) inflorescence_length_cm, 4) tot_plant_height_cm, and 5) plant_damaged by pop and sex
#females v. hermaphrodites w/n "JWDC"
plot(total_flowers_per_plant~sex,data=jwdc) 
plot(stem_length_cm~sex,data=jwdc)
plot(inflorescence_length_cm~sex,data=jwdc)
plot(tot_plant_height_cm~sex,data=jwdc)
plot(plant_damaged~sex,data=jwdc) #plot to the left looks like a mess; remove GM, NF, & U individuals from "JWDC" and plot again
subsetFHjwdc <- subset(jwdc, sex=="H" | sex=="F")
plot(plant_damaged~sex,data=subsetFHjwdc) #R is still plotting GM, NF, & U individuals (but w/o data now)...figure out how to remove completely!

#attempt to model 'total_flowers_per_plant' by sex, pop, and sex*pop
subsetFH_both_pops <- subset(practice_data, sex=="H" | sex=="F")
summary(subsetFH_both_pops)
flowermodel <- lm(total_flowers_per_plant~sex*pop, data=subsetFH_both_pops)
summary(flowermodel)
shapiro.test(resid(flowermodel)) 
#p-value = 6.7e-12 ==> NOT normal!!!
par(mfrow=c(1,2)) 
plot(flowermodel,which=c(1,2))
#use kruskal-wallis test instead??? (see Olson et al., 2006)
ggplot(data=subsetFH_both_pops, aes(x=pop, y=total_flowers_per_plant, fill=sex)) +
  geom_bar(stat="identity", position=position_dodge())
#fix plot above to reflect mean values!!!
#reference website (tutorial): http://www.sthda.com/english/wiki/ggplot2-error-bars-quick-start-guide-r-software-and-data-visualization

#females v. hermaphrodites w/n "PS"
plot(total_flowers_per_plant~sex,data=ps) 
plot(stem_length_cm~sex,data=ps)
plot(inflorescence_length_cm~sex,data=ps)
plot(tot_plant_height_cm~sex,data=ps)
plot(plant_damaged~sex,data=ps) #R is still plotting GM, NF, & U groups despite having subsetted...figure out how to remove completely!

#females v. hermaphrodites (pop. not considered)
plot(total_flowers_per_plant~sex,data=practice_data)
plot(stem_length_cm~sex,data=practice_data)
plot(inflorescence_length_cm~sex,data=practice_data)
plot(tot_plant_height_cm~sex,data=practice_data)
plot(plant_damaged~sex,data=practice_data)

#females from "JWDC" v. females from "PS"
subsetF <- subset(practice_data, sex=="F")
plot(total_flowers_per_plant~pop,data=subsetF)
plot(stem_length_cm~pop,data=subsetF)
plot(inflorescence_length_cm~pop,data=subsetF)
plot(tot_plant_height_cm~pop,data=subsetF)
plot(plant_damaged~pop,data=subsetF)

#hermaphrodites from "JWDC" v. hermaphrodites from "PS"
subsetH <- subset(practice_data, sex=="H")
plot(total_flowers_per_plant~pop,data=subsetH)
plot(stem_length_cm~pop,data=subsetH)
plot(inflorescence_length_cm~pop,data=subsetH)
plot(tot_plant_height_cm~pop,data=subsetH)
plot(plant_damaged~pop,data=subsetH)

#"JWDC" v. "PS" (sex not considered)
plot(total_flowers_per_plant~pop,data=practice_data)
plot(stem_length_cm~pop,data=practice_data)
plot(inflorescence_length_cm~pop,data=practice_data)
plot(tot_plant_height_cm~pop,data=practice_data)
plot(plant_damaged~pop,data=practice_data)

#run tests on plotted data above to see if anything is statistically significant; check data against test assumptions; create a model (GLM w/ Poisson distribution?)

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

#come up with more efficient ways of removing NA's from columns being analyzed...
#could include ', na.rm=T' in code to subset jwdc.xy & ps.xy
#could use 'subset <- !is.na(mydata$x)' followed by 'x2 <- mydata$x[subset]'
#could use 'subset <- complete.cases(mydata)'--easiest method, but removes a lot of unnecessary data




#EXAMPLE: tfpp_no_na_jwdc_knear10 ==> create spatial weights matrix and convert to 'weights list' form
tfpp_no_na_jwdc_knear10 <- knearneigh(tfpp_no_na_jwdc.xy, k=10, RANN=F)
tfpp_no_na_jwdc_knear10_np <- tfpp_no_na_jwdc_knear10$np
tfpp_no_na_jwdc_knear10_d.weights <- vector(mode = "list", length = tfpp_no_na_jwdc_knear10_np)
for (i in 1:tfpp_no_na_jwdc_knear10_np) {
  tfpp_no_na_jwdc_knear10_neighbours <- tfpp_no_na_jwdc_knear10$nn[i,]
  tfpp_no_na_jwdc_knear10_distances <- tfpp_no_na_jwdc_d.matrix[i, tfpp_no_na_jwdc_knear10_neighbours]
  tfpp_no_na_jwdc_knear10_d.weights[[i]] <- 1/tfpp_no_na_jwdc_knear10_distances
}
#also try '1/jwdc_knear10_distances^2' for inverse distance weighting (IDW)--it's also commonly used
tfpp_no_na_jwdc_knear10nb <- knn2nb(tfpp_no_na_jwdc_knear10)
tfpp_no_na_jwdc_spknear10IDW <- nb2listw(tfpp_no_na_jwdc_knear10nb, glist = tfpp_no_na_jwdc_knear10_d.weights)
#include 'style="C"' in above code (after specifying glist) to remove row-standardization--see "An Introduction to Mapping and Spatial Modelling in R" (Harris, 2013)
moran.test(tfpp_no_na_jwdc.xy$total_flowers_per_plant, tfpp_no_na_jwdc_spknear10IDW, alternative = "two.sided")
#Moran's I = 0.07512508; p-value = 0.2766 ==> NOT significant...10 'neighbours' may be too many (due to low plant density & small sample size of "JWDC")
#consider setting a cut-off distance for 'K nearest-neighbors' approach
#the derivation of the test (Cliff and Ord, 1981, p. 18) assumes that the weights matrix is symmetric; 
#for inherently non-symmetric matrices, such as k-nearest neighbour matrices, 'listw2U()' can be used to make the matrix symmetric


#EXAMPLE: tfpp_no_na_jwdc_knear9 ==> create spatial weights matrix and convert to 'weights list' form
tfpp_no_na_jwdc_knear9 <- knearneigh(tfpp_no_na_jwdc.xy, k=9, RANN=F)
tfpp_no_na_jwdc_knear9_np <- tfpp_no_na_jwdc_knear9$np
tfpp_no_na_jwdc_knear9_d.weights <- vector(mode = "list", length = tfpp_no_na_jwdc_knear9_np)
for (i in 1:tfpp_no_na_jwdc_knear9_np) {
  tfpp_no_na_jwdc_knear9_neighbours <- tfpp_no_na_jwdc_knear9$nn[i,]
  tfpp_no_na_jwdc_knear9_distances <- tfpp_no_na_jwdc_d.matrix[i, tfpp_no_na_jwdc_knear9_neighbours]
  tfpp_no_na_jwdc_knear9_d.weights[[i]] <- 1/tfpp_no_na_jwdc_knear9_distances
}
#also try '1/jwdc_knear9_distances^2' for inverse distance weighting (IDW)--it's also commonly used
tfpp_no_na_jwdc_knear9nb <- knn2nb(tfpp_no_na_jwdc_knear9)
tfpp_no_na_jwdc_spknear9IDW <- nb2listw(tfpp_no_na_jwdc_knear9nb, glist = tfpp_no_na_jwdc_knear9_d.weights)
#include 'style="C"' in above code (after specifying glist) to remove row-standardization--see "An Introduction to Mapping and Spatial Modelling in R" (Harris, 2013)
moran.test(tfpp_no_na_jwdc.xy$total_flowers_per_plant, tfpp_no_na_jwdc_spknear9IDW, alternative = "two.sided")
#Moran's I = 0.037292291; p-value = 0.5365 ==> NOT significant...9 'neighbours' may be too many (due to low plant density & small sample size of "JWDC")
#consider setting a cut-off distance for 'K nearest-neighbors' approach
#the derivation of the test (Cliff and Ord, 1981, p. 18) assumes that the weights matrix is symmetric; 
#for inherently non-symmetric matrices, such as k-nearest neighbour matrices, 'listw2U()' can be used to make the matrix symmetric


#EXAMPLE: tfpp_no_na_jwdc_knear8 ==> create spatial weights matrix and convert to 'weights list' form
tfpp_no_na_jwdc_knear8 <- knearneigh(tfpp_no_na_jwdc.xy, k=8, RANN=F)
tfpp_no_na_jwdc_knear8_np <- tfpp_no_na_jwdc_knear8$np
tfpp_no_na_jwdc_knear8_d.weights <- vector(mode = "list", length = tfpp_no_na_jwdc_knear8_np)
for (i in 1:tfpp_no_na_jwdc_knear8_np) {
  tfpp_no_na_jwdc_knear8_neighbours <- tfpp_no_na_jwdc_knear8$nn[i,]
  tfpp_no_na_jwdc_knear8_distances <- tfpp_no_na_jwdc_d.matrix[i, tfpp_no_na_jwdc_knear8_neighbours]
  tfpp_no_na_jwdc_knear8_d.weights[[i]] <- 1/tfpp_no_na_jwdc_knear8_distances
}
#also try '1/jwdc_knear8_distances^2' for inverse distance weighting (IDW)--it's also commonly used
tfpp_no_na_jwdc_knear8nb <- knn2nb(tfpp_no_na_jwdc_knear8)
tfpp_no_na_jwdc_spknear8IDW <- nb2listw(tfpp_no_na_jwdc_knear8nb, glist = tfpp_no_na_jwdc_knear8_d.weights)
#include 'style="C"' in above code (after specifying glist) to remove row-standardization--see "An Introduction to Mapping and Spatial Modelling in R" (Harris, 2013)
moran.test(tfpp_no_na_jwdc.xy$total_flowers_per_plant, tfpp_no_na_jwdc_spknear8IDW, alternative = "two.sided")
#Moran's I = -0.003964917; p-value = 0.8971 ==> NOT significant...8 'neighbours' may be too many (due to low plant density & small sample size of "JWDC")
#consider setting a cut-off distance for 'K nearest-neighbors' approach
#the derivation of the test (Cliff and Ord, 1981, p. 18) assumes that the weights matrix is symmetric; 
#for inherently non-symmetric matrices, such as k-nearest neighbour matrices, 'listw2U()' can be used to make the matrix symmetric


#EXAMPLE: tfpp_no_na_jwdc_knear7 ==> create spatial weights matrix and convert to 'weights list' form
tfpp_no_na_jwdc_knear7 <- knearneigh(tfpp_no_na_jwdc.xy, k=7, RANN=F)
tfpp_no_na_jwdc_knear7_np <- tfpp_no_na_jwdc_knear7$np
tfpp_no_na_jwdc_knear7_d.weights <- vector(mode = "list", length = tfpp_no_na_jwdc_knear7_np)
for (i in 1:tfpp_no_na_jwdc_knear7_np) {
  tfpp_no_na_jwdc_knear7_neighbours <- tfpp_no_na_jwdc_knear7$nn[i,]
  tfpp_no_na_jwdc_knear7_distances <- tfpp_no_na_jwdc_d.matrix[i, tfpp_no_na_jwdc_knear7_neighbours]
  tfpp_no_na_jwdc_knear7_d.weights[[i]] <- 1/tfpp_no_na_jwdc_knear7_distances
}
#also try '1/jwdc_knear7_distances^2' for inverse distance weighting (IDW)--it's also commonly used
tfpp_no_na_jwdc_knear7nb <- knn2nb(tfpp_no_na_jwdc_knear7)
tfpp_no_na_jwdc_spknear7IDW <- nb2listw(tfpp_no_na_jwdc_knear7nb, glist = tfpp_no_na_jwdc_knear7_d.weights)
#include 'style="C"' in above code (after specifying glist) to remove row-standardization--see "An Introduction to Mapping and Spatial Modelling in R" (Harris, 2013)
moran.test(tfpp_no_na_jwdc.xy$total_flowers_per_plant, tfpp_no_na_jwdc_spknear7IDW, alternative = "two.sided")
#Moran's I = 0.044464532; p-value = 0.4988 ==> NOT significant...7 'neighbours' may be too many (due to low plant density & small sample size of "JWDC")
#consider setting a cut-off distance for 'K nearest-neighbors' approach
#the derivation of the test (Cliff and Ord, 1981, p. 18) assumes that the weights matrix is symmetric; 
#for inherently non-symmetric matrices, such as k-nearest neighbour matrices, 'listw2U()' can be used to make the matrix symmetric


#EXAMPLE: tfpp_no_na_jwdc_knear6 ==> create spatial weights matrix and convert to 'weights list' form
tfpp_no_na_jwdc_knear6 <- knearneigh(tfpp_no_na_jwdc.xy, k=6, RANN=F)
tfpp_no_na_jwdc_knear6_np <- tfpp_no_na_jwdc_knear6$np
tfpp_no_na_jwdc_knear6_d.weights <- vector(mode = "list", length = tfpp_no_na_jwdc_knear6_np)
for (i in 1:tfpp_no_na_jwdc_knear6_np) {
  tfpp_no_na_jwdc_knear6_neighbours <- tfpp_no_na_jwdc_knear6$nn[i,]
  tfpp_no_na_jwdc_knear6_distances <- tfpp_no_na_jwdc_d.matrix[i, tfpp_no_na_jwdc_knear6_neighbours]
  tfpp_no_na_jwdc_knear6_d.weights[[i]] <- 1/tfpp_no_na_jwdc_knear6_distances
}
#also try '1/jwdc_knear6_distances^2' for inverse distance weighting (IDW)--it's also commonly used
tfpp_no_na_jwdc_knear6nb <- knn2nb(tfpp_no_na_jwdc_knear6)
tfpp_no_na_jwdc_spknear6IDW <- nb2listw(tfpp_no_na_jwdc_knear6nb, glist = tfpp_no_na_jwdc_knear6_d.weights)
#include 'style="C"' in above code (after specifying glist) to remove row-standardization--see "An Introduction to Mapping and Spatial Modelling in R" (Harris, 2013)
moran.test(tfpp_no_na_jwdc.xy$total_flowers_per_plant, tfpp_no_na_jwdc_spknear6IDW, alternative = "two.sided")
#Moran's I = 0.060085415; p-value = 0.4107 ==> NOT significant...6 'neighbours' may be too many (due to low plant density & small sample size of "JWDC")
#consider setting a cut-off distance for 'K nearest-neighbors' approach
#the derivation of the test (Cliff and Ord, 1981, p. 18) assumes that the weights matrix is symmetric; 
#for inherently non-symmetric matrices, such as k-nearest neighbour matrices, 'listw2U()' can be used to make the matrix symmetric


#EXAMPLE: tfpp_no_na_jwdc_knear5 ==> create spatial weights matrix and convert to 'weights list' form
tfpp_no_na_jwdc_knear5 <- knearneigh(tfpp_no_na_jwdc.xy, k=5, RANN=F)
tfpp_no_na_jwdc_knear5_np <- tfpp_no_na_jwdc_knear5$np
tfpp_no_na_jwdc_knear5_d.weights <- vector(mode = "list", length = tfpp_no_na_jwdc_knear5_np)
for (i in 1:tfpp_no_na_jwdc_knear5_np) {
  tfpp_no_na_jwdc_knear5_neighbours <- tfpp_no_na_jwdc_knear5$nn[i,]
  tfpp_no_na_jwdc_knear5_distances <- tfpp_no_na_jwdc_d.matrix[i, tfpp_no_na_jwdc_knear5_neighbours]
  tfpp_no_na_jwdc_knear5_d.weights[[i]] <- 1/tfpp_no_na_jwdc_knear5_distances
}
#also try '1/jwdc_knear5_distances^2' for inverse distance weighting (IDW)--it's also commonly used
tfpp_no_na_jwdc_knear5nb <- knn2nb(tfpp_no_na_jwdc_knear5)
tfpp_no_na_jwdc_spknear5IDW <- nb2listw(tfpp_no_na_jwdc_knear5nb, glist = tfpp_no_na_jwdc_knear5_d.weights)
#include 'style="C"' in above code (after specifying glist) to remove row-standardization--see "An Introduction to Mapping and Spatial Modelling in R" (Harris, 2013)
moran.test(tfpp_no_na_jwdc.xy$total_flowers_per_plant, tfpp_no_na_jwdc_spknear5IDW, alternative = "two.sided")
#Moran's I = 0.186607496; p-value = 0.03277 ==> SIGNIFICANT...5 'neighbours' performed better for "JWDC" (due to low plant density & small sample size)
#consider setting a cut-off distance for 'K nearest-neighbors' approach
#the derivation of the test (Cliff and Ord, 1981, p. 18) assumes that the weights matrix is symmetric; 
#for inherently non-symmetric matrices, such as k-nearest neighbour matrices, 'listw2U()' can be used to make the matrix symmetric


#EXAMPLE: tfpp_no_na_jwdc_knear4 ==> create spatial weights matrix and convert to 'weights list' form
tfpp_no_na_jwdc_knear4 <- knearneigh(tfpp_no_na_jwdc.xy, k=4, RANN=F)
tfpp_no_na_jwdc_knear4_np <- tfpp_no_na_jwdc_knear4$np
tfpp_no_na_jwdc_knear4_d.weights <- vector(mode = "list", length = tfpp_no_na_jwdc_knear4_np)
for (i in 1:tfpp_no_na_jwdc_knear4_np) {
  tfpp_no_na_jwdc_knear4_neighbours <- tfpp_no_na_jwdc_knear4$nn[i,]
  tfpp_no_na_jwdc_knear4_distances <- tfpp_no_na_jwdc_d.matrix[i, tfpp_no_na_jwdc_knear4_neighbours]
  tfpp_no_na_jwdc_knear4_d.weights[[i]] <- 1/tfpp_no_na_jwdc_knear4_distances
}
#also try '1/jwdc_knear4_distances^2' for inverse distance weighting (IDW)--it's also commonly used
tfpp_no_na_jwdc_knear4nb <- knn2nb(tfpp_no_na_jwdc_knear4)
tfpp_no_na_jwdc_spknear4IDW <- nb2listw(tfpp_no_na_jwdc_knear4nb, glist = tfpp_no_na_jwdc_knear4_d.weights)
#include 'style="C"' in above code (after specifying glist) to remove row-standardization--see "An Introduction to Mapping and Spatial Modelling in R" (Harris, 2013)
moran.test(tfpp_no_na_jwdc.xy$total_flowers_per_plant, tfpp_no_na_jwdc_spknear4IDW, alternative = "two.sided")
#Moran's I = 0.087760974; p-value = 0.3026 ==> NOT significant...4 'neighbours' performed worse than 3 or 5 for "JWDC"...(see test below)
#consider setting a cut-off distance for 'K nearest-neighbors' approach
#the derivation of the test (Cliff and Ord, 1981, p. 18) assumes that the weights matrix is symmetric; 
#for inherently non-symmetric matrices, such as k-nearest neighbour matrices, 'listw2U()' can be used to make the matrix symmetric


#EXAMPLE: tfpp_no_na_jwdc_knear3 ==> create spatial weights matrix and convert to 'weights list' form
tfpp_no_na_jwdc_knear3 <- knearneigh(tfpp_no_na_jwdc.xy, k=3, RANN=F)
tfpp_no_na_jwdc_knear3_np <- tfpp_no_na_jwdc_knear3$np
tfpp_no_na_jwdc_knear3_d.weights <- vector(mode = "list", length = tfpp_no_na_jwdc_knear3_np)
for (i in 1:tfpp_no_na_jwdc_knear3_np) {
  tfpp_no_na_jwdc_knear3_neighbours <- tfpp_no_na_jwdc_knear3$nn[i,]
  tfpp_no_na_jwdc_knear3_distances <- tfpp_no_na_jwdc_d.matrix[i, tfpp_no_na_jwdc_knear3_neighbours]
  tfpp_no_na_jwdc_knear3_d.weights[[i]] <- 1/tfpp_no_na_jwdc_knear3_distances
}
#also try '1/jwdc_knear3_distances^2' for inverse distance weighting (IDW)--it's also commonly used
tfpp_no_na_jwdc_knear3nb <- knn2nb(tfpp_no_na_jwdc_knear3)
tfpp_no_na_jwdc_spknear3IDW <- nb2listw(tfpp_no_na_jwdc_knear3nb, glist = tfpp_no_na_jwdc_knear3_d.weights)
#include 'style="C"' in above code (after specifying glist) to remove row-standardization--see "An Introduction to Mapping and Spatial Modelling in R" (Harris, 2013)
moran.test(tfpp_no_na_jwdc.xy$total_flowers_per_plant, tfpp_no_na_jwdc_spknear3IDW, alternative = "two.sided")
#Moran's I = 0.21931552; p-value = 0.03473 ==> SIGNIFICANT...3 'neighbours' performed better for "JWDC" (due to low plant density & small sample size)
#consider setting a cut-off distance for 'K nearest-neighbors' approach
#the derivation of the test (Cliff and Ord, 1981, p. 18) assumes that the weights matrix is symmetric; 
#for inherently non-symmetric matrices, such as k-nearest neighbour matrices, 'listw2U()' can be used to make the matrix symmetric


#EXAMPLE: tfpp_no_na_jwdc_knear2 ==> create spatial weights matrix and convert to 'weights list' form
tfpp_no_na_jwdc_knear2 <- knearneigh(tfpp_no_na_jwdc.xy, k=2, RANN=F)
tfpp_no_na_jwdc_knear2_np <- tfpp_no_na_jwdc_knear2$np
tfpp_no_na_jwdc_knear2_d.weights <- vector(mode = "list", length = tfpp_no_na_jwdc_knear2_np)
for (i in 1:tfpp_no_na_jwdc_knear2_np) {
  tfpp_no_na_jwdc_knear2_neighbours <- tfpp_no_na_jwdc_knear2$nn[i,]
  tfpp_no_na_jwdc_knear2_distances <- tfpp_no_na_jwdc_d.matrix[i, tfpp_no_na_jwdc_knear2_neighbours]
  tfpp_no_na_jwdc_knear2_d.weights[[i]] <- 1/tfpp_no_na_jwdc_knear2_distances
}
#also try '1/jwdc_knear2_distances^2' for inverse distance weighting (IDW)--it's also commonly used
tfpp_no_na_jwdc_knear2nb <- knn2nb(tfpp_no_na_jwdc_knear2)
tfpp_no_na_jwdc_spknear2IDW <- nb2listw(tfpp_no_na_jwdc_knear2nb, glist = tfpp_no_na_jwdc_knear2_d.weights)
#include 'style="C"' in above code (after specifying glist) to remove row-standardization--see "An Introduction to Mapping and Spatial Modelling in R" (Harris, 2013)
moran.test(tfpp_no_na_jwdc.xy$total_flowers_per_plant, tfpp_no_na_jwdc_spknear2IDW, alternative = "two.sided")
#Moran's I = 0.25921110; p-value = 0.02594 ==> SIGNIFICANT...2 'neighbours' performed better for "JWDC" (due to low plant density & small sample size)
#consider setting a cut-off distance for 'K nearest-neighbors' approach
#the derivation of the test (Cliff and Ord, 1981, p. 18) assumes that the weights matrix is symmetric; 
#for inherently non-symmetric matrices, such as k-nearest neighbour matrices, 'listw2U()' can be used to make the matrix symmetric


#EXAMPLE: tfpp_no_na_jwdc_knear1 ==> create spatial weights matrix and convert to 'weights list' form
tfpp_no_na_jwdc_knear1 <- knearneigh(tfpp_no_na_jwdc.xy, k=1, RANN=F)
tfpp_no_na_jwdc_knear1_np <- tfpp_no_na_jwdc_knear1$np
tfpp_no_na_jwdc_knear1_d.weights <- vector(mode = "list", length = tfpp_no_na_jwdc_knear1_np)
for (i in 1:tfpp_no_na_jwdc_knear1_np) {
  tfpp_no_na_jwdc_knear1_neighbours <- tfpp_no_na_jwdc_knear1$nn[i,]
  tfpp_no_na_jwdc_knear1_distances <- tfpp_no_na_jwdc_d.matrix[i, tfpp_no_na_jwdc_knear1_neighbours]
  tfpp_no_na_jwdc_knear1_d.weights[[i]] <- 1/tfpp_no_na_jwdc_knear1_distances
}
#also try '1/jwdc_knear1_distances^2' for inverse distance weighting (IDW)--it's also commonly used
tfpp_no_na_jwdc_knear1nb <- knn2nb(tfpp_no_na_jwdc_knear1)
tfpp_no_na_jwdc_spknear1IDW <- nb2listw(tfpp_no_na_jwdc_knear1nb, glist = tfpp_no_na_jwdc_knear1_d.weights)
#include 'style="C"' in above code (after specifying glist) to remove row-standardization--see "An Introduction to Mapping and Spatial Modelling in R" (Harris, 2013)
moran.test(tfpp_no_na_jwdc.xy$total_flowers_per_plant, tfpp_no_na_jwdc_spknear1IDW, alternative = "two.sided")
#Moran's I = 0.39313336; p-value = 0.007865 ==> SIGNIFICANT...1 'neighbour' performed better for "JWDC" (due to low plant density & small sample size)
#consider setting a cut-off distance for 'K nearest-neighbors' approach
#the derivation of the test (Cliff and Ord, 1981, p. 18) assumes that the weights matrix is symmetric; 
#for inherently non-symmetric matrices, such as k-nearest neighbour matrices, 'listw2U()' can be used to make the matrix symmetric




#determine a distance range for Moran's I by computing a correlogram ==> pop = "JWDC" & variable = "total_flowers_per_plant"
#see https://gdmdata.com/media/documents/handouts/2017ASA_FarmToTable_Spatial_correlation.pdf for tutorial/syntax
tfpp.0.5.clg <- correlog(tfpp_no_na_jwdc.xy$x_meters, tfpp_no_na_jwdc.xy$y_meters, tfpp_no_na_jwdc.xy$total_flowers_per_plant, increment=0.5, resamp=500, quiet=TRUE)
plot(tfpp.0.5.clg) #why does this correlogram look so messed up? consider limiting x axis to 20 meters
plot(tfpp.0.5.clg, xlim=c(0,20))

tfpp.0.75.clg <- correlog(tfpp_no_na_jwdc.xy$x_meters, tfpp_no_na_jwdc.xy$y_meters, tfpp_no_na_jwdc.xy$total_flowers_per_plant, increment=0.75, resamp=500, quiet=TRUE)
plot(tfpp.0.75.clg) #why does this correlogram look so messed up? consider limiting x axis to 20 meters
plot(tfpp.0.75.clg, xlim=c(0,20))

tfpp.1.clg <- correlog(tfpp_no_na_jwdc.xy$x_meters, tfpp_no_na_jwdc.xy$y_meters, tfpp_no_na_jwdc.xy$total_flowers_per_plant, increment=1, resamp=500, quiet=TRUE)
plot(tfpp.1.clg) #why does this correlogram look so messed up? consider limiting x axis to 20 meters
plot(tfpp.1.clg, xlim=c(0,20))


#determine a distance range for Moran's I by computing a correlogram ==> pop = "PS" & variable = "total_flowers_per_plant"
#see https://gdmdata.com/media/documents/handouts/2017ASA_FarmToTable_Spatial_correlation.pdf for tutorial/syntax
ps.tfpp.0.5.clg <- correlog(tfpp_no_na_ps.xy$x_meters, tfpp_no_na_ps.xy$y_meters, tfpp_no_na_ps.xy$total_flowers_per_plant, increment=0.5, resamp=500, quiet=TRUE)
plot(ps.tfpp.0.5.clg) #this correlogram looks right

ps.tfpp.0.75.clg <- correlog(tfpp_no_na_ps.xy$x_meters, tfpp_no_na_ps.xy$y_meters, tfpp_no_na_ps.xy$total_flowers_per_plant, increment=0.75, resamp=500, quiet=TRUE)
plot(ps.tfpp.0.75.clg) #this correlogram looks right

ps.tfpp.1.clg <- correlog(tfpp_no_na_ps.xy$x_meters, tfpp_no_na_ps.xy$y_meters, tfpp_no_na_ps.xy$total_flowers_per_plant, increment=1, resamp=500, quiet=TRUE)
plot(ps.tfpp.1.clg) #this correlogram looks right




#EXAMPLE: Global Moran's I (calculated w/ 'ape' package) for 'total_flowers_per_plant' in "JWDC"
#employs IDW matrix (but could try other methods)
#may need to standardize by row for intuitive visualizations, subsequent LISA statistics, etc. 
#may rely on assumption of normality
#may be inappropriate for applications NOT involving phylogenetic trees
#may require edge correction
Moran.I(tfpp_no_na_jwdc.xy$total_flowers_per_plant, tfpp_no_na_jwdc.dists.inv, alternative = "two.sided")
#Moran's I = 0.2301471; p-value = 0.004875865 ==> SIGNIFICANT
#should this--or any other Moran's I test--be two-sided?

#EXAMPLE: Moran Scatterplot for 'total_flowers_per_plant' in "JWDC"
#repeat example for k nearest-neighbours = 1-9
moran.plot(tfpp_no_na_jwdc.xy$total_flowers_per_plant, tfpp_no_na_jwdc_spknear10IDW)
#scale x & y axes for interpretation (i.e., same increments, same dimensions) 
#may need to row-standardize, but I think it already is...
#may violate assumptions
#reference http://rstudio-pubs-static.s3.amazonaws.com/5934_41bf20e3f3a046b2871e2cd2759af01a.html for plot syntax




#EXAMPLE: tfpp_no_na_ps_knear10 ==> create spatial weights matrix and convert to 'weights list' form
tfpp_no_na_ps_knear10 <- knearneigh(tfpp_no_na_ps.xy, k=10, RANN=F)
tfpp_no_na_ps_knear10_np <- tfpp_no_na_ps_knear10$np
tfpp_no_na_ps_knear10_d.weights <- vector(mode = "list", length = tfpp_no_na_ps_knear10_np)
for (i in 1:tfpp_no_na_ps_knear10_np) {
  tfpp_no_na_ps_knear10_neighbours <- tfpp_no_na_ps_knear10$nn[i,]
  tfpp_no_na_ps_knear10_distances <- tfpp_no_na_ps_d.matrix[i, tfpp_no_na_ps_knear10_neighbours]
  tfpp_no_na_ps_knear10_d.weights[[i]] <- 1/tfpp_no_na_ps_knear10_distances
}
#also try '1/ps_knear10_distances^2' for inverse distance weighting (IDW)--it's also commonly used
tfpp_no_na_ps_knear10nb <- knn2nb(tfpp_no_na_ps_knear10)
tfpp_no_na_ps_spknear10IDW <- nb2listw(tfpp_no_na_ps_knear10nb, glist = tfpp_no_na_ps_knear10_d.weights)
#include 'style="C"' in above code (after specifying glist) to remove row-standardization--see "An Introduction to Mapping and Spatial Modelling in R" (Harris, 2013)
moran.test(tfpp_no_na_ps.xy$total_flowers_per_plant, tfpp_no_na_ps_spknear10IDW, alternative = "two.sided")
#Moran's I = 0.311536243; p-value = 2.51e-13 ==> SIGNIFICANT (probably b/c of higher plant density & increased sample size of "PS")
#the derivation of the test (Cliff and Ord, 1981, p. 18) assumes that the weights matrix is symmetric; 
#for inherently non-symmetric matrices, such as k-nearest neighbour matrices, 'listw2U()' can be used to make the matrix symmetric


#EXAMPLE: tfpp_no_na_ps_knear9 ==> create spatial weights matrix and convert to 'weights list' form
tfpp_no_na_ps_knear9 <- knearneigh(tfpp_no_na_ps.xy, k=9, RANN=F)
tfpp_no_na_ps_knear9_np <- tfpp_no_na_ps_knear9$np
tfpp_no_na_ps_knear9_d.weights <- vector(mode = "list", length = tfpp_no_na_ps_knear9_np)
for (i in 1:tfpp_no_na_ps_knear9_np) {
  tfpp_no_na_ps_knear9_neighbours <- tfpp_no_na_ps_knear9$nn[i,]
  tfpp_no_na_ps_knear9_distances <- tfpp_no_na_ps_d.matrix[i, tfpp_no_na_ps_knear9_neighbours]
  tfpp_no_na_ps_knear9_d.weights[[i]] <- 1/tfpp_no_na_ps_knear9_distances
}
#also try '1/ps_knear9_distances^2' for inverse distance weighting (IDW)--it's also commonly used
tfpp_no_na_ps_knear9nb <- knn2nb(tfpp_no_na_ps_knear9)
tfpp_no_na_ps_spknear9IDW <- nb2listw(tfpp_no_na_ps_knear9nb, glist = tfpp_no_na_ps_knear9_d.weights)
#include 'style="C"' in above code (after specifying glist) to remove row-standardization--see "An Introduction to Mapping and Spatial Modelling in R" (Harris, 2013)
moran.test(tfpp_no_na_ps.xy$total_flowers_per_plant, tfpp_no_na_ps_spknear9IDW, alternative = "two.sided")
#Moran's I = 0.305956370; p-value = 5.381e-12 ==> SIGNIFICANT (probably b/c of higher plant density & increased sample size of "PS")
#the derivation of the test (Cliff and Ord, 1981, p. 18) assumes that the weights matrix is symmetric; 
#for inherently non-symmetric matrices, such as k-nearest neighbour matrices, 'listw2U()' can be used to make the matrix symmetric


#EXAMPLE: tfpp_no_na_ps_knear8 ==> create spatial weights matrix and convert to 'weights list' form
tfpp_no_na_ps_knear8 <- knearneigh(tfpp_no_na_ps.xy, k=8, RANN=F)
tfpp_no_na_ps_knear8_np <- tfpp_no_na_ps_knear8$np
tfpp_no_na_ps_knear8_d.weights <- vector(mode = "list", length = tfpp_no_na_ps_knear8_np)
for (i in 1:tfpp_no_na_ps_knear8_np) {
  tfpp_no_na_ps_knear8_neighbours <- tfpp_no_na_ps_knear8$nn[i,]
  tfpp_no_na_ps_knear8_distances <- tfpp_no_na_ps_d.matrix[i, tfpp_no_na_ps_knear8_neighbours]
  tfpp_no_na_ps_knear8_d.weights[[i]] <- 1/tfpp_no_na_ps_knear8_distances
}
#also try '1/ps_knear8_distances^2' for inverse distance weighting (IDW)--it's also commonly used
tfpp_no_na_ps_knear8nb <- knn2nb(tfpp_no_na_ps_knear8)
tfpp_no_na_ps_spknear8IDW <- nb2listw(tfpp_no_na_ps_knear8nb, glist = tfpp_no_na_ps_knear8_d.weights)
#include 'style="C"' in above code (after specifying glist) to remove row-standardization--see "An Introduction to Mapping and Spatial Modelling in R" (Harris, 2013)
moran.test(tfpp_no_na_ps.xy$total_flowers_per_plant, tfpp_no_na_ps_spknear8IDW, alternative = "two.sided")
#Moran's I = 0.325571423; p-value = 2.093e-12 ==> SIGNIFICANT (probably b/c of higher plant density & increased sample size of "PS")
#the derivation of the test (Cliff and Ord, 1981, p. 18) assumes that the weights matrix is symmetric; 
#for inherently non-symmetric matrices, such as k-nearest neighbour matrices, 'listw2U()' can be used to make the matrix symmetric


#EXAMPLE: tfpp_no_na_ps_knear7 ==> create spatial weights matrix and convert to 'weights list' form
tfpp_no_na_ps_knear7 <- knearneigh(tfpp_no_na_ps.xy, k=7, RANN=F)
tfpp_no_na_ps_knear7_np <- tfpp_no_na_ps_knear7$np
tfpp_no_na_ps_knear7_d.weights <- vector(mode = "list", length = tfpp_no_na_ps_knear7_np)
for (i in 1:tfpp_no_na_ps_knear7_np) {
  tfpp_no_na_ps_knear7_neighbours <- tfpp_no_na_ps_knear7$nn[i,]
  tfpp_no_na_ps_knear7_distances <- tfpp_no_na_ps_d.matrix[i, tfpp_no_na_ps_knear7_neighbours]
  tfpp_no_na_ps_knear7_d.weights[[i]] <- 1/tfpp_no_na_ps_knear7_distances
}
#also try '1/ps_knear7_distances^2' for inverse distance weighting (IDW)--it's also commonly used
tfpp_no_na_ps_knear7nb <- knn2nb(tfpp_no_na_ps_knear7)
tfpp_no_na_ps_spknear7IDW <- nb2listw(tfpp_no_na_ps_knear7nb, glist = tfpp_no_na_ps_knear7_d.weights)
#include 'style="C"' in above code (after specifying glist) to remove row-standardization--see "An Introduction to Mapping and Spatial Modelling in R" (Harris, 2013)
moran.test(tfpp_no_na_ps.xy$total_flowers_per_plant, tfpp_no_na_ps_spknear7IDW, alternative = "two.sided")
#Moran's I = 0.286225286; p-value = 3.558e-09 ==> SIGNIFICANT (probably b/c of higher plant density & increased sample size of "PS")
#the derivation of the test (Cliff and Ord, 1981, p. 18) assumes that the weights matrix is symmetric; 
#for inherently non-symmetric matrices, such as k-nearest neighbour matrices, 'listw2U()' can be used to make the matrix symmetric


#EXAMPLE: tfpp_no_na_ps_knear6 ==> create spatial weights matrix and convert to 'weights list' form
tfpp_no_na_ps_knear6 <- knearneigh(tfpp_no_na_ps.xy, k=6, RANN=F)
tfpp_no_na_ps_knear6_np <- tfpp_no_na_ps_knear6$np
tfpp_no_na_ps_knear6_d.weights <- vector(mode = "list", length = tfpp_no_na_ps_knear6_np)
for (i in 1:tfpp_no_na_ps_knear6_np) {
  tfpp_no_na_ps_knear6_neighbours <- tfpp_no_na_ps_knear6$nn[i,]
  tfpp_no_na_ps_knear6_distances <- tfpp_no_na_ps_d.matrix[i, tfpp_no_na_ps_knear6_neighbours]
  tfpp_no_na_ps_knear6_d.weights[[i]] <- 1/tfpp_no_na_ps_knear6_distances
}
#also try '1/ps_knear6_distances^2' for inverse distance weighting (IDW)--it's also commonly used
tfpp_no_na_ps_knear6nb <- knn2nb(tfpp_no_na_ps_knear6)
tfpp_no_na_ps_spknear6IDW <- nb2listw(tfpp_no_na_ps_knear6nb, glist = tfpp_no_na_ps_knear6_d.weights)
#include 'style="C"' in above code (after specifying glist) to remove row-standardization--see "An Introduction to Mapping and Spatial Modelling in R" (Harris, 2013)
moran.test(tfpp_no_na_ps.xy$total_flowers_per_plant, tfpp_no_na_ps_spknear6IDW, alternative = "two.sided")
#Moran's I = 0.274612786; p-value = 6.886e-08 ==> SIGNIFICANT (probably b/c of higher plant density & increased sample size of "PS")
#the derivation of the test (Cliff and Ord, 1981, p. 18) assumes that the weights matrix is symmetric; 
#for inherently non-symmetric matrices, such as k-nearest neighbour matrices, 'listw2U()' can be used to make the matrix symmetric


#EXAMPLE: tfpp_no_na_ps_knear5 ==> create spatial weights matrix and convert to 'weights list' form
tfpp_no_na_ps_knear5 <- knearneigh(tfpp_no_na_ps.xy, k=5, RANN=F)
tfpp_no_na_ps_knear5_np <- tfpp_no_na_ps_knear5$np
tfpp_no_na_ps_knear5_d.weights <- vector(mode = "list", length = tfpp_no_na_ps_knear5_np)
for (i in 1:tfpp_no_na_ps_knear5_np) {
  tfpp_no_na_ps_knear5_neighbours <- tfpp_no_na_ps_knear5$nn[i,]
  tfpp_no_na_ps_knear5_distances <- tfpp_no_na_ps_d.matrix[i, tfpp_no_na_ps_knear5_neighbours]
  tfpp_no_na_ps_knear5_d.weights[[i]] <- 1/tfpp_no_na_ps_knear5_distances
}
#also try '1/ps_knear5_distances^2' for inverse distance weighting (IDW)--it's also commonly used
tfpp_no_na_ps_knear5nb <- knn2nb(tfpp_no_na_ps_knear5)
tfpp_no_na_ps_spknear5IDW <- nb2listw(tfpp_no_na_ps_knear5nb, glist = tfpp_no_na_ps_knear5_d.weights)
#include 'style="C"' in above code (after specifying glist) to remove row-standardization--see "An Introduction to Mapping and Spatial Modelling in R" (Harris, 2013)
moran.test(tfpp_no_na_ps.xy$total_flowers_per_plant, tfpp_no_na_ps_spknear5IDW, alternative = "two.sided")
#Moran's I = 0.260736081; p-value = 1.545e-06 ==> SIGNIFICANT (probably b/c of higher plant density & increased sample size of "PS")
#the derivation of the test (Cliff and Ord, 1981, p. 18) assumes that the weights matrix is symmetric; 
#for inherently non-symmetric matrices, such as k-nearest neighbour matrices, 'listw2U()' can be used to make the matrix symmetric


#EXAMPLE: tfpp_no_na_ps_knear4 ==> create spatial weights matrix and convert to 'weights list' form
tfpp_no_na_ps_knear4 <- knearneigh(tfpp_no_na_ps.xy, k=4, RANN=F)
tfpp_no_na_ps_knear4_np <- tfpp_no_na_ps_knear4$np
tfpp_no_na_ps_knear4_d.weights <- vector(mode = "list", length = tfpp_no_na_ps_knear4_np)
for (i in 1:tfpp_no_na_ps_knear4_np) {
  tfpp_no_na_ps_knear4_neighbours <- tfpp_no_na_ps_knear4$nn[i,]
  tfpp_no_na_ps_knear4_distances <- tfpp_no_na_ps_d.matrix[i, tfpp_no_na_ps_knear4_neighbours]
  tfpp_no_na_ps_knear4_d.weights[[i]] <- 1/tfpp_no_na_ps_knear4_distances
}
#also try '1/ps_knear4_distances^2' for inverse distance weighting (IDW)--it's also commonly used
tfpp_no_na_ps_knear4nb <- knn2nb(tfpp_no_na_ps_knear4)
tfpp_no_na_ps_spknear4IDW <- nb2listw(tfpp_no_na_ps_knear4nb, glist = tfpp_no_na_ps_knear4_d.weights)
#include 'style="C"' in above code (after specifying glist) to remove row-standardization--see "An Introduction to Mapping and Spatial Modelling in R" (Harris, 2013)
moran.test(tfpp_no_na_ps.xy$total_flowers_per_plant, tfpp_no_na_ps_spknear4IDW, alternative = "two.sided")
#Moran's I = 0.194853075; p-value = 0.0008862 ==> SIGNIFICANT (probably b/c of higher plant density & increased sample size of "PS")
#the derivation of the test (Cliff and Ord, 1981, p. 18) assumes that the weights matrix is symmetric; 
#for inherently non-symmetric matrices, such as k-nearest neighbour matrices, 'listw2U()' can be used to make the matrix symmetric


#EXAMPLE: tfpp_no_na_ps_knear3 ==> create spatial weights matrix and convert to 'weights list' form
tfpp_no_na_ps_knear3 <- knearneigh(tfpp_no_na_ps.xy, k=3, RANN=F)
tfpp_no_na_ps_knear3_np <- tfpp_no_na_ps_knear3$np
tfpp_no_na_ps_knear3_d.weights <- vector(mode = "list", length = tfpp_no_na_ps_knear3_np)
for (i in 1:tfpp_no_na_ps_knear3_np) {
  tfpp_no_na_ps_knear3_neighbours <- tfpp_no_na_ps_knear3$nn[i,]
  tfpp_no_na_ps_knear3_distances <- tfpp_no_na_ps_d.matrix[i, tfpp_no_na_ps_knear3_neighbours]
  tfpp_no_na_ps_knear3_d.weights[[i]] <- 1/tfpp_no_na_ps_knear3_distances
}
#also try '1/ps_knear3_distances^2' for inverse distance weighting (IDW)--it's also commonly used
tfpp_no_na_ps_knear3nb <- knn2nb(tfpp_no_na_ps_knear3)
tfpp_no_na_ps_spknear3IDW <- nb2listw(tfpp_no_na_ps_knear3nb, glist = tfpp_no_na_ps_knear3_d.weights)
#include 'style="C"' in above code (after specifying glist) to remove row-standardization--see "An Introduction to Mapping and Spatial Modelling in R" (Harris, 2013)
moran.test(tfpp_no_na_ps.xy$total_flowers_per_plant, tfpp_no_na_ps_spknear3IDW, alternative = "two.sided")
#Moran's I = 0.138667015; p-value = 0.0337 ==> SIGNIFICANT (probably b/c of higher plant density & increased sample size of "PS")
#the derivation of the test (Cliff and Ord, 1981, p. 18) assumes that the weights matrix is symmetric; 
#for inherently non-symmetric matrices, such as k-nearest neighbour matrices, 'listw2U()' can be used to make the matrix symmetric


#EXAMPLE: tfpp_no_na_ps_knear2 ==> create spatial weights matrix and convert to 'weights list' form
tfpp_no_na_ps_knear2 <- knearneigh(tfpp_no_na_ps.xy, k=2, RANN=F)
tfpp_no_na_ps_knear2_np <- tfpp_no_na_ps_knear2$np
tfpp_no_na_ps_knear2_d.weights <- vector(mode = "list", length = tfpp_no_na_ps_knear2_np)
for (i in 1:tfpp_no_na_ps_knear2_np) {
  tfpp_no_na_ps_knear2_neighbours <- tfpp_no_na_ps_knear2$nn[i,]
  tfpp_no_na_ps_knear2_distances <- tfpp_no_na_ps_d.matrix[i, tfpp_no_na_ps_knear2_neighbours]
  tfpp_no_na_ps_knear2_d.weights[[i]] <- 1/tfpp_no_na_ps_knear2_distances
}
#also try '1/ps_knear2_distances^2' for inverse distance weighting (IDW)--it's also commonly used
tfpp_no_na_ps_knear2nb <- knn2nb(tfpp_no_na_ps_knear2)
tfpp_no_na_ps_spknear2IDW <- nb2listw(tfpp_no_na_ps_knear2nb, glist = tfpp_no_na_ps_knear2_d.weights)
#include 'style="C"' in above code (after specifying glist) to remove row-standardization--see "An Introduction to Mapping and Spatial Modelling in R" (Harris, 2013)
moran.test(tfpp_no_na_ps.xy$total_flowers_per_plant, tfpp_no_na_ps_spknear2IDW, alternative = "two.sided")
#Moran's I = 0.244152073; p-value = 0.001854 ==> SIGNIFICANT (probably b/c of higher plant density & increased sample size of "PS")
#the derivation of the test (Cliff and Ord, 1981, p. 18) assumes that the weights matrix is symmetric; 
#for inherently non-symmetric matrices, such as k-nearest neighbour matrices, 'listw2U()' can be used to make the matrix symmetric


#EXAMPLE: tfpp_no_na_ps_knear1 ==> create spatial weights matrix and convert to 'weights list' form
tfpp_no_na_ps_knear1 <- knearneigh(tfpp_no_na_ps.xy, k=1, RANN=F)
tfpp_no_na_ps_knear1_np <- tfpp_no_na_ps_knear1$np
tfpp_no_na_ps_knear1_d.weights <- vector(mode = "list", length = tfpp_no_na_ps_knear1_np)
for (i in 1:tfpp_no_na_ps_knear1_np) {
  tfpp_no_na_ps_knear1_neighbours <- tfpp_no_na_ps_knear1$nn[i,]
  tfpp_no_na_ps_knear1_distances <- tfpp_no_na_ps_d.matrix[i, tfpp_no_na_ps_knear1_neighbours]
  tfpp_no_na_ps_knear1_d.weights[[i]] <- 1/tfpp_no_na_ps_knear1_distances
}
#also try '1/ps_knear1_distances^2' for inverse distance weighting (IDW)--it's also commonly used
tfpp_no_na_ps_knear1nb <- knn2nb(tfpp_no_na_ps_knear1)
tfpp_no_na_ps_spknear1IDW <- nb2listw(tfpp_no_na_ps_knear1nb, glist = tfpp_no_na_ps_knear1_d.weights)
#include 'style="C"' in above code (after specifying glist) to remove row-standardization--see "An Introduction to Mapping and Spatial Modelling in R" (Harris, 2013)
moran.test(tfpp_no_na_ps.xy$total_flowers_per_plant, tfpp_no_na_ps_spknear1IDW, alternative = "two.sided")
#Moran's I = 0.271720712; p-value = 0.008955 ==> SIGNIFICANT (probably b/c of higher plant density & increased sample size of "PS")
#the derivation of the test (Cliff and Ord, 1981, p. 18) assumes that the weights matrix is symmetric; 
#for inherently non-symmetric matrices, such as k-nearest neighbour matrices, 'listw2U()' can be used to make the matrix symmetric




#EXAMPLE: Global Moran's I (calculated w/ 'ape' package) for 'total_flowers_per_plant' in "PS"
#employs IDW matrix (but could try other methods)
#may need to standardize by row for intuitive visualizations, subsequent LISA statistics, etc. 
#may rely on assumption of normality
#may be inappropriate for applications NOT involving phylogenetic trees
#may require edge correction
Moran.I(tfpp_no_na_ps.xy$total_flowers_per_plant, tfpp_no_na_ps.dists.inv, alternative = "two.sided")
#Moran's I = 0.1470482; p-value = 6.006263e-09 ==> SIGNIFICANT
#should this--or any other Moran's I test--be two-sided?

#EXAMPLE: Moran Scatterplot for 'total_flowers_per_plant' in "PS"
#repeat example for k nearest-neighbours = 1-9
moran.plot(tfpp_no_na_ps.xy$total_flowers_per_plant, tfpp_no_na_ps_spknear10IDW)
#scale x & y axes for interpretation (i.e., same increments, same dimensions) 
#may need to row-standardize, but I think it already is...
#may violate assumptions
#reference http://rstudio-pubs-static.s3.amazonaws.com/5934_41bf20e3f3a046b2871e2cd2759af01a.html for plot syntax




#EXAMPLE: jwdc_dnear01 ==> 
#repeat example below for mult. "JWDC" and "PS" distance classes (probably circles, not rings)
#employ edge correction
#employ randomization/MC methods for non-normality
#employ other LISA statistics, local Moran's I, Gi, and Gi* (if appropriate)
#employ Bonferroni correction for family-wise error (or other similar method)--see Anselin (1995) & corresponding notes
