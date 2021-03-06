% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/AllClasses-08-Prior-hierarchy-spec.R
\docType{class}
\name{SpecExchFixed-class}
\alias{SpecExchFixed-class}
\title{A S4 class to specify a simple exchangeable prior.}
\description{
An object of class \code{SpecExchFixed} specifies
a prior in which
  parameter[j] ~ N(0, sd^2).
For details, see the documentation for function
\code{\link{ExchFixed}}.
}
\section{Slots}{

\describe{
\item{\code{tau}}{Standard deviation.}

\item{\code{multTau}}{Multiplier applied to default value for \code{tau}.}
}}

\section{Warning}{

In  normal usage, it should not be necessary to
access, or even know about, the slots of a
\code{SpecExchFixed} object.  The slots are not part of
the API of the package, and may change in future.
}

\seealso{
Object of class \code{SpecExchFixed} should be generated
using function \code{\link{ExchFixed}}.  More complicated
exchangeable priors are specified by object of class
\code{\linkS4class{SpecExch}}.
}
