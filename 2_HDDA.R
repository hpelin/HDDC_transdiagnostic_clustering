# R version 3.6.0 (2019-04-26)
# Platform: x86_64-redhat-linux-gnu (64-bit)
# Running under: Scientific Linux 7.8 (Nitrogen)
# attached base packages:stats, graphics, grDevices, utils, datasets, methods, base     
# other attached packages: OptimalCutpoints_1.1-4, pROC_1.16.1, optparse_1.6.2, HDclassif_2.1.0, MASS_7.3-51.6   

library(HDclassif)
library(caret)

# For one-vs.-all analyses, cluster labels are transformed into binary labels by assigning value of 1 to respective cluster and 0 to others. 

# For example, Cluster 0 vs all:
labels_cl0 = as.factor(ifelse(labels == 'cluster0',1,0))

# The prediction model was run 100 times on the discovery sample, each time on a separate random 70% vs. 30% split of training and test data, respectively. 
# Example of 1 run:
train.indices = createDataPartition(labels_cl0, p=0.7)
X.train = data[train.indices,]
Y.train = labels_cl0[train.indices, ]

X.test = data[-train.indices,]
Y.test = labels_cl0[train.indices, ]

# cv.glmnet was used to tune th λ. In each run, the λ minimizing the cross-validation error, i.e., maximizing the AUC (λmin)
model = hdda(data=X.train, cls = Y.train, model='AKBKQKDK')

# For details of the output, please see: ?hdda or Bouveyron C, Girard S, Schmid C. High-Dimensional Data Clustering. 2007. 
# Get predtions and check the metrics with roc() function from the pROC package
predictions = predict(model, X.test, y.test)

