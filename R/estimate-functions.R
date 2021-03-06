
#' Estimate model from single reliable dataset.
#'
#' Estimate rates, counts, probabilities, or means for a single
#' \code{\link[dembase:DemographicArray-class]{demographic array}}.  The
#' demographic array is treated as observed without error.
#'
#' @section Model, y, and exposure:
#' 
#' The model for the contents of the array is specified using function
#' \code{\link{Model}}.
#'
#' If \code{model} specifies a Poisson, binomial, or multinomial model,
#' then \code{y} must have class
#' \code{\link[dembase:DemographicArray-class]{Counts}}.  If \code{model}
#' specifies a normal distribution, then \code{y} can have class
#' \code{\link[dembase:DemographicArray-class]{Counts}} or
#' \code{\link[dembase:DemographicArray-class]{Counts}}.
#'
#' \code{y} may include \code{NA}s.  Missing values can be imputed via function
#' function \code{\link{fetch}}.  If \code{model} specifies a Poisson
#' distribution, then \code{y} can also have known
#' \code{\link[dembase:attachSubtotals]{subtotals}}, which
#' can help with the imputation of the missing values.
#' 
#' An \code{exposure} term is optional in Poisson models, and required
#' in binomial models.  (For convenience, \code{demest} treats the sample size
#' parameter in binomial models as kind of exposure.)  A \code{weights} term
#' is optional in normal models.
#'
#' @section Output:
#'
#' The output from \code{estimateModel} would often be too large to fit into
#' memory.  \code{estimateModel} therefore departs from the standard R
#' behavior in the way it handles output.  Rather than returning an object
#' containing the output, \code{estimateModel} creates a file on disk,
#' somewhat like a database.
#'
#' The name and location of the output file is specified using the
#' \code{filename} argument. The file is just a text file, and can be copied
#' and moved.
#'
#' Users extract items from the file using function such as \code{\link{fetch}},
#' \code{\link{fetchSummary}}, \code{\link{fetchMCMC}}, and \code{\link{fetchFiniteSD}}.
#' 
#' Functions \code{\link{estimateCounts}}, \code{\link{estimateAccount}},
#' and \code{\link{predictModel}} follow the same strategy for returning
#' output.
#'
#' @section nBurnin, nSim, nChain, nThin:
#'
#' \code{estimateModel}, \code{\link{estimateCounts}}, and
#' \code{\link{estimateAccount}} use Markov chain Monte Carlo (MCMC)
#' methods for inference.  MCMC methods have two stages: burnin and
#' production.  During the burnin phase, the model moves from an
#' initial guess at the location of the posterior distribution
#' towards the true location.  During the production phase, if all goes
#' well, the model samples from the true posterior distribution.
#'
#' Parameter \code{nBurnin} specifies the number of iterations that the model
#' spendss moving away from its initial location. Parameter \code{nSim}
#' specifies the number of iterations that the model spends sampling from
#' the posterior distribution.
#'
#' Collecting every iteration during the production phase would lead to
#' huge output files.  Instead, the model collects only one in every
#' \code{nThin} iterations.  The resulting loss in information is relatively
#' small, since successive iterations are typically highly correlated.
#'
#' The calculations are run \code{nChain} times, with each chain yielding
#' a different sample.  As described in the documentation for
#' \code{\link{fetchMCMC}}, comparing the samples is a way of checking whether the
#' model has found the posterior distribution. When each chain seems to be
#' sampling from the same distribution, the model is said to have
#' converged.
#'
#' At the end of the estimation process, the \code{estimateModel} and similar
#' functions pool the results from all the chains to form a single sample.
#' This sample has \code{floor(nChain * nSim / nThin)} iterations.
#'
#' @section Parallel:
#'
#' Because each chain is run independently, the calculations can be carried out
#' in parallel.  By default, \code{estimateModel}, \code{\link{estimateCounts}},
#' and \code{\link{estimateAccount}} run the calculations on separate cores,
#' using functions from the \pkg{parallel} package. For portability, however,
#' the \code{parallel} argument is set to \code{FALSE} in the examples in the
#' online help.
#' 
#' @param model An object of class \code{\linkS4class{SpecModel}},
#' specifying the model to be fit.
#' @param y A \code{\link[dembase:DemographicArray-class]{demographic array}}
#' holding the outcome data.
#' @param exposure A \code{\link[dembase:DemographicArray-class]{Counts}}
#' object specifying exposure or sample size.
#' @param weights A \code{\link[dembase:DemographicArray-class]{Counts}}
#' object containing weights.
#' @param filename The name of a file where output is collected.  
#' @param nBurnin Number of iteration discarded before recording begins.
#' @param nSim Number of iterations carried out during recording.
#' @param nChain Number of parallel chains used in simulations.
#' @param nThin Thinning interval.
#' @param parallel Logical.  If \code{TRUE} (the default), parallel processing
#' is used.
#' @param nUpdateMax Maximum number of iterations completed before releasing
#' memory.  If running out of memory, setting a lower value than the default
#' may help.
#' @param outfile Where to direct the ‘stdout’ and ‘stderr’ connection
#' output from the workers when parallel processing.  Passed to function
#' \code{[parallel]{makeCluster}}.
#' @param verbose Logical.  If \code{TRUE} (the default) a message is
#' printed at the end of the calculations.
#' @param useC Logical.  If \code{TRUE} (the default), the calculations
#' are done in C.  Setting \code{useC} to \code{FALSE} may be useful
#' for debugging.
#'
#' @seealso \code{\link{estimateCounts}} is similar to \code{estimateModel},
#' except that \code{y} is not observed directly, but must be inferred from
#' multiple noisy datasets. \code{\link{estimateAccount}} infers a demographic
#' account from multiple noisy datasets.  Calculations can be extended using
#' \code{\link{continueEstimation}}.  Forecasts based on the results
#' from \code{estimateModel} can be constructed using function
#' \code{\link{predictModel}}.
#'
#' @references Gelman, A., Carlin, J. B., Stern, H. S.,
#' Dunson, D. B., Vehtari, A., Rubin, D. B. (2013)
#' \emph{Bayesian Data Analysis. Third Edition}. Boca Raton: Chapman &
#' Hall/CRC.
#'
#' @examples
#' library(datasets)
#' admissions <- Counts(UCBAdmissions)
#' admitted <- subarray(admissions, Admit == "Admitted")
#' filename <- tempfile()
#' estimateModel(Model(y ~ Binomial(mean ~ Gender + Dept)),
#'               y = admitted,
#'               exposure = admissions,
#'               file = filename,
#'               nBurnin = 50,
#'               nSim = 50,
#'               nChain = 2,
#'               nThin = 2)
#' fetchSummary(filename)
#' @export
estimateModel <- function(model, y, exposure = NULL, weights = NULL,
                          filename = NULL, nBurnin = 1000, nSim = 1000,
                          nChain = 4, nThin = 1, parallel = TRUE, outfile = NULL,
                          nUpdateMax = 50, verbose = TRUE, useC = TRUE) {
    call <- match.call()
    methods::validObject(model)
    mcmc.args <- makeMCMCArgs(nBurnin = nBurnin,
                              nSim = nSim,
                              nChain = nChain,
                              nThin = nThin)
    if (is.null(filename))
        filename <- tempfile()
    else
        checkFilename(filename)
    control.args <- makeControlArgs(call = call,
                                    parallel = parallel,
                                    nUpdateMax = nUpdateMax)
    y <- checkAndTidyY(y)
    y <- castY(y = y,
               spec = model)
    checkForSubtotals(object = y,
                      model = model,
                      name = "y")
    exposure <- checkAndTidyExposure(exposure = exposure,
                                     y = y)
    exposure <- castExposure(exposure = exposure,
                             model = model)
    weights <- checkAndTidyWeights(weights = weights,
                                   y = y)
    combineds <- replicate(n = mcmc.args$nChain,
                           initialCombinedModel(model,
                                                y = y,
                                                exposure = exposure,
                                                weights = weights))
    parallel <- control.args$parallel
    tempfiles <- paste(filename, seq_len(mcmc.args$nChain), sep = "_")
    MoreArgs <- c(list(seed = NULL),
                  mcmc.args,
                  control.args,
                  list(continuing = FALSE,
                       useC = useC))
    if (parallel) {
        pseed <- sample.int(n = 100000, # so that RNG behaves the same whether or not
                            size = 1)   # seed has previously been set
                                        # this must be done BEFORE call to makeCluster!
        if (is.null(outfile)) ## passing 'outfile' as an argument always causes redirection
            cl <- parallel::makeCluster(getOption("cl.cores",
                                                  default = mcmc.args$nChain))
        else
            cl <- parallel::makeCluster(getOption("cl.cores",
                                                  default = mcmc.args$nChain),
                                        outfile = outfile)
        parallel::clusterSetRNGStream(cl,
                                      iseed = pseed)
        final.combineds <- parallel::clusterMap(cl = cl,
                                                fun = estimateOneChain,
                                                tempfile = tempfiles,
                                                combined = combineds,
                                                MoreArgs = MoreArgs,
                                                SIMPLIFY = FALSE,
                                                USE.NAMES = FALSE)
        seed <- parallel::clusterCall(cl, function() .Random.seed)
        parallel::stopCluster(cl)
    }
    else {
        final.combineds <- mapply(estimateOneChain,
                                  tempfile = tempfiles,
                                  combined = combineds,
                                  MoreArgs = MoreArgs,
                                  SIMPLIFY = FALSE,
                                  USE.NAMES = FALSE)
        seed <- list(.Random.seed)
    }
    control.args$lengthIter <- length(extractValues(final.combineds[[1L]]))
    results <- makeResultsModelEst(finalCombineds = final.combineds,
                                   mcmcArgs = mcmc.args,
                                   controlArgs = control.args,
                                   seed = seed)
    makeResultsFile(filename = filename,
                    results = results,
                    tempfiles = tempfiles)
    rescaleInFile(filename)
    finalMessage(filename = filename,
                 verbose = verbose)
}



