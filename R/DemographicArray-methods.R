

## castExposure #######################################################################

## HAS_TESTS
setMethod("castExposure",
          signature(exposure = "Counts",
                    model = "Binomial"),
          function(exposure, model) {
              exposure <- tryCatch(dembase::toInteger(exposure),
                                   error = function(e) e)
              if (methods::is(exposure, "error"))
                  stop(gettextf("'%s' cannot be coerced to integer : %s",
                                "exposure", exposure$message))
              exposure
          })

## HAS_TESTS
## needed by 'predictModel'
setMethod("castExposure",
          signature(exposure = "NULL",
                    model = "Binomial"),
          function(exposure, model) {
              NULL
          })

## HAS_TESTS
setMethod("castExposure",
          signature(exposure = "Counts",
                    model = "Poisson"),
          function(exposure, model) {
              dembase::toDouble(exposure)
          })

## HAS_TESTS
setMethod("castExposure",
          signature(exposure = "NULL",
                    model = "Poisson"),
          function(exposure, model) {
              NULL
          })

## HAS_TESTS
setMethod("castExposure",
          signature(exposure = "NULL",
                    model = "Normal"),
          function(exposure, model) {
              NULL
          })

## HAS_TESTS
setMethod("castExposure",
          signature(exposure = "Counts",
                    model = "PoissonBinomialMixture"),
          function(exposure, model) {
              exposure <- tryCatch(dembase::toInteger(exposure),
                                   error = function(e) e)
              if (methods::is(exposure, "error"))
                  stop(gettextf("'%s' cannot be coerced to integer : %s",
                                "exposure", exposure$message))
              exposure
          })

## HAS_TESTS
setMethod("castExposure",
          signature(exposure = "Counts",
                    model = "SpecBinomialVarying"),
          function(exposure, model) {
              exposure <- tryCatch(dembase::toInteger(exposure),
                                   error = function(e) e)
              if (methods::is(exposure, "error"))
                  stop(gettextf("'%s' cannot be coerced to integer : %s",
                                "exposure", exposure$message))
              exposure
          })

## HAS_TESTS
setMethod("castExposure",
          signature(exposure = "Counts",
                    model = "SpecPoissonVarying"),
          function(exposure, model) {
              dembase::toDouble(exposure)
          })

## HAS_TESTS
setMethod("castExposure",
          signature(exposure = "NULL",
                    model = "SpecPoissonVarying"),
          function(exposure, model) {
              NULL
          })

## HAS_TESTS
setMethod("castExposure",
          signature(exposure = "NULL",
                    model = "SpecNormalVarying"),
          function(exposure, model) {
              NULL
          })

## HAS_TESTS
setMethod("castExposure",
          signature(exposure = "Counts",
                    model = "SpecPoissonBinomialMixture"),
          function(exposure, model) {
              exposure <- tryCatch(dembase::toInteger(exposure),
                                   error = function(e) e)
              if (methods::is(exposure, "error"))
                  stop(gettextf("'%s' cannot be coerced to integer : %s",
                                "exposure", exposure$message))
              exposure
          })




## castY ##############################################################################

## HAS_TESTS
setMethod("castY",
          signature(y = "Counts",
                    spec = "SpecBinomialVarying"),
          function(y, spec) {
              y <- tryCatch(dembase::toInteger(y),
                            error = function(e) e)
              if (methods::is(y, "error"))
                  stop(gettextf("'%s' cannot be coerced to integer : %s",
                                "y", y$message))
              y
          })

## HAS_TESTS
setMethod("castY",
          signature(y = "DemographicArray",
                    spec = "SpecNormalVarying"),
          function(y, spec) {
              dembase::toDouble(y)
          })

## HAS_TESTS
setMethod("castY",
          signature(y = "Counts",
                    spec = "SpecPoissonVarying"),
          function(y, spec) {
              y <- tryCatch(dembase::toInteger(y),
                            error = function(e) e)
              if (methods::is(y, "error"))
                  stop(gettextf("'%s' cannot be coerced to integer : %s",
                                "y", y$message))
              y
          })

## HAS_TESTS
setMethod("castY",
          signature(y = "Counts",
                    spec = "SpecPoissonBinomialMixture"),
          function(y, spec) {
              y <- tryCatch(dembase::toInteger(y),
                            error = function(e) e)
              if (methods::is(y, "error"))
                  stop(gettextf("'%s' cannot be coerced to integer : %s",
                                "y", y$message))
              y
          })


## combineEstPred #######################################################

## HAS_TESTS
setMethod("combineEstPred",
          signature(est = "Counts",
                    pred = "Counts"),
          function(est, pred) {
              l <- combineEstPredHelper(est = est, pred = pred)
              methods::new("Counts",
                  .Data = l$.Data,
                  metadata = l$metadata)
          })

