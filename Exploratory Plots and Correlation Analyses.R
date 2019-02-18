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

#make plots to check for correlations among variables
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
#repeat example below for 'tfpp_no_na_jwdc_knear01' thru 'tfpp_no_na_jwdc_knear09'
#repeat example below for other columns of interest
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
#Moran's I = 0.07512508; p-value = 0.2766 ==> NOT significant...10 'neighbors' may be too many (due to low plant density & small sample size of "JWDC")
#consider setting a cut-off distance for 'K nearest-neighbors' approach
#the derivation of the test (Cliff and Ord, 1981, p. 18) assumes that the weights matrix is symmetric; 
#for inherently non-symmetric matrices, such as k-nearest neighbour matrices, 'listw2U()' can be used to make the matrix symmetric

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
moran.plot(tfpp_no_na_jwdc.xy$total_flowers_per_plant, tfpp_no_na_jwdc_spknear10IDW)
#scale x & y axes for interpretation (i.e., same increments, same dimensions) 
#may need to row-standardize, but I think it already is...
#may violate assumptions
#reference http://rstudio-pubs-static.s3.amazonaws.com/5934_41bf20e3f3a046b2871e2cd2759af01a.html for plot syntax

#EXAMPLE: tfpp_no_na_ps_knear10 ==> create spatial weights matrix and convert to 'weights list' form
#repeat example below for 'tfpp_no_na_ps_knear01' thru 'tfpp_no_na_jwdc_knear09'
#repeat example below for other columns of interest
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

#EXAMPLE: Global Moran's I (calculated w/ 'ape' package) for 'total_flowers_per_plant' in "PS"
#employs IDW matrix (but could try other methods)
#may need to standardize by row for intuitive visualizations, subsequent LISA statistics, etc. 
#may rely on assumption of normality
#may be inappropriate for applications NOT involving phylogenetic trees
#may require edge correction
Moran.I(tfpp_no_na_ps.xy$total_flowers_per_plant, tfpp_no_na_ps.dists.inv, alternative = "two.sided")
#Moran's I = 0.1470482; p-value = 6.006263e-09 ==> SIGNIFICANT
#should this--or any other Moran's I test--be two-sided?

#EXAMPLE: Moran Scatterplot for 'total_flowers_per_plant' in "JWDC"
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