#' Use results from function estimateModel to make predictions.
#'
#' Typically predict along time dimension, but can predict along other
#' dimenions.  When predicting along time dimension, typically predict
#' forwards, but can predict backwards.
#'
#' If an \code{along} argument is not supplied, \code{predictModel} looks
#' for a dimension with \code{\link[dembase]{dimtype}} \code{"time"}, and,
#' failing that, a dimension with \code{\link[dembase]{dimtype}} \code{"age"},
#' or \code{"cohort"}.
#'
#' When predicting along \code{"time"}, \code{"age"} or \code{"cohort"}
#' dimensions, specifying an \code{n} argument is usually more convenient
#' than specifying a \code{labels} argument.
#' 
#' @inheritParams estimateModel
#' @param filenameEst Filename used to \code{\link{estimateModel}}.
#' @param filenamePred Filename to be used by \code{\link{predictModel}}.
#' @param along Name or index along which prediction should occur. 
#' @param labels Labels of new categories.
#' @param n Number of new categories.  Can only be used when predicting
#' along \code{"time"}, \code{"age"}, or \code{"cohort"} dimensions,
#' and when the units have equal length.
#' @param data A named list containing future values of covariates.
#' @param aggregate An object of class \code{\linkS4class{SpecAggregate}}.
#' @param lower A lower bound for estimates of data-level rates,
#' probabilities, or means.
#' @param upper An upper bound for estimates of data-level
#' rate, probabilities, or means.
#' @export
predictModel <- function(filenameEst, filenamePred, along = NULL, labels = NULL, n = NULL,
                         data = NULL, aggregate = NULL, lower = NULL,
                         upper = NULL, nBurnin = 0L,  parallel = TRUE, outfile = NULL,
                         verbose = FALSE, useC = TRUE) {
    if (!identical(nBurnin, 0L))
        stop("'nBurnin' must currently be 0L")
    call <- match.call()
    results.first <- fetchResultsObject(filenameEst)
    ## extract information about old results
    combined.first <- results.first@final[[1L]]
    mcmc.args.first <- results.first@mcmc
    control.args.first <- results.first@control
    model.first <- combined.first@model
    metadata.first <- model.first@metadataY
    y.first <- combined.first@y
    y.is.counts <- methods::is(y.first, "Counts")
    ## set up new objects
    along <- dembase::checkAndTidyAlong(along = along,
                                        metadata = metadata.first,
                                        numericDimScales = FALSE)
    checkFilename(filename = filenameEst,
                  name = "filenameEst")
    if(is.null(filenamePred))
        filenamePred <- tempfile()
    else
        checkFilename(filename = filenamePred,
                      name = "filenamePred")
    checkDataPredict(data)
    if (!(is.null(aggregate) || methods::is(aggregate, "SpecAggregate")))
        stop(gettextf("'%s' has class \"%s\"",
                      "aggregate", class(aggregate)))
    combined.pred <- initialCombinedModelPredict(combined = combined.first,
                                                 along = along,
                                                 labels = labels,
                                                 n = n,
                                                 covariates = data,
                                                 aggregate = aggregate,
                                                 lower = lower,
                                                 upper = upper,
                                                 yIsCounts = y.is.counts)
    control.args.pred <- list(call = call,
                              parallel = parallel,
                              lengthIter = lengthValues(combined.pred))
    mcmc.args.pred <- list(nBurnin = nBurnin,
                           nSim = mcmc.args.first[["nSim"]],
                           nChain = mcmc.args.first[["nChain"]],
                           nThin = mcmc.args.first[["nThin"]],
                           nIteration = mcmc.args.first[["nIteration"]])
    tempfiles.first <- splitFile(filename = filenameEst,
                                 nChain = mcmc.args.first[["nChain"]],
                                 nIteration = mcmc.args.first[["nIteration"]],
                                 lengthIter = control.args.first[["lengthIter"]])
    tempfiles.pred <- paste(filenamePred, seq_len(mcmc.args.pred[["nChain"]]), sep = "_")
    n.iter.chain <- mcmc.args.first[["nIteration"]] / mcmc.args.first[["nChain"]]
    if (parallel) {
        if (is.null(outfile)) ## passing 'outfile' as an argument always causes redirection
            cl <- parallel::makeCluster(getOption("cl.cores",
                                                  default = mcmc.args.pred$nChain))
        else
            cl <- parallel::makeCluster(getOption("cl.cores",
                                                  default = mcmc.args.pred$nChain),
                                        outfile = outfile)
        parallel::clusterSetRNGStream(cl)
        final.combineds <- parallel::clusterMap(cl = cl,
                                                fun = predictOneChain,
                                                combined = list(combined.pred),
                                                tempfileOld = tempfiles.first,
                                                tempfileNew = tempfiles.pred,
                                                lengthIter = control.args.first[["lengthIter"]],
                                                nIteration = n.iter.chain,
                                                nUpdate = nBurnin,
                                                useC = useC,
                                                SIMPLIFY = FALSE,
                                                USE.NAMES = FALSE)
        seed <- parallel::clusterCall(cl, function() .Random.seed)
        parallel::stopCluster(cl)
    }
    else {
        final.combineds <- mapply(predictOneChain,
                                  combined = list(combined.pred),
                                  tempfileOld = tempfiles.first,
                                  tempfileNew = tempfiles.pred,
                                  lengthIter = control.args.first[["lengthIter"]],
                                  nIteration = n.iter.chain,
                                  nUpdate = nBurnin,
                                  useC = useC,
                                  SIMPLIFY = FALSE,
                                  USE.NAMES = FALSE)
        seed <- list(.Random.seed)
    }
    sapply(tempfiles.first, unlink)
    results <- makeResultsModelPred(finalCombineds = final.combineds,
                                    mcmcArgs = mcmc.args.pred,
                                    controlArgs = control.args.pred,
                                    seed = seed)
    makeResultsFile(filename = filenamePred,
                    results = results,
                    tempfiles = tempfiles.pred)
    finalMessage(filename = filenamePred,
                 verbose = verbose)
}


