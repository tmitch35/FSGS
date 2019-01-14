# Metadata
## Contact Information
Thomas "Wes" Mitchell, Ph.D. student in Ecology and Evolutionary Biology    
Department of Biological Sciences, Kent State University  
PO Box 5190, Kent, Ohio, 44242-0001   
email: tmitch35@kent.edu    
phone: +1(336)279-0211 
## Methods
## Project Data files
### Master Excel Files
1. Fall_2018_PS_JWDC_Tissue_Collection.xlsx
    * **contents:** inventory of collected tissue broken down by type (e.g., flowers, buds, leaves, pollen) and plant_id; comments section contains data on plant damage (at time of tissue collection), which are highlighted in yellow   
    * **last updated:** 01/08/2019
    * **previous versions:** NA
    * **file status:** incomplete; missing values for plant_id 74 (i.e., num_buds_collected, total_flowers_used) 
2. Fall_2018_JWDC_Raw_Spatial_Data.xlsx
    * **contents:** raw distances and angles measured during plant mapping at Jennings Woods--Daryl Carver's land; comments section contains data on plant damage (at time of plant mapping), which are highlighted in yellow
    * **last updated:** 01/09/2019
    * **previous versions:** NA
    * **file status:** complete
3. Fall_2018_JWDC_Coordinate_Calculations.xlsx
    * **contents:** calculations, conversions, and x/y coordinates (of mapped plants in "JWDC") standardized to fixed point A
    * **last updated:** 01/06/2019
    * **previous versions:** NA
    * **file status:** complete
4. Fall_2018_PS_Raw_Spatial_Data.xlsx
    * **contents:** raw distances measured during plant mapping at Pearson Metropark; comments section contains data on aggregate assignments, which are written in red font
    * **last updated:** 01/08/2019
    * **previous versions:** NA
    * **file status:** complete
5. Fall_2018_PS_Coordinate_Calculations.xlsx
    * **contents:** conversions and x/y coordinates (of mapped plants in "PS") relative to fixed point E
    * **last updated:** 01/08/2019
    * **previous versions:** NA
    * **file status:** complete
6. Fall_2018_PS_JWDC_Plant_Phenotyping.xlsx
    * **contents:** number of fruits collected, total fruit and flower remnants on inflorescence, plant height measurements, and plant damage (i.e., presence/absence, damage type); comments section contains data on plant damage (at time of plant phenotyping) plus damage comments from Fall_2018_PS_JWDC_Tissue_Collection.xlsx and Fall_2018_JWDC_Raw_Spatial_Data.xlsx; all damage comments are highlighted in yellow   
    * **last updated:** 01/08/2019
    * **previous versions:** NA
    * **file status:** incomplete; missing/conflicting data in several cells (i.e., those highlighted in yellow or red)   
7. Fall_2018_PS_JWDC_Error_Analysis.xlsx
    * **contents:** calculated inter-plant distances, error statistics (error in meters, absolute value of error in meters, percent error), and error locations (i.e., intra- versus extra-aggregate error) for JWDC and PS
    * **last updated:** 01/14/2019
    * **previous versions:** NA
    * **file status:** complete
8. Fall_2018_PS_JWDC_Miscellaneous_Info.xlsx
    * **contents:** population GPS coordinates, standardized fixed point x/y coordinates, conversion factors used in JWDC coordinate calculations, soil sample locations, and aggregate marker x/y coordinates
    * **last updated:** 01/08/2019
    * **previous versions:** NA
    * **file status:** complete
### Files for Analysis
9.  (copy & paste name here)
    * **contents:**
    * **last updated:**
    * **previous versions:**
    * **file status:**  
10. (copy & paste name here)
    * **contents:**
    * **last updated:**
    * **previous versions:**
    * **file status:** 
11. (copy & paste name here)
    * **contents:**
    * **last updated:**
    * **previous versions:**
    * **file status:** 
12. (copy & paste name here)
    * **contents:**
    * **last updated:**
    * **previous versions:**
    * **file status:**  
13. (copy & paste name here)
    * **contents:**
    * **last updated:**
    * **previous versions:**
    * **file status:**  
14. (copy & paste name here)
    * **contents:**
    * **last updated:**
    * **previous versions:**
    * **file status:**  
