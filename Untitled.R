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

