
library(tidyverse)
library(googlesheets4)
theme_set(theme_bw(base_size = 14))

sample_key = read_sheet("https://docs.google.com/spreadsheets/d/1ix8ckXv4hwVZ6KBD4ke_BHO_8iBe87CFBCUb7YbS-9E/edit?gid=0#gid=0")


# DOC ----
doc_df = read.csv("1-data/doc/2023-09-07_kfp_adsorption_round2.csv", header = T, skip = 10)
doc = doc_df %>% 
  janitor::clean_names() %>% 
  dplyr::select(sample_name, result_npoc) %>% 
  left_join(sample_key) %>% 
  dplyr::select(-phase) %>% 
  filter(!is.na(horizon))

doc %>% 
  filter(horizon == "A horizon") %>% 
  ggplot(aes(x = treatment, y = result_npoc))+
  geom_point()+
  geom_hline(yintercept = 53, linetype = "dashed")+
  labs(x = "", y = "DOC, mg/L")
