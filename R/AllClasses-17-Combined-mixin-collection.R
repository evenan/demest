
setClass("AccountMixin",
         contains = c("VIRTUAL",
                      "CumProbPopnMixin",
                      "DescriptionsMixin",
                      "DiffPropMixin",
                      "ExposureMixin",
                      "GeneratedNewProposalMixin",
                      "HasAgeMixin",
                      "ICellMixin",
                      "ICompMixin",
                      "IExpFirstMixin",
                      "IExposureMixin",
                      "IPopnNextMixin",
                      "IsIncrementMixin",
                      "IsNetMixin",
                      "IteratorPopnMixin",
                      "MappingsFromExpMixin",
                      "MappingsToExpMixin",
                      "MappingsToPopnMixin",
                      "MaxAttemptMixin",
                      "NCellAccountMixin",
                      "ProbPopnMixin"))

setClass("MovementsAgeMixin",
         contains = c("VIRTUAL",
                      "AccessionMixin",
                      "IAccNextMixin",
                      "IsLowerTriangleMixin",
                      "IteratorAccMixin",
                      "MappingsToAccMixin"))

setClass("ObservationMixin",
         contains = c("VIRTUAL",
                      "ObservationModelsMixin",
                      "DatasetsMixin",
                      "NamesDatasetsMixin",
                      "TransformsMixin"))

setClass("SystemMixin",
         contains = c("VIRTUAL",
                      "SystemModelsMixin",
                      "ModelUsesExposureMixin"))
         