#' Estimate counts and model from multiple noisy datasets.
#'
#' Infer the contents of a demographic array, and fit a model describing
#' the array, using multiple noisy datasets.
#'
#' See the documentation for \code{\link{estimateModel}} for details on
#' model output and on MCMC settings.
#'
#' \code{observation} is a list of specificiations for data models,
#' and \code{datasets} is a named list of datasets.  The response for each
#' data model must be the name of a dataset.  See below for examples.
#' 
#' 
#' @inheritParams estimateModel
#' @param y An object of class
#' \code{\link[dembase:DemographicArray-class]{Counts}} with the same
#' structure as the counts to be estimated.
#' @param observation A list of objects of class
#' \code{\linkS4class{SpecModel}} describing the relationship between 
#' the datasets and counts.  
#' @param datasets A named list of objects of class
#' \code{\link[dembase:DemographicArray-class]{Counts}}.
#'
#' @seealso \code{\link{estimateModel}}, \code{\link{estimateAccount}}
#' 
#' @examples
#' nat <- demdata::sim.admin.nat
#' health <- demdata::sim.admin.health
#' survey <- demdata::sim.admin.survey
#' nat <- Counts(nat, dimscales = c(year = "Points"))
#' health <- Counts(health, dimscales = c(year = "Points"))
#' survey <- Counts(survey)
#' y <- health + 10
#' model <- Model(y ~ Poisson(mean ~ age + sex + region))
#' observation <- list(Model(nat ~ PoissonBinomial(prob = 0.98)),
#'                     Model(health ~ Poisson(mean ~ age)),
#'                     Model(survey ~ Binomial(mean ~ 1)))
#' datasets <- list(nat = nat, health = health, survey = survey)
#' filename <- tempfile()
#' ## in a real example, nBurnin and nSim would be much larger
#' \dontrun{
#' estimateCounts(model = model,
#'                y = y,
#'                observation = observation,
#'                datasets = datasets,
#'                filename = filename,
#'                nBurnin = 50,
#'                nSim = 50,
#'                nThin = 2,
#'                nChain = 2,
#'                parallel = FALSE)
#' fetchSummary(filename)
#' }
#' @export
estimateCounts <- function(model, y, exposure = NULL, observation,
                           datasets, filename = NULL, nBurnin = 1000,
                           nSim = 1000, nChain = 5, nThin = 1,
                           parallel = TRUE, outfile = NULL, nUpdateMax = 50,
                           verbose = FALSE, useC = TRUE) {
    call <- match.call()
    methods::validObject(model)
    mcmc.args <- makeMCMCArgs(nBurnin = nBurnin,
                              nSim = nSim,
                              nChain = nChain,
                              nThin = nThin)
    if (is.null(filename))
        filename <- tempfile()
    else
        checkFilename(filename)
    control.args <- makeControlArgs(call = call,
                                    parallel = parallel,
                                    nUpdateMax = nUpdateMax)
    y <- checkAndTidyY(y)
    y <- dembase::toInteger(y)
    checkForSubtotals(object = y, model = model, name = "y")
    exposure <- checkAndTidyExposure(exposure = exposure, y = y)
    exposure <- castExposure(exposure = exposure, model = model)
    checkObservation(observation, needsNonDefaultSeriesArg = FALSE)
    checkNamesDatasets(datasets)
    datasets <- alignDatasetsToObservation(datasets = datasets,
                                           observation = observation)
    ## check of datasets comes after aligning,
    ## to avoid checking datasets that are not needed
    datasets <- checkAndTidyDatasets(datasets)
    transforms <- makeTransformsYToDatasets(y = y, nameY = "y", datasets = datasets)
    namesDatasets <- names(datasets)
    names(datasets) <- NULL
    combineds <- replicate(n = mcmc.args$nChain,
                           initialCombinedCounts(model,
                                                 y = y,
                                                 exposure = exposure,
                                                 observation = observation,
                                                 datasets = datasets,
                                                 namesDatasets = namesDatasets,
                                                 transforms = transforms))
    parallel <- control.args$parallel
    tempfiles <- paste(filename, seq_len(mcmc.args$nChain), sep = "_")
    MoreArgs <- c(list(seed = NULL),
                  mcmc.args,
                  control.args,
                  list(continuing = FALSE,
                       useC = useC))
    if (parallel) {
        if (is.null(outfile)) ## passing 'outfile' as an argument always causes redirection
            cl <- parallel::makeCluster(getOption("cl.cores",
                                                  default = mcmc.args$nChain))
        else
            cl <- parallel::makeCluster(getOption("cl.cores",
                                                  default = mcmc.args$nChain),
                                        outfile = outfile)
        parallel::clusterSetRNGStream(cl)
        final.combineds <- parallel::clusterMap(cl = cl,
                                                fun = estimateOneChain,
                                                tempfile = tempfiles,
                                                combined = combineds,
                                                MoreArgs = MoreArgs,
                                                SIMPLIFY = FALSE,
                                                USE.NAMES = FALSE)
        seed <- parallel::clusterCall(cl, function() .Random.seed)
        parallel::stopCluster(cl)
    }
    else {
        final.combineds <- mapply(estimateOneChain,
                                  tempfile = tempfiles,
                                  combined = combineds,
                                  MoreArgs = MoreArgs,
                                  SIMPLIFY = FALSE,
                                  USE.NAMES = FALSE)
        seed <- list(.Random.seed)
    }
    control.args$lengthIter <- length(extractValues(final.combineds[[1L]]))
    results <- makeResultsCounts(finalCombineds = final.combineds,
                                 mcmcArgs = mcmc.args,
                                 controlArgs = control.args,
                                 seed = seed)
    makeResultsFile(filename = filename,
                    results = results,
                    tempfiles = tempfiles)
    rescaleInFile(filename)
    finalMessage(filename = filename, verbose = verbose)
}

