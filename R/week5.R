# Script Settings and Resources
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(tidyverse)

# Data Import
Adata_tbl <- read_delim("../data/Aparticipants.dat", delim = "-", show_col_types = TRUE, col_names = c("casenum", "parnum", "stimver", "datadate", "qs"))
Anotes_tbl <- read_csv("../data/Anotes.csv", show_col_types = TRUE, col_names = TRUE)
Bdata_tbl <- read_delim("../data/Bparticipants.dat", delim = "\t", show_col_types = TRUE, col_names = c("casenum", "parnum", "stimver", "datadate", "q1", "q2", "q3", "q4", "q5", "q6", "q7", "q8", "q9", "q10"))
Bnotes_tbl <- read_delim("../data/Bnotes.txt", delim = "\t", show_col_types = TRUE, col_names = TRUE)

# Data Cleaning
Aclean_tbl <- Adata_tbl %>%
  separate(qs, into = c("q1", "q2", "q3", "q4", "q5"), sep = " - ") %>%
  mutate(datadate = as.POSIXct(datadate, format = "%b %d %Y, %H:%M:%S")) %>%
  mutate(across(q1:q5, as.integer)) %>%
  left_join(Anotes_tbl, by = "parnum") %>%
  filter(is.na(notes))
ABclean_tbl <- Bdata_tbl %>%
  mutate(datadate = as.POSIXct(datadate, format = "%b %d %Y, %H:%M:%S")) %>%
  mutate(across(q1:q10, as.integer)) %>%
  left_join(Bnotes_tbl, by = "parnum") %>%
  filter(is.na(notes)) %>%
  bind_rows(A = Aclean_tbl, B = ., .id = "lab") %>%
  select(-notes)