% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/estimate-functions.R
\name{estimateAccount}
\alias{estimateAccount}
\title{Estimate demographic account and models from multiple noisy datasets.}
\usage{
estimateAccount(y, system, observation, datasets, filename = NULL,
  nBurnin = 1000, nSim = 1000, nChain = 4, nThin = 1, parallel = TRUE,
  outfile = NULL, nUpdateMax = 50, verbose = FALSE, useC = TRUE)
}
\arguments{
\item{y}{An object of class
\code{\link[dembase:DemographicAccount-class]{DemographicAccount}}.}

\item{system}{A list of objects of class \code{\linkS4class{SpecModel}}
specifying models for the demographic series.}

\item{observation}{A list of objects of class
\code{\linkS4class{SpecModel}} specifying models for the datasets.}

\item{datasets}{A named list of objects of class
\code{\link[dembase:DemographicArray-class]{Counts}}.}

\item{filename}{The name of a file where output is collected.}

\item{nBurnin}{Number of iteration discarded before recording begins.}

\item{nSim}{Number of iterations carried out during recording.}

\item{nChain}{Number of parallel chains used in simulations.}

\item{nThin}{Thinning interval.}

\item{parallel}{Logical.  If \code{TRUE} (the default), parallel processing
is used.}

\item{outfile}{Where to direct the ‘stdout’ and ‘stderr’ connection
output from the workers when parallel processing.  Passed to function
\code{[parallel]{makeCluster}}.}

\item{nUpdateMax}{Maximum number of iterations completed before releasing
memory.  If running out of memory, setting a lower value than the default
may help.}

\item{verbose}{Logical.  If \code{TRUE} (the default) a message is
printed at the end of the calculations.}

\item{useC}{Logical.  If \code{TRUE} (the default), the calculations
are done in C.  Setting \code{useC} to \code{FALSE} may be useful
for debugging.}
}
\description{
Infer the contents of a demographic account, and fit models
describing series within the account, using multiple noisy datasets.
\emph{The function is still under construction.}
}
\references{
Bryant, J., Graham, P. Bayesian demographic accounts:
Subnational population estimation using multiple datasources. 2013.
\emph{Bayesian Analysis}
}
\seealso{
\code{\link{estimateModel}}, \code{\link{estimateCounts}}
}