## HAS_TESTS
setMethod("combineEstPred",
          signature(est = "Values",
                    pred = "Values"),
          function(est, pred) {
              l <- combineEstPredHelper(est = est, pred = pred)
              methods::new("Values",
                  .Data = l$.Data,
                  metadata = l$metadata)
          })

## concatDimScaleFirstSecond ########################################################

## These are actually methods for "DimScale" objects, but I didn't want
## to start a whole new file just for them

## HAS_TESTS
setMethod("concatDimScaleFirstSecond",
          signature(first = "Categories", second = "Categories"),
          function(first, second, name) {
              dimvalues.first <- first@dimvalues
              dimvalues.second <- second@dimvalues
              if (length(intersect(dimvalues.first, dimvalues.second) > 0L))
                  stop(gettextf("new \"%s\" dimension [\"%s\"] has duplicated categories",
                                "along", name))
              dimvalues <- c(dimvalues.first, dimvalues.second)
              methods::new("Categories", dimvalues = dimvalues)
          })

## HAS_TESTS
setMethod("concatDimScaleFirstSecond",
          signature(first = "Points", second = "Points"),
          function(first, second, name) {
              dimvalues.first <- first@dimvalues
              dimvalues.second <- second@dimvalues
              if (max(dimvalues.first) >= min(dimvalues.second))
                  stop(gettextf("new \"%s\" dimension [\"%s\"] has overlapping points",
                                "along", name))
              dimvalues <- c(dimvalues.first, dimvalues.second)
              methods::new("Points", dimvalues = dimvalues)
          })

## HAS_TESTS
setMethod("concatDimScaleFirstSecond",
          signature(first = "Intervals", second = "Intervals"),
          function(first, second, name) {
              dimvalues.first <- first@dimvalues
              dimvalues.second <- second@dimvalues
              if (max(dimvalues.first) > min(dimvalues.second))
                  stop(gettextf("new \"%s\" dimension [\"%s\"] has overlapping intervals",
                                "along", name))
              if (max(dimvalues.first) < min(dimvalues.second))
                  stop(gettextf("new \"%s\" dimension [\"%s\"] has gaps between intervals",
                                "along", name))
              dimvalues <- c(dimvalues.first, dimvalues.second[-1L])
              methods::new("Intervals", dimvalues = dimvalues)
          })




## castPopnOrSampled ##################################################################

## HAS_TESTS
setMethod("castPopnOrSampled",
          signature(x = "Counts",
                    model = "Binomial"),
          function(x, model, name) {
              x <- tryCatch(dembase::toInteger(x), error = function(e) e)
              if (methods::is(x, "error"))
                  stop(gettextf("'%s' cannot be coerced to integer : %s",
                                name, x$message))
              x
          })

## HAS_TESTS
setMethod("castPopnOrSampled",
          signature(x = "Counts",
                    model = "Poisson"),
          function(x, model, name) {
              dembase::toDouble(x)
          })

## HAS_TESTS
setMethod("castPopnOrSampled",
          signature(x = "Counts",
                    model = "Normal"),
          function(x, model, name) {
              dembase::toDouble(x)
          })

## HAS_TESTS
setMethod("castPopnOrSampled",
          signature(x = "Counts",
                    model = "PoissonBinomialMixture"),
          function(x, model, name) {
              x <- tryCatch(dembase::toInteger(x), error = function(e) e)
              if (methods::is(x, "error"))
                  stop(gettextf("'%s' cannot be coerced to integer : %s",
                                name, x$message))
              x
          })


## checkForSubtotals ############################################################

## NO_TESTS
setMethod("checkForSubtotals",
          signature(object = "HasSubtotals",
                    model = "SpecPoissonVarying"),
          function(object, model, name = "y") {
              aggregate <- object@aggregate
              if (!methods::is(aggregate, "SpecAgPlaceholder"))
                  stop(gettextf("aggregate values not permitted when '%s' has subtotals",
                                "y"))
              NULL
          })


## HAS_TESTS
setMethod("checkForSubtotals",
          signature(object = "HasSubtotals",
                    model = "SpecNormalVarying"),
          function(object, model, name = "y") {
              stop(gettextf("'%s' has subtotals but model has class \"%s\"",
                            name, "Normal"))
          })

## HAS_TESTS
setMethod("checkForSubtotals",
          signature(object = "HasSubtotals",
                    model = "SpecBinomialVarying"),
          function(object, model, name = "y") {
              stop(gettextf("'%s' has subtotals but model has class \"%s\"",
                            name, "Binomial"))
          })

## HAS_TESTS
setMethod("checkForSubtotals",
          signature(object = "HasSubtotals",
                    model = "SpecPoissonBinomialMixture"),
          function(object, model, name = "y") {
              stop(gettextf("'%s' has subtotals but model has class \"%s\"",
                            name, "PoissonBinomialMixture"))
          })

