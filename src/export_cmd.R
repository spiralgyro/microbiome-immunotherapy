# src/export_cmd.R : export melanoma ICI cohorts from curatedMetagenomicData
if (!requireNamespace("BiocManager", quietly = TRUE)) install.packages("BiocManager", repos = "https://cloud.r-project.org")
BiocManager::install(c("curatedMetagenomicData", "dplyr"), update = FALSE, ask = FALSE)
suppressPackageStartupMessages({library(curatedMetagenomicData); library(dplyr); library(SummarizedExperiment)})

dir.create("data/raw", recursive = TRUE, showWarnings = FALSE)
studies <- c("LeeKA_2022", "FrankelAE_2017", "GopalakrishnanV_2018", "MatsonV_2018", "PetersBA_2019", "WindTT_2020")

for (s in studies) {
  se <- sampleMetadata |> filter(study_name == s) |> returnSamples("relative_abundance", rownames = "long")
  write.csv(as.data.frame(assay(se)), file.path("data/raw", paste0(s, "_relative_abundance.csv")))
  meta <- as.data.frame(colData(se))
  meta <- meta[, colSums(!is.na(meta)) > 0]   # drop columns that are empty for this study
  write.csv(meta, file.path("data/raw", paste0(s, "_metadata.csv")))
}
writeLines(capture.output(sessionInfo()), "data/raw/R_sessionInfo.txt")
