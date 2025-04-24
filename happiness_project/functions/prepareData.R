
# a function for cleaning the world happiness dataset
prepareData <- function(happiness_data,
                        drop_countries_missing_2017_happiness = FALSE,
                        gini = c("gallup", "world bank"),
                        imputation = c("ffill", "interpolation")) {
  
  gini <- match.arg(gini)
  imputation <- match.arg(imputation)
  
  # handle countries missing 2017 happiness score
  if (drop_countries_missing_2017_happiness) {
    # remove countries that have missing happiness values in 2017
    countries_missing_2017_happiness <- happiness_data |> 
      filter(year == 2017) |>
      filter(is.na(happiness)) |>
      pull(country)
    happiness_data <- happiness_data |> 
      filter(!(country %in% countries_missing_2017_happiness))
  } 
  
  # decide which gini measure to use
  if (gini == "world bank") {
    # use gini_world_bank as gini measure
    happiness_data <- happiness_data |>
      # use gini_world_bank if it is not missing, otherwise use the average variable
      mutate(gini = if_else(!is.na(gini_world_bank), 
                            gini_world_bank, 
                            gini_world_bank_average)) |>
      select(-gini_world_bank, -gini_gallup, -gini_world_bank_average)
    
  } else if (gini == "gallup") {
    # use gini_gallup as gini measure
    happiness_data <- happiness_data |>
      rename(gini = gini_gallup) |>
      select(-gini_world_bank, -gini_world_bank_average)
  }
  
  if (imputation == "ffill") {
    happiness_data <- happiness_data |>
      group_by(country) |>
      fill(everything(), .direction = "downup")
  } else if (imputation == "interpolation") {
    happiness_data <- happiness_data |>
      group_by(country) |>
      mutate(across(where(is.numeric), ~ zoo::na.approx(., na.rm = FALSE))) 
    
  }
  
  
  return(happiness_data)
}
