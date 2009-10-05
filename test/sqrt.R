library(foreach)

n <- 4000  # length of vectors
m <- 40000  # number of vectors

pkgs <- c('doSMP', 'doMC', 'doSNOW', 'doNWS')
pkgs <- c('doSMP')
stat <- sapply(pkgs, function(pkg) {
  tryCatch({
    suppressWarnings(require(pkg, character.only=TRUE))
  },
  error=function(e) {
    FALSE
  })
})
pkgs <- pkgs[stat]

nw <- as.integer(Sys.getenv('WORKERCOUNT', '4'))

# Run the benchmark for all backends that we have
for (pkg in pkgs) {
  # create a "workers" object and register it
  if (pkg == 'doMC') {
    registerDoMC(nw)
  } else if (pkg == 'doSMP') {
    w <- startWorkers(workerCount=nw)
    registerDoSMP(w)
  } else if (pkg == 'doSNOW') {
    w <- makeSOCKcluster(nw)
    registerDoSNOW(w)
  } else if (pkg == 'doNWS') {
    w <- sleigh(workerCount=nw)
    registerDoNWS(w)
  } else {
    stop('unrecognized backend')
  }

  cat(sprintf('Running with %s version %s using %d workers\n',
              getDoParName(), getDoParVersion(), getDoParWorkers()))

  tm <- system.time({
    foreach(x=irnorm(n, mean=1000, count=m), .combine='+',
            .inorder=FALSE) %dopar% sqrt(x)
  })[3]

  cat(sprintf('Benchmark ran in %f seconds\n', tm))

  # shutdown the "workers" object
  if (pkg == 'doMC') {
    # nothing to do
  } else if (pkg == 'doSMP') {
    stopWorkers(w)
  } else if (pkg == 'doSNOW') {
    stopCluster(w)
  } else if (pkg == 'doNWS') {
    stopSleigh(w)
  } else {
    stop('unrecognized backend')
  }
}