#' Use results from function estimateCounts to make predictions.
#'
#' Not written yet.
#' 
#' @inheritParams predictModel
#'
#' @export
predictCounts <- function(filenameEst, filenamePred, along = NULL, labels = NULL, n = NULL,
                          data = NULL, aggregate = NULL, lower = NULL,
                          upper = NULL, nBurnin = 0L,  parallel = TRUE, outfile = NULL,
                          verbose = FALSE, useC = TRUE) {
    stop("not written yet")
}

#' Estimate demographic account and models from multiple noisy datasets.
#'
#' Infer the contents of a demographic account, and fit models
#' describing series within the account, using multiple noisy datasets.
#' \emph{The function is still under construction.}
#'
#' @inheritParams estimateCounts
#' @param y An object of class
#' \code{\link[dembase:DemographicAccount-class]{DemographicAccount}}.
#' @param system A list of objects of class \code{\linkS4class{SpecModel}}
#' specifying models for the demographic series.
#' @param observation A list of objects of class
#' \code{\linkS4class{SpecModel}} specifying models for the datasets.
#'
#' @seealso \code{\link{estimateModel}}, \code{\link{estimateCounts}}
#'
#' @references Bryant, J., Graham, P. Bayesian demographic accounts:
#' Subnational population estimation using multiple datasources. 2013.
#' \emph{Bayesian Analysis}
#' @export
estimateAccount <- function(y, system, observation, datasets, filename = NULL,
                            nBurnin = 1000, nSim = 1000, nChain = 4, nThin = 1,
                            parallel = TRUE, outfile = NULL, nUpdateMax = 50,
                            verbose = FALSE, useC = TRUE) {
    stop("not written yet")
}


