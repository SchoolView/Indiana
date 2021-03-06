################################################################################
###                                                                          ###
###                Indiana COVID Skip-year SGP analyses for 2021             ###
###                                                                          ###
################################################################################

###   Load packages
require(SGP)
require(SGPmatrices)

###   Load data
load("Data/Indiana_SGP.Rdata")
load("Data/Indiana_Data_LONG_2021.Rdata")

###   Add Baseline matrices to SGPstateData
SGPstateData <- addBaselineMatrices("IN", "2021")
SGPstateData[["IN"]][["Assessment_Program_Information"]][["Assessment_Transition"]] <- NULL

###   Read in SGP Configuration Scripts and Combine
source("SGP_CONFIG/2021/PART_A/ELA.R")
source("SGP_CONFIG/2021/PART_A/MATHEMATICS.R")

IN_CONFIG <- c(ELA_2021.config, MATHEMATICS_2021.config)

### Parameters
parallel.config <- list(BACKEND="PARALLEL", WORKERS=list(PERCENTILES=4, BASELINE_PERCENTILES=4, PROJECTIONS=4, LAGGED_PROJECTIONS=4, SGP_SCALE_SCORE_TARGETS=4))

#####
###   Run updateSGP analysis
#####

Indiana_SGP <- updateSGP(
        what_sgp_object = Indiana_SGP,
        with_sgp_data_LONG = Indiana_Data_LONG_2021,
        steps = c("prepareSGP", "analyzeSGP", "combineSGP"),
        sgp.config = IN_CONFIG,
        sgp.percentiles = TRUE,
        sgp.projections = FALSE,
        sgp.projections.lagged = FALSE,
        sgp.percentiles.baseline = TRUE,
        sgp.projections.baseline = FALSE,
        sgp.projections.lagged.baseline = FALSE,
        save.intermediate.results = FALSE,
        parallel.config = parallel.config
)


### Copy SCALE_SCORE_PRIOR and SCALE_SCORE_PRIOR_STANDARDIZED to BASELINE counter parts

Indiana_SGP@Data[YEAR=="2021", SCALE_SCORE_PRIOR_BASELINE:=SCALE_SCORE_PRIOR]
Indiana_SGP@Data[YEAR=="2021", SCALE_SCORE_PRIOR_STANDARDIZED_BASELINE:=SCALE_SCORE_PRIOR_STANDARDIZED]


###   Save results
save(Indiana_SGP, file="Data/Indiana_SGP.Rdata")