## HAS_TESTS
setMethod("checkForSubtotals",
          signature(object = "HasSubtotals",
                    model = "ANY"),
          function(object, model, name = "y") {
              stop(gettextf("'%s' has subtotals but specification has class \"%s\"",
                            name, class(model)))
          })


## classY #######################################################################

## HAS_TESTS
setMethod("classY",
          signature(y = "DemographicArray"),
          function(y) as.character(class(y)))


## coverage #####################################################################

## setMethod("coverage",
##           signature(estimated = "Counts",
##                     true = "Counts",
##                     percent = "numeric"),
##           function(estimated, true, percent) {
##               for (
##               if (any(is.na(estima
## coverage <- function(estimated, true, percent) {
##     q <- 1 - percent / 100
##     prob <- c(0.5 * q, 1 - 0.5 * q)
##     interval <- collapseIterations(estimated, prob = prob)
##     lower <- slice(interval, dimension = "quantile", elements = 1L)
##     upper <- slice(interval, dimension = "quantile", elements = 2L)
##     inside.interval <- (true >= lower) & (true <= upper)
##     mean(inside.interval)
## }


## equivalent sample #############################################################

## HAS_TESTS
#' @rdname equivalentSample
#' @export
setMethod("equivalentSample",
          signature(mean = "Values", se = "Values"),
          function(mean, se, to = c("binomial", "Poisson"), epsilon = 1e-6) {
              if (any(mean < 0, na.rm = TRUE))
                  stop(gettextf("'%s' has negative values",
                                "mean"))
              if (any(se < 0, na.rm = TRUE))
                  stop(gettextf("'%s' has negative values",
                                "se"))
              to <- match.arg(to)
              se[!is.na(se) & (se < epsilon)] <- NA
              se <- tryCatch(dembase::makeCompatible(x = se, y = mean, subset = TRUE),
                             error = function(e) e)
              if (methods::is(se, "error"))
                  stop(gettextf("'%s' not compatible with '%s' : %s",
                                "se", "mean", se$message))
              if (identical(to, "binomial")) {
                  if (any(mean > 1, na.rm = TRUE))
                      stop(gettextf("'%s' is \"%s\" but '%s' has values greater than %d",
                                    "to", "binomial", "mean", 1L))
                  exposure <- mean * (1 - mean) / se^2
              }
              else if (identical(to, "Poisson"))
                  exposure <- mean / se^2
              else
                  stop(gettextf("invalid value for '%s'",
                                "to"))
              y <- mean * exposure
              y <- dembase::toInteger(y, force = TRUE)
              if (identical(to, "binomial"))
                  exposure <- dembase::toInteger(exposure, force = TRUE)
              y <- methods::as(y, "Counts")
              exposure <- methods::as(exposure, "Counts")
              list(y = y, exposure = exposure)
          })

        
## show #########################################################################

#' @rdname FiniteSD-class
#' @export
setMethod("show",
          signature(object = "FiniteSD"),
          function(object) {
              object <- round(object, 3)
              methods::callNextMethod()
          })




## sweepAllMargins ###############################################################

## HAS_TESTS
setMethod("sweepAllMargins",
          signature(object = "array"),
          function(object) {
              if (length(object) == 0L)
                  stop(gettextf("'%s' has length %d",
                                "object", 0L))
              object <- object - mean(object)
              dim <- dim(object)
              n <- length(dim)
              if (n > 1L) {
                  margins <- utils::combn(seq_len(n), m = n - 1L, simplify = FALSE)
                  object <- sweepMargins(object, margins = margins)
              }
              object
          })

## HAS_TESTS
setMethod("sweepAllMargins",
          signature(object = "Values"),
          function(object) {
              .Data <- object@.Data
              metadata <- object@metadata
              dim <- dim(object)
              dimtypes <- dembase::dimtypes(object, use.names = FALSE)
              if (length(object) == 0L)
                  stop(gettextf("'%s' has length %d",
                                "object", 0L))
              if ("quantile" %in% dimtypes)
                  stop(gettextf("'%s' has dimension with dimtype \"%s\"",
                                "object", "quantile
"))
              i.iter <- match("iteration", dimtypes, nomatch = 0L)
              has.iter <- i.iter > 0L
              if (has.iter) {
                  n <- length(dim)
                  if (n > 1L) {
                      s <- seq_len(n)[-i.iter]
                      margins <- utils::combn(s, m = n - 2L, simplify = FALSE)
                      margins <- lapply(margins, function(x) c(i.iter, x))
                      .Data <- sweepMargins(.Data, margins = margins)
                  }
              }
              else {
                  .Data <- sweepAllMargins(.Data)
              }
              methods::new("Values", .Data = .Data, metadata = metadata)
          })

