#set wd and import 2018 spatial data for jennings woods (d.c.) and pearson 
getwd()
setwd("/Users/thomasmitchell/Desktop/Research/spatial_coordinates_2018")
pearson <- read.csv("~/Desktop/Research/spatial_coordinates_2018/PS_2018_X_Y_COORDINATES_FOR_R.csv")
jenningswoods <- read.csv("~/Desktop/Research/spatial_coordinates_2018/JWDC_2018_X_Y_COORDINATES_FOR_R.csv")

#subset populations to exclude coordinates measured in feet
ps <- pearson[c(-3,-4)]
jwdc_metric <- jenningswoods[c(-3,-4)]
jwdc <- na.omit(jwdc_metric)

#call packages required for plotting coordinates
library(sp)
library(lattice)
library(latticeExtra)
library(RColorBrewer)
library(ggplot2)

#attempt to make a ggplot of jennings woods
j <- ggplot(jwdc, aes(x_meters, y_meters, shape = soil_sampled)) +
  geom_point(aes(colour = factor(sex),size = factor(soil_sampled)))

#manually set desired colors, shapes, and sizes
cols <- c("F" = "coral1", "H" = "deepskyblue3", "GM" = "darkorchid1", "NF" = "gold", "U" = "seagreen3")
shapes <- c("Yes" = 4, "No" = 16)
sizes <- c("Yes" = 6, "No" = 1.5)

#plot the data, format labels, fix aesthetics, etc.
j + ggtitle(label = "Jenning's Woods (Daryl Carver's Land), Fall 2018", subtitle = "Spatial Distribution of Plants, Sexes, and Soil Collection Sites") + 
  theme(plot.title = element_text(hjust = 0.5),plot.subtitle = element_text(hjust = 0.5)) + 
  theme(panel.background = element_rect(fill = "grey96", colour = "grey50")) + 
  scale_colour_manual(values = cols,breaks = c("F","H","GM","NF","U")) + scale_shape_manual(values = shapes) + 
  scale_size_manual(values = sizes) + guides(size=F) +
  guides(colour = guide_legend(title = "Plant Sex",reverse = F,order = 1),shape = guide_legend(title = "Soil Sampled?",reverse = T,order = 2)) + 
  xlab("Meters from Fixed Point A (W to E)") + ylab ("Meters from Fixed Point A (S to N)")

#attempt to make a "zoomed in" ggplot of females w/n jennings woods
jsmall <- ggplot(jwdc, aes(x_meters, y_meters, shape = soil_sampled)) +
  geom_point(aes(colour = factor(sex),size = factor(soil_sampled))) + xlim(-45,-30) + ylim(-30,-20)

jsmall + ggtitle(label = "Jenning's Woods (Daryl Carver's Land), Fall 2018", subtitle = "A 'Zoomed In' View of a Large Female Aggregate") + 
  theme(plot.title = element_text(hjust = 0.5),plot.subtitle = element_text(hjust = 0.5)) + 
  theme(panel.background = element_rect(fill = "grey96", colour = "grey50")) + 
  scale_colour_manual(values = cols,breaks = c("F","H","GM","NF","U")) + scale_shape_manual(values = shapes) + 
  scale_size_manual(values = sizes) + guides(size=F) + 
  guides(colour = guide_legend(title = "Plant Sex",reverse = F,order = 1),shape = guide_legend(title = "Soil Sampled?",reverse = T,order = 2)) + 
  xlab("Meters from Fixed Point A (W to E)") + ylab ("Meters from Fixed Point A (S to N)")

#attempt to make a ggplot of Pearson 
p <- ggplot(ps, aes(x_meters, y_meters, shape = soil_sampled)) +
  geom_point(aes(colour = factor(sex),size = factor(soil_sampled)))

#manually set desired colors, shapes, and sizes (probably redundant)
cols <- c("F" = "coral1", "H" = "deepskyblue3", "GM" = "darkorchid1", "NF" = "gold", "U" = "seagreen3")
shapes <- c("Yes" = 4, "No" = 16)
sizes <- c("Yes" = 6, "No" = 1.5)

