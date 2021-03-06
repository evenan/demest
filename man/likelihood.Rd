% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/SpecModel-generators.R
\name{likelihood}
\alias{likelihood}
\alias{Binomial}
\alias{Normal}
\alias{Poisson}
\alias{Poisson}
\alias{Binomial}
\alias{Normal}
\title{Specify first two levels of hierarchical model.}
\usage{
Poisson(formula, useExpose = TRUE)

Binomial(formula)

Normal(formula, sd = NULL, priorSD = HalfT())
}
\arguments{
\item{formula}{A \code{\link[stats]{formula}} with response
\code{mean} and names of dimensions of demographic
series or dataset being modelled.}

\item{useExpose}{Whether the model includes an
exposure term. Defaults to \code{TRUE}.}

\item{sd}{Standard deviation in the likelihood for the
normal model.  If a value is not supplied,
it is estimated from the data.}

\item{priorSD}{An object of class \code{HalfT} specifying
a non-default prior for the standard deviation in the
likelihood for the normal model.}
}
\value{
An object of class \code{\linkS4class{SpecLikelihood}}.
}
\description{
Specify the likelihood and part of the prior for a
Poisson, binomial, or normal hierarchical model.
}
\details{
Specify a likelihood and prior of the form
\deqn{y_i \sim Poisson(\gamma_i n_i)}
\deqn{log(\gamma_i) \sim N(x_i \beta, \sigma_i),}

\deqn{y_i \sim Poisson(\gamma_i)}
\deqn{log(\gamma_i) \sim N(x_i \beta, \sigma_i),}

\deqn{y_i \sim binomial(n_i, \gamma_i)}
\deqn{logit(\gamma_i) \sim N(x_i \beta, \sigma_i),}
or
\deqn{y_i \sim normal(\gamma_i, \phi^2 / w_i)}
\deqn{\gamma_i \sim N(x_i \beta, \sigma_i)}.

Subscript \eqn{i} denotes a cell within a multiway array,
such as an array with dimensions age, sex, and time.  In
Poisson and binomial models, \eqn{y_i} is a count.
The \eqn{n_i} term is an exposure in the case of Poisson
models and a sample size in the case of binomial models.
It is not supplied in calls to function \code{Poisson}
or \code{Binomial}.  In normal models \eqn{y_i}
is a cell-specific value such as a mean,
and \eqn{w_i} is a cell-specific weight.  Weights
are not supplied in calls to function \code{Normal}.
Vector \eqn{\beta} contains main effects
and interactions, such as age effects, time effects,
and age-region interactions. Vector \eqn{x_i} is the
\eqn{i}th row from the design matrix \eqn{X}.

The main effects and interactions are specified
via the \code{formula} argument. For instance,

\code{mean ~ age * sex + time}

specifies a model with age, sex, and time main effects,
and an age-sex interaction.

The main effects and interactions in a hierarchical model are only weakly
identified: see the documentation for function \code{\link{fetch}} for
details.

If a model has two or more levels, the second level
typically contains more than just main effects
and interactions.  For instance, the second level of
Poisson, binomial, and normal hierarchical models
contains a variance term.  The remaining parts of
the second level, such as the variances, as well
as any higher levels, are specified
in calls to function \code{\link{Model}}, or to
functions \code{\link{estimateModel}},
\code{\link{estimateCounts}}, or \code{\link{estimateAccount}}.
}
\examples{
## age effect, sex effect, age-sex interaction,
## and time effect
Poisson(mean ~ age * sex + time)

## same model, but without exposure term
Poisson(mean ~ age * sex + time, useExpose = FALSE)

## use formula notation to specify second-order interactions
Binomial(mean ~ (age + sex + region)^2)

Normal(mean ~ age + education + income)
## specify the exact value of the standard deviation
Normal(mean ~ age + education + income,
       sd = 0.3)
## specify a non-default prior for the standard deviation
Normal(mean ~ age + education + income,
       priorSD = HalfT(scale = 100))

}
\seealso{
Functions \code{Poisson}, \code{Binomial}, and \code{Normal} are
used as part of a call to function \code{\link{Model}}.
}