#' Use results from function estimateAccount to make predictions.
#'
#' Not written yet.
#' 
#' @inheritParams predictModel
#'
#' @export
predictAccount <- function(filenameEst, filenamePred, along = NULL, labels = NULL, n = NULL,
                           data = NULL, aggregate = NULL, lower = NULL,
                           upper = NULL, nBurnin = 0L,  parallel = TRUE, outfile = NULL,
                           verbose = FALSE, useC = TRUE) {
    stop("not written yet")
}






#' Add extra iterations to burnin or output.
#' 
#' Continue estimation process, retaining current settings, but extending
#' the burnin or sampling from the posterior distribution.
#' \code{continueEstimation} is called after \code{\link{estimateModel}},
#' \code{\link{estimateCounts}}, or \code{\link{estimateAccount}},
#' and can be called multiple times.
#'
#' The treatment of output from previous calls to the estimation functions or
#' to \code{continueEstimation} depends on \code{nBurnin} in the
#' current call to \code{continueEstimation}.  If \code{nBurnin} is
#' \code{NULL}, then \code{continueEstimation} adds iterations to
#' any existing posterior sample.  If \code{nBurnin} is a number,
#' then iterations from any previous calls to the
#' \code{estimate} function or to \code{continueEstimation} are
#' treated as burnin, and the construction of the posterior sample
#' begins again from scratch. See below for an example.
#'
#' If \code{nThin} is set to a different value from previous calls to
#' the \code{estimate} function or \code{continueEstimation}, then the
#' thinning ratio, and hence correlations between successive iterations,
#' will change. This is safe if the previous iterations are being used as
#' burnin, but needs to be done with care if the previous iterations
#' will form part of the posterior sample.
#'
#' Because model output includes the state of the random number generator,
#' it should be possible to obtain identical results by (i) calling an estimation
#' function followed by one or more calls to \code{continueEstimation},
#' and (ii) doing all the calculations in one call to an estimaton function.
#' For instance,
#' \itemize{
#'   \item \code{estimateModel} with \code{nBurnin = 2000} and \code{nSim = 0}
#'   \item \code{continueEstimation} with \code{nSim = 1000}
#'   \item \code{continueEstimation} with \code{nSim = 1000}
#' }
#' should give the same results as
#' \itemize{
#'   \item \code{estimateModel} with \code{nBurnin = 2000} and \code{nSim = 2000}.
#' }
#'
#' Note that the total size of the posterior sample depends not just on
#' \code{nSim}, but also on \code{nChain} and \code{nThin}.  In the simplest
#' case (ie a single call to an estimation function, and \code{nSim * nChain}
#' divisible by \code{nThin}) the number of iterations in the sample equals
#' \code{nSim * nChain / nThin}.
#' 
#' @inheritParams estimateModel
#' @param filename The filename used by the original call.
#' @param nSim Number of additional iterations.
#' 
#' @seealso \code{continueEstimation} is used together with
#' \code{\link{estimateModel}}, \code{\link{estimateCounts}},
#' and \code{\link{estimateAccount}}.  
#' 
#' @references \code{continueEstimation} was inspired by the discussion of
#' checkpointing in Geyer, C. 2011. Introduction to Markov chain Monte Carlo.
#' Brooks, S., Gelman, A., Jones, G. L., and Meng, X-L. (eds.)
#' \emph{Handbook of Markov Chain Monte Carlo}. Chapman & Hall/CRC.
#'
#' @examples
#' ## prepare data
#' deaths <- demdata::VADeaths2
#' popn <- demdata::VAPopn
#' deaths <- round(deaths)
#' deaths <- Counts(deaths)
#' popn <- Counts(popn)
#'
#' ## Show that estimation using a single call to
#' ## 'estimateModel' gives the same results as
#' ## a call to 'estimateModel' followed by a call
#' ## to 'continueEstimation'
#' 
#' ## estimate all at once
#' set.seed(1)
#' filename.all.at.once <- tempfile()
#' estimateModel(Model(y ~ Poisson(mean ~ age)),
#'               y = deaths,
#'               exposure = popn,
#'               filename = filename.all.at.once,
#'               nBurnin = 20,
#'               nSim = 20,
#'               nThin = 2,
#'               nChain = 2,
#'               parallel = FALSE)
#' rates.all.at.once <- fetch(filename.all.at.once,
#'                            where = c("model", "likelihood", "rate"))
#'
#' ## estimate using 'continueEstimation'
#' set.seed(1)
#' filename.with.continue <- tempfile()
#' estimateModel(Model(y ~ Poisson(mean ~ age)),
#'               y = deaths,
#'               exposure = popn,
#'               filename = filename.with.continue,
#'               nBurnin = 20,
#'               nSim = 0,
#'               nThin = 2,
#'               nChain = 2,
#'               parallel = FALSE)
#' continueEstimation(filename = filename.with.continue,
#'                    nSim = 20)
#' rates.with.continue <- fetch(filename.all.at.once,
#'                            where = c("model", "likelihood", "rate"))
#'
#' ## the two approaches give the same answer
#' all.equal(rates.all.at.once, rates.with.continue)
#' 
#'
#' ## Demonstrate the differences between nBurnin = 0
#' ## and nBurnin > 0.
#'
#' ## nBurnin is NULL in call to continueEstimation, so keep 
#' ## iterations from original call to estimateModel
#' filename.keep.original <- tempfile()
#' estimateModel(Model(y ~ Poisson(mean ~ age)),
#'               y = deaths,
#'               exposure = popn,
#'               filename = filename.keep.original,
#'               nBurnin = 20,
#'               nSim = 10,
#'               nThin = 2,
#'               nChain = 2,
#'               parallel = FALSE)
#' continueEstimation(filename = filename.keep.original,
#'                    nSim = 20)
#' fetchSummary(filename.keep.original) # see 'nBurnin' and 'nSim'
#'
#' ## nBurnin non-NULL in call to continueEstimation, so treat
#' ## iterations from original call to estimateModel
#' ## as part of burnin
#' filename.discard.original <- tempfile()
#' estimateModel(Model(y ~ Poisson(mean ~ age)),
#'               y = deaths,
#'               exposure = popn,
#'               filename = filename.discard.original,
#'               nBurnin = 20,
#'               nSim = 10,
#'               nThin = 2,
#'               nChain = 2,
#'               parallel = FALSE)
#' continueEstimation(filename = filename.discard.original,
#'                    nBurnin = 10,
#'                    nSim = 10)
#' fetchSummary(filename.discard.original) # see 'nBurnin' and 'nSim'
#' 
#' @export
continueEstimation <- function(filename, nBurnin = NULL, nSim = 1000, nThin = NULL,
                               outfile = NULL, verbose = FALSE, useC = TRUE) {
    object <- fetchResultsObject(filename)
    if (methods::is(object, "CombinedCounts"))
        stop("sorry - method for estimateCounts not written yet!")
    mcmc.args.old <- object@mcmc
    control.args <- object@control
    seed.old <- object@seed
    append <- is.null(nBurnin)
    if (append)
        nBurnin <- 0L
    if (is.null(nThin))
        nThin <- mcmc.args.old[["nThin"]]
    mcmc.args.new <- makeMCMCArgs(nBurnin = nBurnin,
                                  nSim = nSim,
                                  nChain = mcmc.args.old[["nChain"]],
                                  nThin = nThin)
    combineds <- object@final
    tempfiles.new <- paste(filename, "cont", seq_len(mcmc.args.new$nChain), sep = "_")
    MoreArgs <- c(mcmc.args.new, control.args, list(continuing = TRUE, useC = useC))
    if (control.args$parallel) {
        if (is.null(outfile)) ## passing 'outfile' as an argument always causes redirection
            cl <- parallel::makeCluster(getOption("cl.cores",
                                                  default = mcmc.args.new$nChain))
        else
            cl <- parallel::makeCluster(getOption("cl.cores",
                                                  default = mcmc.args.new$nChain),
                                        outfile = outfile)
        parallel::clusterSetRNGStream(cl)
        final.combineds <- parallel::clusterMap(cl = cl,
                                                fun = estimateOneChain,
                                                seed = seed.old,
                                                tempfile = tempfiles.new,
                                                combined = combineds,
                                                MoreArgs = MoreArgs,
                                                SIMPLIFY = FALSE,
                                                USE.NAMES = FALSE)
        seed <- parallel::clusterCall(cl, function() .Random.seed)
        parallel::stopCluster(cl)
    }
    else {
        set.seed(seed.old[[1L]])
        final.combineds <- mapply(estimateOneChain,
                                  seed = seed.old,
                                  tempfile = tempfiles.new,
                                  combined = combineds,
                                  MoreArgs = MoreArgs,
                                  SIMPLIFY = FALSE,
                                  USE.NAMES = FALSE)
        seed <- list(.Random.seed)
    }
    if (append) {
        mcmc.args.new[["nBurnin"]] <- mcmc.args.old[["nBurnin"]]
        mcmc.args.new[["nSim"]] <- mcmc.args.old[["nSim"]] + mcmc.args.new[["nSim"]]
    }
    else {
        mcmc.args.new[["nBurnin"]] <- (mcmc.args.old[["nBurnin"]]
            + mcmc.args.old[["nSim"]]
            + mcmc.args.new[["nBurnin"]])
    }
    results <- makeResultsModelEst(finalCombineds = final.combineds,
                                   mcmcArgs = mcmc.args.new,
                                   controlArgs = control.args,
                                   seed = seed)
    if (append) {
        tempfiles.old <- splitFile(filename = filename,
                                   nChain = mcmc.args.old[["nChain"]],
                                   nIteration = mcmc.args.old[["nIteration"]],
                                   lengthIter = control.args[["lengthIter"]])
        joinFiles(filenamesFirst = tempfiles.old,
                  filenamesLast = tempfiles.new)
        makeResultsFile(filename = filename,
                        results = results,
                        tempfiles = tempfiles.old)
    }
    else {
        makeResultsFile(filename = filename,
                        results = results,
                        tempfiles = tempfiles.new)
    }
    rescaleInFile(filename)
    finalMessage(filename = filename, verbose = verbose)    
}




