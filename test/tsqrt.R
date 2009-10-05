library(doSMP)

n <- 2000  # length of vectors
m <- 8000  # number of vectors

cat('starting workers...\n')
w <- startWorkers(workerCount=4, verbose=TRUE)

cat('registering workers...\n')
registerDoSMP(w)

print(tempdir())

cat('executing foreach...\n')
r <- foreach(x=irnorm(n, mean=1000, count=m)) %dopar% sqrt(x)

cat('stopping workers...\n')
stopWorkers(w)

cat('finished\n')
