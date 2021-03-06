% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/AllClasses-10-Prior-generators.R
\docType{class}
\name{Damp-class}
\alias{Damp-class}
\alias{Damp-class}
\alias{DampKnown-class}
\alias{DampUnknown-class}
\title{S4 classes to specify damping terms in DLM priors.}
\description{
Priors specified using \code{\link{DLM}} can include damping terms.  The
coefficient can be supplied and treated as known, in which case an object
of class \code{DampKnown} is used. Alternatively, the coefficient can be
estimated from the data, using a beta prior, in which case an object
of class \code{DampUnknown} is used. \code{Damp} is a virtual superclass
for \code{DampKnown} and \code{DampUnknown}.
}
\section{Slots}{

\describe{
\item{\code{phi}}{Coefficient, which must be between 0 and 1.}

\item{\code{minPhi}}{Minimum value for coefficient.}

\item{\code{maxPhi}}{Maximum value for coefficient.}

\item{\code{shape1Phi}}{First 'sample size' parameter in beta
prior for coefficient.}

\item{\code{shape2Phi}}{Second 'sample size' parameter in beta
prior for coefficient.}
}}

\section{Warning}{

In  normal usage, it should not be necessary to
access, or even know about, the slots of a
\code{Damp} object.  The slots are not part of
the API of the package, and may change in future.
}

\seealso{
Objects of class \code{Damp} are created  by a call to function
\code{\link{Damp}}.
}
