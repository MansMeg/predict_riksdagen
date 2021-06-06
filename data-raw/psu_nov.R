library(pxweb)

psu_data <- 
  pxweb_get(url = "http://api.scb.se/OV0104/v1/doris/sv/ssd/ME/ME0201/ME0201A/Vid10",
            query = "data-raw/psu_query.json")
psu_df <- as.data.frame(psu_data, column.name.type = "text", variable.value.type = "text")

dat <- readxl::read_xlsx("data-raw/dataset_svparties_forlander_uddhammar.xlsx")

# Cleanup
psu_df <- psu_df[,c(1,2,3)]
psu_df <- psu_df[psu_df[,2] %in% paste0(dat$year - 1, "M11"),]
psu_df$year <- as.integer(substr(psu_df[,2],1,4)) + 1L
names(psu_df)[3] <- c("PSU_nov")
psu_df[,2] <- NULL

# Write
write.csv2(psu_df, file = "data/psu_nov.csv", row.names = FALSE)
