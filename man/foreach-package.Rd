\name{foreach-package}
\alias{foreach-package}
\docType{package}
\title{
The Foreach Package
}
\description{
The foreach package provides a new looping construct for executing
R code repeatedly.  The main reason for using the foreach package
is that it supports parallel execution.  The foreach package can
be used with a variety of different parallel computing systems,
include NetWorkSpaces and snow.  In addition, foreach can be
used with iterators, which allows the data to specified in a very
flexible way.
}
\details{
Further information is available in the following help topics:
\tabular{ll}{
\code{foreach} \tab Specify the variables to iterate over\cr
\code{\%do\%} \tab Execute the R expression sequentially\cr
\code{\%dopar\%} \tab Execute the R expression using the currently registered backend\cr
}

For a complete list of functions with individual help pages,
use \code{library(help="foreach")}.
}
\keyword{package}
