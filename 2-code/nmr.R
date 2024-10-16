library(tidyverse)
library(nmrrr)
theme_set(theme_bw(base_size = 14))


spectra = nmrrr::nmr_import_spectra(path = "1-data/nmr/adsorptive_fractionation2023/processed-spectra", method = "mnova")
spectra2 = 
  spectra %>% 
  filter(ppm >= -1 & ppm <= 10) %>% 
  nmr_assign_bins(binset = bins_Hertkorn2013) %>% 
#  filter(group != "oalkyl") %>% 
  mutate(intensity = if_else(intensity < 0, 0, intensity))

nmr_plot_spectra(spectra2, 
                 binset = bins_Hertkorn2013,
                 label_position = 8,
                 stagger = 0.5,
                 mapping = aes(x = ppm, y = intensity, 
                               group = sampleID,
                               color = group))+
  ylim(0, 10)+
  xlim(10, -1)



peaks = nmrrr::nmr_import_peaks(path = "1-data/nmr/adsorptive_fractionation2023/processed-peaks", method = "single column")
peaks2 = peaks %>% nmr_assign_bins(bins_Hertkorn2013) %>% 
  filter(!grepl("Solvent", `Impurity/Compound`)) %>% 
  filter(`Impurity/Compound` == "Compound")


relabund = nmr_relabund(peaks2, method = "peaks")

relabund %>% 
  ggplot(aes(x = sampleID, y = relabund, fill = group))+
  geom_bar(stat = "identity")
