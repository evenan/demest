% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/query-functions.R
\name{showModel}
\alias{showModel}
\title{Show final model specification.}
\usage{
showModel(filename)
}
\arguments{
\item{filename}{The name of the file where the output from the
\code{estimate} function is kept.}
}
\value{
\code{showModel} is called for its side effect, which is to print a
description of the model.
}
\description{
Show the complete specification model used by functions
\code{\link{estimateModel}}, \code{\link{estimateCounts}},
and \code{\link{estimateAccount}}, or by their prediction
counterparts such as \code{\link{predictModel}}.
}
\details{
When setting up models to be fitted by the estimation functions,
users typically only specify some of the details of the priors for
the main effects or interactions.  The remaining details are filled in
by the estimation functions, based on the input data.  Function
\code{showModel} can be used find out what choices the estimation
functions made.

To see the partial specification constructed by function
\code{\link{Model}}, print the model object (typically by typing
the name of the object at the console.)  See below for an example.
show \code{\link{fetch}}.

The \code{trunc-half-t(df, s^2, max)} in the printed results refers to a
truncated \code{\link[=halft-distn]{half-t}} distribution with \code{df}
degrees of freedom, scale \code{s^2}, and maximum value \code{max}.
}
\examples{
births <- demdata::nz.births.reg
popn <- demdata::nz.popn.reg
births <- Counts(births, dimscales = c(year = "Intervals"))
popn <- Counts(popn, dimscales = c(year = "Intervals"))
births <- subarray(births, year > 2005 & year < 2014)

filename.est <- tempfile()
filename.pred <- tempfile()

model <- Model(y ~ Poisson(mean ~ age * region + year),
               year ~ DLM(trend = NULL))

## model specification before estimateModel called
model

estimateModel(model = model,
              y = births,
              exposure = popn,
              filename = filename.est,
              nBurnin = 5,
              nSim = 5,
              nChain = 2,
              parallel = FALSE)

## model specification after estimateModel called
showModel(filename.est)

predictModel(filenameEst = filename.est,
             filenamePred = filename.pred,
             n = 5)

## specification used by predictModel
showModel(filename.pred)
}
\seealso{
Parameter estimate can be extracted using function
\code{\link{fetch}}.
}
