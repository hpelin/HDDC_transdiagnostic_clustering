# R version 3.6.0 (2019-04-26)
# Platform: x86_64-redhat-linux-gnu (64-bit)
# Running under: Scientific Linux 7.8 (Nitrogen)
# attached base packages:stats, graphics, grDevices, utils, datasets, methods, base     
# other attached packages: OptimalCutpoints_1.1-4, pROC_1.16.1, optparse_1.6.2, glmnet_2.0-16, foreach_1.4.4, Matrix_1.2-18    

library(glmnet)
library(caret)

# For one-vs.-all analyses, cluster labels are transformed into binary labels by assigning value of 1 to respective cluster and 0 to others. 

# For example, Cluster 0 vs all:
labels_cl0 = as.factor(ifelse(labels == 'cluster0',1,0))

# To tune λ, the discovery sample was split 1000 times into 70% training and 30% test data, using stratification based on cluster labels. 

# Example of 1 run:
train.indices = createDataPartition(labels_cl0, p=0.7)
X.train = data[train.indices,]
Y.train = labels_cl0[train.indices, ]

X.test = data[-train.indices,]
Y.test = labels_cl0[train.indices, ]

# cv.glmnet was used to tune th λ. In each run, the λ minimizing the cross-validation error, i.e., maximizing the AUC (λmin)
model = cv.glmnet(X.train, Y.train, family = 'binomial', nfolds=3, type.measure='auc', alpha=1)
# For details of the output, please see: ?cv.glmnet or 

# Get predtions and check the metrics with optimal.cutpoints() function from the OptimalCutpoints package and roc() function from the pROC package
predictions = predict(model, newx = X.test, s="lambda.min", type = 'response')