## projectAccount <- function(formula, initial, values,
##                            filename = NULL,
##                            nBurnin = 1000,
##                            nSim = 1000, nChain = 4, nThin = 10,
##                            parallel = TRUE, maxAttempt = 0L) {
##     call <- match.call()
##     values <- alignValuesAndFormula(values)
##     account <- makeInitialAccount(formula = formula,
##                                   initial = initial,
##                                   values = values)
##     thetas <- makeThetas(account = account, values = values)
##     mcmc.args <- makeMCMCArgs(nBurnin = nBurnin,
##                               nSim = nSim,
##                               nChain = nChain,
##                               nThin = nThin)
##     filename <- checkAndTidyFilename(filename = filename, prefix = "project")
##     control.args <- makeControlArgs(call = call,
##                                     parallel = parallel)
##     combineds <- replicate(n = mcmc.args$nChain,
##                            initialCombinedProject(account = account,
##                                                   thetas = thetas))
##     parallel <- control.args$parallel
##     tempfiles <- sapply(seq_len(mcmc.args$nChain),
##                         function(x) paste(control.args$filename, x, sep = "_"))
##     MoreArgs <- c(list(seed = NULL), mcmc.args, control.args)
##     if (parallel) {
##         cl <- parallel::makeCluster(getOption("cl.cores", default = mcmc.args$nChain))
##         parallel::clusterSetRNGStream(cl)
##         final.combineds <- parallel::clusterMap(cl = cl,
##                                       fun = estimateOneChain,
##                                       tempfile = tempfiles,
##                                       combined = combineds,
##                                       MoreArgs = MoreArgs,
##                                       SIMPLIFY = FALSE,
##                                       USE.NAMES = FALSE)
##         seed <- parallel::clusterCall(cl, function() .Random.seed)
##         parallel::stopCluster(cl)
##     }
##     else {
##         final.combineds <- mapply(estimateOneChain,
##                                   tempfile = tempfiles,
##                                   combined = combineds,
##                                   MoreArgs = MoreArgs,
##                                   SIMPLIFY = FALSE,
##                                   USE.NAMES = FALSE)
##         seed <- list(.Random.seed)
##     }
##     control.args$lengthIter <- length(extractValues(final.combineds[[1L]]))
##     makeResultsFile(filename = control.args$filename,
##                     tempfiles = tempfiles)
##     makeResultsProject(finalCombineds = final.combineds,
##                        mcmcArgs = mcmc.args,
##                        controlArgs = control.args,
##                        seed = seed)
## }


                                       
