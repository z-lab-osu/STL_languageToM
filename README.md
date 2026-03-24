# STL_languageToM
Repository for 
> Hiersche, Osher, Saygin (2026) Functional Dissociation of Language and Theory of Mind in the Developing Superior Temporal Lobe. Communications Biology
## File Overview
1. Hiersche_2026_CommBio_rmANOVA_code.R: This contains the code for replicating the rmANOVA used to compare language and ToM selectivity
   
2. Hiersche_2026_CommBio_rmANOVA_data.xlsx: This contains the selectivity, with outliers removed, for different samples reported in the manuscript (all kids (Sn vs Tx: main text; Sn vs Ns: supplemental), all adults (Sn vs Tx: main text; Sn vs Ns: supplemental), motion matched kids (Sn vs Tx; supplemental), motion matched adults (Sn vs Tx; supplemental)
   
3. Hiersche_2026_CommBio_stats.m: This file contains code for reproducing all stats in the manuscript (except the rmANOVA, for which need to use R code). This can be used to get the data that is listed in rmANOVA_data. It also reproduces the tables & figures. Each section allows you to change the sample to the group that you want the results for.

# Data Stuctures Overview
Hiersche_2026_CommBio_dataframe.mat:

df:Contains all subject lists (de-identified), motion, age, selectivity, and overlap (dice & dice perm variables) information.

- subs: The order of these lists matches the order of the data in each other structure. This also shows all possible samples used across the paper. CF are the connectivity fingerprinting samples, motmatch are the samples where motion during the lang and ToM tasks are not different. TP1 and TP2 are the time point 1 and time point 2 child longitudinal data (different samples for modeling and selectivity/overlap analyses). Kids and Adults are the main cross sectional samples for the primary results reported in the manuscript. 

- motion: Mean framewise displacement across tasks and during the resting state scan, where applicable. Stats in the manuscript were done with the 	average 	fwd for the two language runs. The ToM task motion is in the partlycloudy_rc_new variable or other PC variable. Note: all subjects only did 1 run of partly cloudy so column 2 motion will always be nan. All cross sectional samples and TP2 should have 2 runs of language, but some TP1 might only have 1 run of language. 

- ages: Rounded ages for each subject (to protect subject identity). For exact ages, please contact saygin.3@osu.edu. Exact ages were used in	the manuscript. 

- dice: This variable has the overlap of the language and ToM hotspots across the 8 percentiles listed in the percentiles variable. Rows are subjects, aligning with the df.subs variable. EnNs are for supplemental results using Sn>Ns contrast to define language, EnTx are for the main text reported results of Sn>Tx to define language. The overlap within hemisphere is in subject specific space, the overlap across hemisphere is with data registered to fs-symmetric. 

- diceperm: Results of the spin tests. It has the real overlap (on fs-symmetric) and the pval after doing 1000 spin-based permutations for each subject. Dimension 1 is subjects, dimension 2 is the comparison (1: LH Lang overlap with LH ToM , 2: RH Lang with LH ToM , 3: LH Lang overlap with  RH ToM; 4: RH Lang overlap with RH ToM), dimension 3: the percentiles in percentile variable.

- langsel (tomself): This is the selectivity of each of the fROIs (in ROInames variable) to language (or ToM) for all samples. These fROIs were combined into networks (see methods section).

- langsel1 (tomsel): This is the selectivity of each of the fROIs (in ROInames) to language (or ToM) for all samples for the networks in the network variable.

cfmodelresults: Contains the correlation values between observed and predicted language or ToM activation across different types of models run for each sample 
    - selfprediction: The model performance (R value) when using a subject's own connectivity to predict function.

    - wrongBpred: The model performance when using a subject's own connectivity data, but the beta values from the opposite task.

    - otherpred: The model performance when using each other subject's connectivity to predict activation. Rows - subject; columns - other subjects. 
    
    - betas: These are the beta values for each subject's model for all 145 predictors in the variable regions.
    - meanbetas: These are the mean beta values across subjects for each sample (kids and adults separate).

