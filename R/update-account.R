

## updating proposals #############################################################


updateProposalAccountMovePopn <- function(combined, useC = FALSE) {
    stopifnot(is(combined, "CombinedAccountMove"))
    if (useC) {
        .Call(updateProposalAccountMovePopn_R, combined)
    }
    else {
        account <- combined@account
        population <- account@population
        has.age <- combined@hasAge
        if (has.age) {
            accession <- combined@accession
            iterator.acc <- combined@iteratorAcc
        }
        description <- combined@descriptionPopn
        iterator.popn <- combined@iteratorPopn
        sys.mod.popn <- combined@system[[1L]]
        theta.popn <- sys.mod.popn@theta
        max.attempt <- combined@maxAttempt
        i.cell <- chooseICellPopn(description.popn)
        i.exp.comp.first <- getIExpFirstFromPopn(i = i.cell,
                                                     description = description)
        i.popn.next <- getIPopnNextFromPopn(i = i.cell,
                                            description = description.popn)
        min.val <- getMinValCohort(i = i.popn.next,
                                   series = population,
                                   iter = iterator.popn)
        if (has.age) {
            i.acc.next <- getIAccNextFromPopn(i = i.cell,
                                              description = description.popn)
            has.later.accession <- i.acc.next > 0L
            if (has.later.accession) {
                min.acc <- getMinValCohort(i = i.acc.next,
                                           series = accession,
                                           iter = iterator.acc)
                min.val <- min(min.val, min.acc)
            }
        }
        val.curr <- population[i.cell]
        lower <- val.curr - min.val
        upper <- NA_integer_
        lambda <- theta[i.cell]
        val.prop <- rpoisTrunc1(lambda = lambda,
                                lower = lower,
                                upper = upper,
                                maxAttempt = max.attempt)
        found.value <- !is.na(val.prop)
        if (found.value) {
            diff.prop <- val.prop - val.curr
            generated.new.proposal <- diff.prop != 0L
        }
        else
            generated.new.proposal <- FALSE
        if (generated.new.proposal) {
            combined@iCell <- i.cell
            combined@iCellOther <- NA_integer_
            combined@isLowerTriangle <- NA
            combined@iPopnNext <- i.popn.next
            combined@iPopnNextOther <- NA_integer_
            if (has.age) {
                combined@iAccNext <- i.acc.next
                combined@iAccNextOther <- NA_integer_
            }
            else {
                combined@iAccNext <- NA_integer_
                combined@iAccNextOther <- NA_integer_
            }
            combined@iExposure <- NA_integer_
            combined@iExposureOther <- NA_integer_
            combined@iExpFirst <- i.exp.comp.first
            combined@iExpFirstOther <- NA_integer_
            combined@diffProp <- diff.prop
        }
        else {
            combined@iCell <- NA_integer_
            combined@iCellOther <- NA_integer_
            combined@isLowerTriangle <- NA
            combined@iPopnNext <- NA_integer_
            combined@iPopnNextOther <- NA_integer_
            combined@iAccNext <- NA_integer_
            combined@iAccNextOther <- NA_integer_
            combined@iExposure <- NA_integer_
            combined@iExposureOther <- NA_integer_
            combined@iExpFirst <- NA_integer_
            combined@iExpFirstOther <- NA_integer_
            combined@diffProp <- NA_integer_
        }
        combined
    }
}