#plot the data, format labels, fix aesthetics, etc.
p + ggtitle(label = "Pearson Metropark, Fall 2018", subtitle = "Spatial Distribution of Plants, Sexes, and Soil Collection Sites") + 
  theme(plot.title = element_text(hjust = 0.5),plot.subtitle = element_text(hjust = 0.5)) + 
  theme(panel.background = element_rect(fill = "grey96", colour = "grey50")) + 
  scale_colour_manual(values = cols) + scale_shape_manual(values = shapes) + scale_size_manual(values = sizes) + 
  guides(size=F) + guides(colour = guide_legend(title = "Plant Sex",reverse = F,order = 1),shape = guide_legend(title = "Soil Sampled?",reverse = T,order = 2)) + 
  xlab("Meters from Fixed Point A (W to E)") + ylab ("Meters from Fixed Point A (S to N)")

#attempt to make a "zoomed out" ggplot of pearson for size comparisons
pbig <- ggplot(ps, aes(x_meters, y_meters, shape = soil_sampled)) +
  geom_point(aes(colour = factor(sex),size = factor(soil_sampled))) + xlim(-53.83674,3.25567) + ylim(-28.98482,8.71979)

pbig + ggtitle(label = "Pearson Metropark, Fall 2018", subtitle = "A 'Zoomed Out' View of Pearson") + 
  theme(plot.title = element_text(hjust = 0.5),plot.subtitle = element_text(hjust = 0.5)) + 
  theme(panel.background = element_rect(fill = "grey96", colour = "grey50")) + 
  scale_colour_manual(values = cols) + scale_shape_manual(values = shapes) + scale_size_manual(values = sizes) + 
  guides(size=F) + guides(colour = guide_legend(title = "Plant Sex",reverse = F,order = 1),shape = guide_legend(title = "Soil Sampled?",reverse = T,order = 2)) + 
  xlab("Meters from Fixed Point A (W to E)") + ylab ("Meters from Fixed Point A (S to N)")




#set wd and import 2018 data on coordinates, plant height, flower production, and damage for jennings woods (d.c.) and pearson
getwd()
setwd("/Users/thomasmitchell/Desktop/Research/spatial_coordinates_2018")
flowers_height_damage <- read.csv("~/Desktop/Research/FSGS_fall_2018/FLOWERS_HEIGHT_DAMAGE_01_06_19.csv")
str(flowers_height_damage)
summary(flowers_height_damage)

#need to clean up extra columns (i.e., X, X.1, X.2, etc.) and rows (see NA's below plant 358) in "flowers_height_damage"
#need to sort out all of the NA's

#exploratory plots
plot(total_flowers_per_plant~pop, data=flowers_height_damage)
  #total flowers per plant vs. pop: lone pedicels and other flower remnants + remaining/collected fruits + flowers used for pollen viability and floral morphology measures
  #this assumes I couldn't detect areas (points of attachment) where flowers were previously collected/removed; likely "adds in" some unnessary flowers (i.e., overestimates total flowers per plant) 

plot(total_fruit_flower_remnants~pop, data=flowers_height_damage)
  #total fruit flower remnants vs. pop: lone pedicels and other flower remnants + remaining/collected fruits
  #this assumes I detected all areas (points of attachment) where flowers were previously collected/removed
  #check p-values to see if adding/leaving off "total flowers used" makes any difference (see first plot) 

plot(total_flowers_per_plant~sex, data=flowers_height_damage)
  #same as first plot, but with plant sex as the independent variable (instead of population) 

plot(total_fruit_flower_remnants~sex, data=flowers_height_damage)
  #same as second plot, but with plant sex as the independent variable (instead of population) 
  #check p-values to see if adding/leaving off "total flowers used" makes any difference 

plot(tot_plant_height_cm~pop, data=flowers_height_damage)
  #plant height as a function of population

plot(tot_plant_height_cm~sex, data=flowers_height_damage)
  #plant height as a function of sex

#plot total flowers per plant as a function of sex w/n each population
#plot plant height and damage info as a function of sex w/n each population 
#plot total flowers per plant for females across populations, then repeat w/ hermaphrodites
#plot plant heights and damage info for females across populations, then repeat w/ hermaphrodites
#run some tests to check out significant correlations...




