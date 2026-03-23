## KJH 03/19/2026:
# Hiersche, Osher, Saygin (2026) Functional Dissociation of Language and Theory of Mind in the Developing Superior Temporal Lobe. Communications Biology
  # these statistics were done using "R version 4.5.1 (2025-06-13 ucrt)"
# this script provides template for calculating the rmANOVA results for Table 1, Table S2 and Table S3

# note, you may need to do install.packages('packagename') for any packages you have not previously used
library(rstatix)
library(tidyverse)
library(ggpubr)
library(lme4)
library(lmerTest)
library(MASS)
library(dplyr)
library(sjPlot)
library(sjmisc)
library(ggplot2)
library(emmeans)

# the necessary dataframe can be found on: https://github.com/SayginLab/STL_languageToM
  # the data that created the dataframe formatted for R was made with 
      # this data: df_Hiersche_2026_CommBio_selectivity_overlap_motion.mat
      # this code: Hiersche_2026_CommBio_allstats.m

setwd('')
  # set this to your directory
fROIsel <- readxl::read_xlsx("Hiersche_2026_CommBio_rmANOVA_data.xlsx",sheet='kidsEnTx')
  # depending on the table you are trying to recreate, you will need to load different sheets
    # kidsEnTx, adultsEnTx: used for main text table 1 results
    # kidsmotmatchEnTx, adultsmotmatchEnTx: used for table S2
    # kidsEnNs, adultsEnNs: used for table S3

# a rmANOVA was done for each of the networks: 
  #primary netowrks: LHLang,RHLang,LHToM,RHToM
  #margins: LHAngGyr (margin of lang), RHAngGyr (margin of lang), RHSTS (margin of ToM)
# that means the below steps should be repeated for each network, for each sample

##########
# Step 1 # identify missing data
##########
  # you need to know the subj id of anyone with missing value
  # so that you can remove them before doing the rmANOVA (which requires complete data)
  # reminder, missing data are really outliers
nasub=list(fROIsel[is.na(fROIsel$LHLang),1]) # change LHLang to each other network to re-create the stats
nasub # these subjects should be removed

# if there are na subs, list them below:
fROI <- fROIsel %>% filter( sub!='subK003_01' & sub!='subK007_02' & sub!='subK010_02' & sub!='subK025_01') #  & sub!='subK025_01'  & sub!='subK037_01')   # this removes the na subs from the df
# use this to remove multiple subjects:
  # fROI <- fROIsel %>% filter(sub!='sub001_01'  & sub!='sub002_01' & ...) # 

# if there are NO na subs, just rename the fROIsel dataframe
fROI <- fROIsel

# when checking positive subjects for r-lang, only exclude subs with negative lang value
fROI <- fROIsel %>% filter( sub!='subK009_01' & sub!='subK008_01' & sub!='subK012_01' & sub!='subK014_01'  & sub!='subK022_01'  & sub!='subK022_02' & sub!='subK023_01' & sub!='subK031_02' & sub!='subK034_02' & sub!='subK036_01' & sub!='subK038_01' & sub!='subK039_03' & sub!='subK022_02')  


##########
# Step 2 # do the rmANOVA
##########

fROIsel_aov <- fROI %>% anova_test(LHLang ~  task+fwd, wid='sub')
get_anova_table(fROIsel_aov)

##########
# Step 3 # do the post-hoc t-tests 
##########
# only include the fROIs with a significant task effect
fROIsel_long <- fROIsel %>% gather(key="fROI", value="sel",LHLang,RHLang,LHToM,RHToM)
  #fROIsel_long <- fROI %>% gather(key="fROI", value="sel",RHLang) # use this for when checking positive subs only for EnNs kids RH Lang

pwc2 <- fROIsel_long %>%
  group_by(fROI) %>%
  pairwise_t_test(
    sel ~ task, paired = TRUE,
    p.adjust.method = "holm", na.rm=TRUE,
  )
pwc2
cohens <- fROIsel_long %>%
  group_by(fROI) %>%
  cohens_d(
    sel ~ task, paired = TRUE, ci=TRUE ,
  )
cohens


