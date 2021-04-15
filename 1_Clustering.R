
# R version 3.6.0 (2019-04-26)
# Platform: x86_64-redhat-linux-gnu (64-bit)
# Running under: Scientific Linux 7.7 (Nitrogen)
# attached base packages: stats, graphics, grDevices, utils, datasets, methods, base     
# other attached packages: optparse_1.6.2, HDclassif_2.1.0, MASS_7.3-51.4  

library(HDclassif)
library(diceR)
library(flexclust)

run_clustering = function(data, perc, nrep, model='ALL'){
  
  #' @param data data to cluster
  #' @param perc percentage for data split
  #' @param model hddc parameter, indicating the models to be used. If 'ALL', all possible models will be used. For details type ?hddc or see Bouveyron C, Girard S, Schmid C. High-Dimensional Data Clustering. 2007. 
  #' @param nrep number of resampling/algorithm repetitions
  #' @return A list of nrep hddc models
  
  hddc_models_list = list()
  
  for (rep in 1:nrep){
    # Resample data
    p=round(perc*nrow(data))
    data_sample = data[sample(1:nrow(data), p, replace=F),]
    
    # Run hddc and save all the results for the analysis
    hddc_model = hddc(data_sample, model=model, K=1:15, itermax=500, criterion='ICL')
    hddc_models_list[[rep]] = hddc_model
  }
  return (hddc_models_list)
}

run_clustering_jackknife = function(data, model){
  
  #' @param data data to cluster
  #' @param model hddc parameter, indicating the models to be used. If 'ALL', all possible models will be used. For details type ?hddc or see Bouveyron C, Girard S, Schmid C. High-Dimensional Data Clustering. 2007. 
  #' @return A list of hddc models
  
  hddc_models_list = list()
  
  nrep = nrow(data)
  
  for (i in 1:nrep){

    # Run hddc and save all the results for the analysis
    hddc_model = hddc(data[-i,], model=model, K=1:15, itermax=500, criterion='ICL')
    hddc_models_list[[rep]] = hddc_model
  }
  return (hddc_models_list)
}

# --- MAIN --- #

# For details on the output of hddc function, please see ?hddc or Bouveyron C, Girard S, Schmid C. High-Dimensional Data Clustering. 2007. 
hddc_model$all_results

# Step 1: Choosing the  model
run_clustering(data, perc=0.8, model='ALL', nrep=100)

# Step2 : Choose the number of clusters:
run_clustering_jackknife(data, model='AKBKQKDK')

# Step3: Cluster solution from Jackknife runs
mvote = majority_voting(classes.K, is.relabelled = F) # For details see package diceR (Chiu D, Talhouk A. DiceR: An R package for class discovery using an ensemble driven approach. BMC Bioinformatics. 2018;19.)

# Step4: Stability solution
run_clustering(data, perc=0.95, model='AKBKQKDK', nrep=100)
# Rand and Jaccard indices function comPart from the pacakge flexclust can be used:
comp = comPart(labels_step3, labels_step4)