#set wd and import 2018 data on plant mapping error
getwd()
setwd("/Users/thomasmitchell/Desktop/Research/spatial_coordinates_2018")
mapping_error <- read.csv("~/Desktop/Research/FSGS_fall_2018/MAPPING_ERROR_01_08_19.csv")
summary(mapping_error)
#mean "xy1_error_m" = 0.0075160; min: -0.4692413; max: 0.6843583
#mean "abs_val_xy1_error_m" = 0.030203

jwdc_error <- subset(mapping_error, pop=="JWDC")
summary(jwdc_error)
#mean "xy1_error_m" = 0.020075; min: -0.4692413; max: 0.6843583
#mean "abs_val_xy1_error_m" = 0.0667342

jwdc_intra_aggregate_error <- subset(jwdc_error, error_within_aggregate=="Y")
summary(jwdc_intra_aggregate_error)
#mean "xy1_error_m" = -0.004887; min: -0.071706; max: 0.012017
#mean "abs_val_xy1_error_m" = 0.0088702

jwdc_outside_aggregate_error <- subset(jwdc_error, error_within_aggregate=="N")
summary(jwdc_outside_aggregate_error)
#mean "xy1_error_m" = 0.03934; min: -0.46924; max: 0.68436
#mean "abs_val_xy1_error_m" = 0.1114011

ps_error <- subset(mapping_error, pop=="PS")
summary(ps_error)
#mean "xy1_error_m" = -0.0005633; min: -0.0298832; max: 0.0284582
#mean "abs_val_xy1_error_m" = 0.006701

#entering alternate interplant (measured) distances from field notebook to lower error in JWDC aggregates
#data entered and saved as "UPDATED_MAPPING_ERROR_01_09_19.csv"
#importing new (updated) file
getwd()
setwd("/Users/thomasmitchell/Desktop/Research/spatial_coordinates_2018")
updated_error <- read.csv("~/Desktop/Research/FSGS_fall_2018/UPDATED_MAPPING_ERROR_01_09_19.csv")
summary(updated_error)
#mean "xy1_error_m" = 0.0084110; min: -0.4692413; max: 0.6843583
#mean "abs_val_xy1_error_m" = 0.029150

#repeat subsetting (same as above) with updated data file
updated_jwdc_error <- subset(updated_error, pop=="JWDC")
summary(updated_jwdc_error)
#mean "xy1_error_m" = 0.022361; min: -0.4692413; max: 0.6843583
#mean "abs_val_xy1_error_m" = 0.06405

updated_jwdc_intra_aggregate_error <- subset(updated_jwdc_error, error_within_aggregate=="Y")
summary(updated_jwdc_intra_aggregate_error)
#mean "xy1_error_m" = 2.518e-05; min: -8.582e-03; max: 1.088e-02 
#mean "abs_val_xy1_error_m" = 0.002967 

updated_jwdc_outside_aggregate_error <- subset(updated_jwdc_error, error_within_aggregate=="N")
summary(updated_jwdc_outside_aggregate_error)
#mean "xy1_error_m" = 0.04031; min: -0.4692413; max: 0.6843583 
#mean "abs_val_xy1_error_m" = 0.1131279; NOTE: number is higher than previous version's b/c of change in "error_within_aggregate"'s sample size)

updated_ps_error <- subset(updated_error, pop=="PS")
summary(updated_ps_error)
#mean "xy1_error_m" = -0.0005633; min: -0.0298832; max: 0.0284582
#mean "abs_val_xy1_error_m" = 0.006701



#SPATIAL AUTOCORRELATION STUFF
library(ape)
library(spdep)
library(ncf)
library(lctools)

#read CSV file from earlier
flowers_height_damage <- read.csv("~/Desktop/Research/FSGS_fall_2018/FLOWERS_HEIGHT_DAMAGE_01_06_19.csv")

#subset data (plant id, population, sex, x/y coordinates, total flowers per plant, and plant height measurements)
tot_flowers_height <- flowers_height_damage[c(1,2,3,4,5,8,9,10,11)]
str(tot_flowers_height)
summary(tot_flowers_height)

#remove all NA's (real analysis needs to remove NA's separately) 
tot_fh_nona <- na.omit(tot_flowers_height)
tot_fh_nona
summary(tot_fh_nona)

#subset by population (avoids incorrect conflation of relative x/y coordinates)
jwdc_tot_fh_nona <- subset(tot_fh_nona, pop=="JWDC")
summary(jwdc_tot_fh_nona)

