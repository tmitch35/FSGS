getwd()
setwd("/Users/thomasmitchell/Desktop/Research/FSGS_fall_2018")
practice_data <- read.csv("~/Desktop/Research/Fieldwork Spreadsheets/Fall 2018/Excel Files for Analysis/Fall_2018_Data_for_R_Practice.csv")

#subset data to include only females and hermaphrodites, removing row w/ unmapped individual 
practice_data[-c(101), ]
practice_data <- practice_data[-c(101), ]
fh_only <- subset(practice_data, sex=="H" | sex=="F")

#subset data by 'pop' to calculate x & y coordinate ranges
ps.fh.only <- subset(fh_only, pop=="PS")
summary(ps.fh.only)
#x_meters min (PS) = -5.1694
#x_meters max (PS) = -0.0889
#y_meters min (PS) = -1.39065
#y_meters max (PS) = 1.14300

jwdc.fh.only <- subset(fh_only, pop=="JWDC")
summary(jwdc.fh.only)
#x_meters min (JWDC) = -53.837
#x_meters max (JWDC) = 3.256
#y_meters min (JWDC) = -28.98
#y_meters max (JWDC) = 8.72