### Column Headers (Variables): Definitions and Descriptions
Column Header (Variable) | Definition | Description 
------------------------ | :--------- | :----------
`abs_val_xy1_calc_minus_xy2_calc_m` | absolute value of (inter-plant distances calculated from primary coordinates minus inter-plant distances calculated from secondary coordinates) | estimates precision of inter-plant distance calculations from fixed points 1 & 2 (when both available); calculated difference (in meters) without sign
`abs_val_xy1_error_m` | absolute value of error (in meters) of inter-plant distances calculated from primary coordinates | calculated as ABS("xy1_calc_reference_distance_m" - "dist_to_reference_m"); calculated error (meters) without sign
`abs_val_xy2_error_m` | absolute value of error (in meters) of inter-plant distances calculated from secondary coordinates | calculated as ABS("xy2_calc_reference_distance_m" - "dist_to_reference_m"); calculated error (meters) without sign
`actual_xval_of_sample_site_meters` | 
`actual_yval_of_sample_site_meters` | 
`aggregate_id` | 
`aggregate_members` | 
`avg_azimuth_from_fp1_mils` | 
`avg_azimuth_from_fp1_rads` | 
`avg_azimuth_from_fp2_mils` | 
`avg_azimuth_from_fp2_rads` | 
`avg_dist_from_fp1_ft` | 
`avg_dist_from_fp1_m` | 
`avg_dist_from_fp2_ft` | 
`avg_dist_from_fp2_m` | 
`avg_dist_from_spatial_pt_ft` | 
`avg_dist_from_spatial_pt_m` | 
`azimuth_from_fp1_mils` | 
`azimuth_from_fp2_mils` | 
`azimuth_from_spatial_pt_mils` |   
`azimuth_from_spatial_pt_rads` | 
`azimuth_to_fp1_mils` | 
`azimuth_to_fp2_mils` | 
`comments_error_analysis` | 
`comments_jwdc_plant_mapping` | 
`comments_plant_phenotyping` | 
`comments_ps_plant_mapping` | 
`comments_quick_conversion_reference` | 
`comments_raw_data_and_conversion_math` | 
`comments_soil_sample_locations` | 
`comments_tissue_collection` | 
`damage_type` | 
`dist_to_reference_ft` | 
`dist_to_reference_m` | 
`dist1_from_fp1_ft` | 
`dist1_from_fp2_ft` | 
`dist1_from_spatial_pt_ft` | 
`dist2_from_fp1_ft` | 
`dist2_from_fp2_ft` | 
`dist2_from_spatial_pt_ft` | 
`dist3_from_fp1_ft` | 
`dist3_from_fp2_ft` | 
`dist3_from_spatial_pt_ft` | 
`error_within_aggregate` | 
`fixed_points_used` | 
`flowers_for_pollen` | 
`flowers_preserved` | 
`fp1` | 
`fp2` | 
`fruits_collected_b` | 
`fruits_collected_m` | 
`fruits_collected_t` | 
`inflorescence_length_cm` | 
`inflorescence_length_in` | 
`intra_aggregate_x_adj_in` | 
`intra_aggregate_x_adj_m` | 
`intra_aggregate_y_adj_in` | 
`intra_aggregate_y_adj_m` | 
`iphone_lat_1` | 
`iphone_lat_2` | 
`iphone_long_1` | 
`iphone_long_2` | 
`num_buds_collected` | 
`num_leaves_collected` | 
`num_pollen_tubes` | 
`plant_damaged` | 
`plant_id` | 
`point_type` | 
`pop` | 
`reference_id` | 
`sex` | 
`spatial_pt` | 
`spatial_pt_mapped_in_R` | 
`spatial_pt_sampled` | 
`stem_length_cm` | 
`stem_length_in` | 
`supplemental_dist_to_reference_in` | 
`tot_plant_height_cm` | 
`tot_plant_height_in` | 
`total_flowers_used` | 
`total_fruit_flower_remnants` | 
`total_fruits_collected` | 
`x_feet` | 
`x_from_spatial_pt_to_reference_m` | 
`x_inches` | 
`x_meters` | 
`x_meters_newest_version` | 
`x1_meters` | 
`x1_meters_fp1_specific` | 
`x1_meters_standardized_to_fpa` | 
`x2_meters` | 
`x2_meters_fp2_specific` | 
`x2_meters_standardized_to_fpa` | 
`xval_conversion_B_to_A_meters` | 
`xval_conversion_C_to_A_meters` | 
`xval_conversion_D_to_A_meters` | 
`xval_in_R_meters` | 
`xy1_calc_minus_xy2_calc_m` | 
`xy1_calc_reference_distance_m` | 
`xy1_error_m` | 
`xy1_percent_error` | 
`xy2_calc_reference_distance_m` | 
`xy2_error_m` | 
`xy2_percent_error` | 
`y_feet` | 
`y_from_spatial_pt_to_reference_m` | 
`y_inches` | 
`y_meters` | 
`y_meters_newest_version` | 
`y1_meters` | 
`y1_meters_fp1_specific` | 
`y1_meters_standardized_to_fpa` | 
`y2_meters` | 
`y2_meters_fp2_specific` | 
`y2_meters_standardized_to_fpa` | 
`yval_conversion_B_to_A_meters` | 
`yval_conversion_C_to_A_meters` | 
`yval_conversion_D_to_A_meters` | 
`yval_in_R_meters` | 
  