ps_tot_fh_nona <- subset(tot_fh_nona, pop=="PS")
summary(ps_tot_fh_nona)

#generate distance matrix for PS, take inverse of matrix values, and replace diagonal entries with zero
ps_tot_fh_nona.dists <- as.matrix(dist(cbind(ps_tot_fh_nona$x_meters, ps_tot_fh_nona$y_meters)))
ps_tot_fh_nona.dists.inv <- 1/ps_tot_fh_nona.dists
diag(ps_tot_fh_nona.dists.inv) <- 0

#look at first five rows & columns (of PS matrix) to verify code worked
ps_tot_fh_nona.dists.inv[1:5, 1:5]

#calculate Moran's I for plant height at PS (uses 'APE' package)
Moran.I(ps_tot_fh_nona$tot_plant_height_cm, ps_tot_fh_nona.dists.inv)
#p-value = 1.202393e-05 (SIGNIFICANT)
#should this be a two-sided test?

#calculate Moran's I for total flowers per plant at PS (uses 'APE' package)
Moran.I(ps_tot_fh_nona$total_flowers_per_plant, ps_tot_fh_nona.dists.inv)
#p-value = 6.006263e-09 (SIGNIFICANT)
#should this be a two-sided test?

#generate distance matrix for JWDC, take inverse of matrix values, and replace diagonal entries with zero
jwdc_tot_fh_nona.dists <- as.matrix(dist(cbind(jwdc_tot_fh_nona$x_meters, jwdc_tot_fh_nona$y_meters)))
jwdc_tot_fh_nona.dists.inv <- 1/jwdc_tot_fh_nona.dists
diag(jwdc_tot_fh_nona.dists.inv) <- 0

#look at first five rows & columns (of JWDC matrix) to verify code worked
jwdc_tot_fh_nona.dists.inv[1:5, 1:5]

#calculate Moran's I for plant height at JWDC (uses 'APE' package)
Moran.I(jwdc_tot_fh_nona$tot_plant_height_cm, jwdc_tot_fh_nona.dists.inv)
#p-value = 5.507374e-05 (SIGNIFICANT)
#should this be a two-sided test?

#calculate Moran's I for total flowers per plant at JWDC (uses 'APE' package)
Moran.I(jwdc_tot_fh_nona$total_flowers_per_plant, jwdc_tot_fh_nona.dists.inv)
#p-value = 0.006126597 (SIGNIFICANT)
#should this be a two-sided test?




#EXAMPLE: TOTAL FLOWERS PER PLANT vs. INFLORESCENCE LENGTH 
#plotting relationship
plot(total_flowers_per_plant~inflorescence_length_cm,data=tot_fh_nona)
#original (untransformed) model
flowermod <- lm(total_flowers_per_plant~inflorescence_length_cm,data=tot_fh_nona)

#log-transformed model (trying to mitigate assumption violations below)
tot_fh_nona$lntotal_flowers_per_plant <- log(tot_fh_nona$total_flowers_per_plant)
lnflower.v.inflorescence <- lm(lntotal_flowers_per_plant~inflorescence_length_cm,data=tot_fh_nona)

#sqrt-transformed model (trying to mitigate assumption violations below)
tot_fh_nona$sqrttotal_flowers_per_plant <- sqrt(tot_fh_nona$total_flowers_per_plant)
sqrtflower.v.inflorescence <- lm(sqrttotal_flowers_per_plant~inflorescence_length_cm,data=tot_fh_nona)

#checking for assumptions: original model (i.e., no transformations)
shapiro.test(resid(flowermod))
par(mfrow=c(1,2)) 
plot(flowermod,which=c(1,2))
#assumptions violated (p-value = 2.499e-12)

#checking for assumptions: log transformation model
shapiro.test(resid(lnflower.v.inflorescence))
par(mfrow=c(1,2)) 
plot(flowermod,which=c(1,2))
#assumptions still violated (p-value = 0.01302); better than original & sqrt transformation
#maybe non-parametric tests would be more appropriate...

#checking for assumptions: sqrt transformation model
shapiro.test(resid(sqrtflower.v.inflorescence))
par(mfrow=c(1,2)) 
plot(flowermod,which=c(1,2))
#assumptions still violated (p-value = 2.725e-05); better than original but worse than log transformation
