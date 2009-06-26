# a simple parallel random forest

library(foreach)
library(randomForest)

niter <- function(n, chunks) {
  nextEl <- function() {
    if (chunks <= 0 || n <= 0) stop('StopIteration')
    m <- ceiling(n / chunks)
    n <<- n - m
    chunks <<- chunks - 1
    m
  }
  structure(list(nextElem=nextEl), class=c('niter', 'iter'))
}

nextElem.niter <- function(obj) obj$nextElem()

# generate the inputs
x <- matrix(runif(500), 100)
y <- gl(2, 50)

# split the total number of trees by the number of parallel execution workers
nw <- getDoParWorkers()
cat(sprintf('Running with %d worker(s)\n', nw))
intree <- niter(1000, nw)

# run the randomForest jobs, and combine the results
rf <- foreach(ntree=intree, .combine=combine, .packages='randomForest') %dopar%
  randomForest(x, y, ntree=ntree)

# print the result
print(rf)
