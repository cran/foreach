# a simple parallel random forest

library(foreach)
library(randomForest)

# generate the inputs
x <- matrix(runif(500), 100)
y <- gl(2, 50)

# split the total number of trees by the number of parallel execution workers
nw <- getDoParWorkers()
cat(sprintf('Running with %d worker(s)\n', nw))
vntree <- rep(ceiling(1000 / nw), nw)  # this can give some extra trees

# run the randomForest jobs, and combine the results
rf <- foreach(ntree=vntree, .combine=combine, .packages='randomForest') %dopar%
  randomForest(x, y, ntree=ntree)

# print the result
print(rf)
