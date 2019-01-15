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
    
### Column Headers Defined & Described 
Column Header (Variable) | Definition | Description 
:----------------------- | :--------- | :----------
`abs_val_xy1_calc_minus_xy2_calc_m` | absolute value of (inter-plant distances calculated from primary coordinates minus inter-plant distances calculated from secondary coordinates) | estimates precision of inter-plant distance calculations from fixed points 1 & 2 (when both available); calculated difference (in meters) without sign
`abs_val_xy1_error_m` | absolute value of error (in meters) of inter-plant distances calculated from primary coordinates | calculated as: ABS(`xy1_calc_reference_distance_m` - `dist_to_reference_m`); calculated error (meters) without sign
`abs_val_xy2_error_m` | absolute value of error (in meters) of inter-plant distances calculated from secondary coordinates | calculated as: ABS(`xy2_calc_reference_distance_m` - `dist_to_reference_m`); calculated error (meters) without sign
`actual_xval_of_sample_site_meters` | actual (i.e., more accurate) x value (in meters) of soil sample location | contains the actual x value (in meters) of the soil sample location; x values for '**full aggregates**' = x values for aggregate markers; x values for '**partial aggregates**' = average x value of included `plant_id`'s; x values for '**plant**' = `x1_meters` (i.e., primary x coordinate)
`actual_yval_of_sample_site_meters` | actual (i.e., more accurate) y value (in meters) of soil sample location | contains the actual y value (in meters) of the soil sample location; y values for '**full aggregates**' = y values for aggregate markers; y values for '**partial aggregates**' = average y value of included `plant_id`'s; y values for '**plant**' = `y1_meters` (i.e., primary y coordinate)
`aggregate_id` | identity of aggregate occupied by plant | *a priori* designation made in the field; plants separated by less than 6 inches were said to be part of the same aggregate; aggegates in "JWDC" were marked with 10 inch nails, and all distances and angles were measured relative to these markers; aggregates in "PS" were not marked 
`aggregate_members` | all members (`plant_id`'s) belonging to a given aggregate | contains a list or range of `plant_id`'s that comprise a given aggregate; aggregates themselves are labeled as '**JW[number]**' for "JWDC" and '**PS[number]**' for "PS"
`avg_azimuth_from_fp1_mils` | average azimuth measured from fixed point 1 to a given plant_id in Mils | contains azimuths values (not ranges) measured from fixed point 1 to a given `plant_id` (Mils); converts all "azimuth ranges" into single values for coordinate calculations
`avg_azimuth_from_fp1_rads` | average azimuth (radians) from fixed point 1 to a given `plant_id` | calculated as: `avg_azimuth_from_fp1_mils` * 2Pi/6400; converts angular measurements Mils to radians
`avg_azimuth_from_fp2_mils` | average azimuth measured from fixed point 2 to a given `plant_id` in Mils | contains azimuths values (not ranges) measured from fixed point 2 to a given `plant_id` (Mils); converts all "azimuth ranges" into single values for coordinate calculations
`avg_azimuth_from_fp2_rads` | average azimuth (radians) from fixed point 2 to a given `plant_id` | calculated as: `avg_azimuth_from_fp2_mils` * 2Pi/6400; converts angular measurements Mils to radians
`avg_dist_from_fp1_ft` | average distance (ft) from fixed point 1 to a given `plant_id` | calculated as: (`dist1_from_fp1_ft` + `dist2_from_fp1_ft` + `dist3_from_fp1_ft`) / 3
`avg_dist_from_fp1_m` | average distance (meters) from fixed point 1 to a given `plant_id` | converts `avg_dist_from_fp1_ft`  to meters using Excel's CONVERT funtion 
`avg_dist_from_fp2_ft` | average distance (ft) from fixed point 2 to a given `plant_id` | calculated as: (`dist1_from_fp2_ft` + `dist2_from_fp2_ft` + `dist3_from_fp2_ft`) / 3
`avg_dist_from_fp2_m` | average distance (meters) from fixed point 2 to a given `plant_id` | converts `avg_dist_from_fp2_ft`  to meters using Excel's CONVERT funtion 
`avg_dist_from_spatial_pt_ft` | average distance (ft) from a given `spatial_pt` (fixed point) to its respective `reference_id` (fixed point) | calculated as: (`dist1_from_spatial_pt_ft` + `dist2_from_spatial_pt_ft` + `dist3_from_spatial_pt_ft`) / 3
`avg_dist_from_spatial_pt_m` | average distance (m) from a given `spatial_pt` (fixed point) to its respective `reference_id` (fixed point) | calculated from `avg_dist_from_spatial_pt_ft` values using Excel's CONVERT formula
`azimuth_from_fp1_mils` | azimuth measured from fixed point 1 to a given `plant_id` in Mils | contains values (or ranges) of azimuths measured from fixed point 1 to a given `plant_id` (Mils); all azimuths were measured using a lensatic compass
`azimuth_from_fp2_mils` | azimuth measured from fixed point 2 to a given `plant_id` in Mils | contains values (or ranges) of azimuths measured from fixed point 2 to a given `plant_id` (Mils); all azimuths were measured using a lensatic compass
`azimuth_from_spatial_pt_mils` | azimuth measured from a given `spatial_pt` (fixed point) to its respective `reference_id` (fixed point) in Mils | contains values of azimuths (in Mils) measured from a given `spatial_pt` (fixed point) to its respective `reference_id` (fixed point); all azimuths were measured using a lensatic compass
`azimuth_from_spatial_pt_rads` | azimuth measured from a given `spatial_pt` (fixed point) to its respective `reference_id` (fixed point) in radians | contains values of azimuths (in radians) measured from a given `spatial_pt` (fixed point) to its respective `reference_id` (fixed point); calculated as: `azimuth_from_spatial_pt_mils` * 2Pi/6400
`azimuth_to_fp1_mils` | reverse azimuth (in Mils) measured from a given `plant_id` to fixed point 1 | most cells contain '**NA**' for this column; reverse azimuth values were used to validate compass precision in the field; values should differ from `avg_azimuth_from_fp1_mils` by exactly 3200 Mils
`azimuth_to_fp2_mils` | reverse azimuth (in Mils) measured from a given `plant_id` to fixed point 2 | all cells contain '**NA**' for this column; no reverse azimuths were recorded for fixed point 2
`comments_error_analysis` | comments pertaining to error analysis of mapped plants | includes comments added for clarity and highlights any noteworthy exceptions
`comments_jwdc_plant_mapping` | comments pertaining to plant mapping in "JWDC" | includes notes taken in the field (i.e., during plant mapping) and comments added later on; quotation marks indicate verbatim transcriptions
`comments_plant_phenotyping` | comments pertaining to plant phenotyping | includes notes taken in the field (i.e., during plant phenotypig) and comments added later on; quotation marks indicate verbatim transcriptions
`comments_ps_plant_mapping` | comments pertaining to plant mapping in "PS" | includes notes taken in the field (i.e., during plant mapping) and comments added later on; quotation marks indicate verbatim transcriptions
`comments_quick_conversion_reference` | comments pertaining to "Quick Conversion Reference" sheet of Fall_2018_PS_JWDC_Miscellaneous_Info.xlsx | includes comments added for clarity and important reminders
`comments_raw_data_and_conversion_math` | comments pertaining to "Raw Data & Conversion Math" sheet of Fall_2018_PS_JWDC_Miscellaneous_Info.xlsx | includes comments added for clarity and important reminders
`comments_soil_sample_locations` | comments pertaining to "Soil Sample Locations" sheet of Fall_2018_PS_JWDC_Miscellaneous_Info.xlsx | includes comments added for clarity and important reminders
`comments_tissue_collection` | comments pertaining to tissue collection | includes notes taken in the field (i.e., during tissue collection) and comments added later on; quotation marks indicate verbatim transcriptions
`damage_type` | damage type (if '**Y**' for `plant_damaged`) | **HERBIVORY** = plant damaged by herbivores (e.g., deer); **BROKE (IN TACT)** = plant stem broken, but still in tact; **BROKEN (NOT INTACT)** = plant stem completed broken off; **BROKEN (DEAD)** = plant dead with broken stem; **MOWED** = plant mowed by Daryl Carver as of 09/23/2018; question marks following `damage_type` values (e.g., **MOWED?**, **HERBIVORY?**) indicate a degree of uncertainty concerning the source of observed damage 
`dist_to_reference_ft` | distance measured (ft) from a given `plant_id` to its `reference_id` | includes inter-plant distaces measured (in feet) using an open reel measuring tape; distances recorded to the nearest 0.01 ft; used in error calculations
`dist_to_reference_m` | distance measured (m) from a given `plant_id` to its `reference_id` | calculated from `dist_to_reference_ft` and `supplemental_dist_to_reference_in` (whichever applied) using Excel's CONVERT function; values represent inter-plant measurements in meters 
`dist1_from_fp1_ft` | first distance measure (ft) from fixed point 1 to a given `plant_id` | first of three laser distance measurements (in feet) from fixed point 1 to a given `plant_id`
`dist1_from_fp2_ft` | first distance measure (ft) from fixed point 2 to a given `plant_id` | first of three laser distance measurements (in feet) from fixed point 2 to a given `plant_id`
`dist1_from_spatial_pt_ft` | first distance measure (ft) from a given `spatial_pt` (fixed point) to its respective `reference_id` (fixed point) | first of three laser distance measurements (measured in feet) from a given `spatial_pt` (fixed point) to its respective `reference_id` (fixed point)
`dist2_from_fp1_ft` | second distance measure (ft) from fixed point 1 to a given `plant_id` | second of three laser distance measurements (in feet) from fixed point 1 to a given `plant_id`
`dist2_from_fp2_ft` | second distance measure (ft) from fixed point 2 to a given `plant_id` | second of three laser distance measurements (in feet) from fixed point 2 to a given `plant_id`
`dist2_from_spatial_pt_ft` | second distance measure (ft) from a given `spatial_pt` (fixed point) to its respective `reference_id` (fixed point) | second of three laser distance measurements (measured in feet) from a given `spatial_pt` (fixed point) to its respective `reference_id` (fixed point)
`dist3_from_fp1_ft` | third distance measure (ft) from fixed point 1 to a given `plant_id` | third of three laser distance measurements (in feet) from fixed point 1 to a given `plant_id`
`dist3_from_fp2_ft` | third distance measure (ft) from fixed point 2 to a given `plant_id` | third of three laser distance measurements (in feet) from fixed point 2 to a given `plant_id`
`dist3_from_spatial_pt_ft` | third distance measure (ft) from a given `spatial_pt` (fixed point) to its respective `reference_id` (fixed point) | third of three laser distance measurements (measured in feet) from a given `spatial_pt` (fixed point) to its respective `reference_id` (fixed point)
`error_within_aggregate` | error calculated within an aggregate? (**Y**, **N**, **NA**) | partitions error from "JWDC" into intra-aggregate versus extra-aggregate error, as aggregates in that population were fine-mapped to increase the accuracy of measurements in dense plant clusters; error from "PS" assigned '**NA**' for this column, as aggregates in that population were not mapped differently from the population at large 
`fixed_points_used` | name(s) of fixed point(s) used for distance and angle measurements | contains name(s) of fixed point(s) used for distance and angle measurements; fixed points '**A**', '**B**', '**C**', and '**D**' = population "JWDC"; fixed point '**E**' =  population "PS"; multiple fixed points used for plants in "JWDC" are listed  alphabetically and separated by commas
`flowers_for_pollen` | number of flowers used exclusively for pollen collection | indicates the number of flowers used (i.e., removed) exclusively for pollen collection; ranges from 0–3 per plant
`flowers_preserved` | number of preserved flower specimens collected per `plant_id` | indicates the number of preserved flower specimens collected for floral morphology measurements; ranges from 0–2 per plant
`fp1` | fixed point 1 | name of first fixed point used for distance and angle measurements; corresponds to first fixed point listed in `fixed_points_used`
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
  
