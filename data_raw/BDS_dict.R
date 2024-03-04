#BDS_dict_raw <- readRDS("data_raw/BDS_dict.RDS")
BDS_dict_raw <- readxl::read_xlsx("data_raw/BDS_dict.xlsx")

#names(BDS_dict_raw) <- c("key", "DE", "EN")
BDS_dict_raw <- BDS_dict_raw[,c("key", "EN", "DE", "DE_F")]
BDS_dict <- psychTestR::i18n_dict$new(BDS_dict_raw)
usethis::use_data(BDS_dict, overwrite = TRUE)
