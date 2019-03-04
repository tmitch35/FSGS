###################################################################################################
####     Script for formatting Excel files into files that are compatible with Programita      ####
####           		                       Andrew C. Eagar                                     ####
###################################################################################################

setwd("C:\\Users\\Andrew\\Desktop\\Wes Point Pattern Data Formatting R Script")	# Set your directory to where you want your files written.

Tree_data = read.csv("C:/Users/Andrew/Desktop/Wes Point Pattern Data Formatting R Script/PPA Tree Data.csv", header = TRUE)	# Hardpath for my data set.

# This for loop will create files usable by Programita (Wiegand & Moloney, 2004; 2014). You can divide your data by plot and marking  of interest (e.g. juvenile or adult, AM tree or ECM tree).

Plots = unique(Tree_data$ï..Plot)	# Obtains number of unique plots for the for loop.

for (i in 1:length(Plots))		
	{                    				
		
		Plot_data = Tree_data[Tree_data$ï..Plot == Plots[i],]	# Trims the data down to only the plot of interest. Once the first plot is subdivided, the for loop proceeds to subdivide the data from the next plot in the unique list once the previous plot is written to a new file.
		
		# Add xmax, xmin values step here
		
		Subdata = Plot_data[,c(14,15,18,19)]	# Format plot data to include variables of interest (e.g. x coordinate, y coordinate, point type 1, point type 2, etc.).
		
		Subdata = cbind(Subdata,NA)	# Add an empty column to the data so the header (which will be 5 columns) lines up with the rest of the data (which is 4 columns and therefore needs a 5th to line up properly).
		
		Header = c(0,30,0,30,nrow(Subdata))	# Create header data for the Programita file. These files need a header with the dimensions of your study window and the number of rows in the file (here, a 0 x 30 unit window is used with a coordinate system from (0,0) to (30,30) and the specific number of rows included in the plot of interest).   
		
		Formatted_data = rbind(Header,Subdata) # Add the header that was just created to the top of the subdivided data
		
		write.table(Formatted_data, file = paste(Plots[i],".dat", sep = ""), sep = "\t", na = "", row.names = FALSE, col.names = FALSE) # Export the subdivided data as a .dat file for use in Programita. If .phy or others are needed as the extension, change the ".dat" part of the script accordingly. The directory specification is where these files will be written.
	}
# End

# For loop sans annotations

for (i in 1:length(Plots))		
	{                    				
		Plot_data = Tree_data[Tree_data$ï..Plot == Plots[i],]
			
		Subdata = Plot_data[,c(1,2,3,4)]
		
		Subdata = cbind(Subdata,NA)
		
		Header = c(0,30,0,30,nrow(Subdata))
		
		Formatted_data = rbind(Header,Subdata) 
		
		write.table(Formatted_data, file = paste(Plots[i],".dat", sep = ""), sep = "\t", na = "", row.names = FALSE, col.names = FALSE
	}
# End