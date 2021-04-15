
library(multtest)

# Data has to be in the form where rows corresponding to variables (hypotheses) and columns to observations. 
# If this is not the case, transpose the data
data = t(data)

# For one-vs.-all analyses, cluster labels are transformed into binary labels by assigning value of 1 to respective cluster and 0 to others. 
# For example, Cluster 0 vs all:
labels_cl0 = as.factor(ifelse(labels == 'cluster0',1,0))

# Run the testing with welch t-statistic
resP<-mt.minP(data,labels_cl0, test='t', B=20000)  #  Welch t statistic and 20 000 permutations.

#Save the results, vector resP$adjp is the vector of adjusted p-values, reporteds in the manuscript. 
# The adjp was subsequently adjusted also for number of comparisons and reported as well.
