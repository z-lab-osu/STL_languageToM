%% KJH 03/182026
% code for reproducing all statistics in Hiersche, Osher, Saygin (2026)
% Functional Dissociation of Language and Theory of Mind in the Developing
% Superior Temporal Lobe. Communications Biology

% code and data are all available on https://github.com/SayginLab/STL_languageToM

% most analyses were performed in matlab (version 2024a)
% some anlayses were performed in R Studio
%% load all data 
% this is the selectivity & overlap data data 
    load('df_LangToM_STL_github.mat')

%% Do fROIs show selectivity to lang or ToM?
% stats for table S1
% output of interest is table_lang and table_ToM
    % column 1: t-stat (dof) for selectivity vs 0 one-tailed t-test
    % column 2: p value (*p<0.05, **p0.05 after bonferroni-holm correction
    % for 7 comparisons)
    % column 3: Cohen's D [95% CI]
    % the columns are the 7 networks of interest in the network variable

group='kidsEnTx'; % or adultsEnTx or the EnNs versions for supplemental 
for i=1:length(networks)
    [~,plangv0(i,1),~,stats]=ttest(df.langsel1.(group)(:,i),0,'tail','right');
    [~,ptomv0(i,1),~,stats]=ttest(df.tomsel1.(group)(:,i),0,'tail','right');
end

for i=1:length(networks)
    ROI=i;
    [~,p,~,stats]=ttest(df.langsel1.(group)(:,i),0,'tail','right');
    results.Lang.(group)(i,1)=stats.tstat;
    results.Lang.(group)(i,2)=p;
    results.Lang.(group)(i,3)=stats.df;  
    d=meanEffectSize(df.langsel1.(group)(:,i),'Effect','cohen');
    results.Lang.(group)(i,5)=table2array(d(1,1));   
    ci.lang(i,:)=table2array(d(1,2));
    % ToM v O
    [~,p,~,stats]=ttest(df.tomsel1.(group)(:,i),0,'tail','right');
    results.ToM.(group)(i,1)=stats.tstat;
    results.ToM.(group)(i,2)=p;
    results.ToM.(group)(i,3)=stats.df; 
    d=meanEffectSize(df.tomsel1.(group)(:,i),'Effect','cohen');
    results.ToM.(group)(i,5)=table2array(d(1,1)); 
    ci.ToM(i,:)=table2array(d(1,2));
end

% do multiple comparison correction 
%results.LANGvToM.(group)(:,4)=bonf_holm(results.LANGvToM.(group)(:,2));
results.Lang.(group)(:,4)=bonf_holm(results.Lang.(group)(:,2));
results.ToM.(group)(:,4)=bonf_holm(results.ToM.(group)(:,2));

% prep the Lang table 
for i=1:length(networks)
    pval=results.Lang.(group)(i,2);
    pval_bf=results.Lang.(group)(i,4);
    dval=results.Lang.(group)(i,5);
    table_lang{i,1} = sprintf('%2.2f (%d)',results.Lang.(group)(i,1),results.Lang.(group)(i,3));
    if pval < 0.05 && pval_bf > 0.05
    table_lang{i,2} = sprintf('%0.5g*',pval);
    elseif pval <0.05 && pval_bf <0.05
    table_lang{i,2} = sprintf('%0.5g**',pval);
    else 
    table_lang{i,2} = sprintf('%0.5g',pval);
    end                
    table_lang{i,3} = sprintf('%2.2f, [%2.2f,%2.2f] ',dval,ci.lang(i,1),ci.lang(i,2));
end

% prep the ToM table for i=1:length(plotROIs)
for i=1:length(networks)
    pval=results.ToM.(group)(i,2);
    pval_bf=results.ToM.(group)(i,4);
    dval=results.ToM.(group)(i,5);
    table_ToM{i,1} = sprintf('%2.2f (%d)',results.ToM.(group)(i,1),results.ToM.(group)(i,3));
    if pval < 0.05 && pval_bf > 0.05
    table_ToM{i,2} = sprintf('%0.5g*',pval);
    elseif pval <0.05 && pval_bf <0.05
    table_ToM{i,2} = sprintf('%0.5g**',pval);
    else 
    table_ToM{i,2} = sprintf('%0.5g',pval);
    end                
    table_ToM{i,3} = sprintf('%2.2f, [%2.2f,%2.2f] ',dval,ci.ToM(i,1),ci.ToM(i,2));
end

tablev0=[table_lang;table_ToM];


%% Plot Figure 1A
group='kidsEnTx'; % or 'kidsEnTx' 'adultsEnTx'

meanselkid=[nanmean(df.langsel.(group)(:,[1,2]),'all'),nanmean(df.tomsel.(group)(:,[1,2]),'all');nanmean(df.langsel.(group)(:,[6,7]),'all'),nanmean(df.tomsel.(group)(:,[6,7]),'all');nanmean(df.langsel.(group)(:,[5]),'all'),nanmean(df.tomsel.(group)(:,[5]),'all');nanmean(df.langsel.(group)(:,[10]),'all'),nanmean(df.tomsel.(group)(:,[10]),'all')];
steselkid=[nanste(nanmean(df.langsel.(group)(:,[1,2]),2)),nanste(nanmean(df.tomsel.(group)(:,[1,2]),2));nanste(nanmean(df.langsel.(group)(:,[6,7]),2)),nanste(nanmean(df.tomsel.(group)(:,[6,7]),2));nanste(nanmean(df.langsel.(group)(:,[5]),2)),nanste(nanmean(df.tomsel.(group)(:,[5]),2));nanste(nanmean(df.langsel.(group)(:,[10]),2)),nanste(nanmean(df.tomsel.(group)(:,[10]),2))];

errorbar_groups(meanselkid',steselkid')
hold on
scatter(ones([length(df.langsel.(group)(:,1)),1])*1.05,nanmean(df.langsel.(group)(:,[1,2]),2),'k')
scatter(ones([length(df.langsel.(group)(:,1)),1])*3.05,nanmean(df.langsel.(group)(:,[6,7]),2),'k')
scatter(ones([length(df.langsel.(group)(:,1)),1])*5.05,nanmean(df.langsel.(group)(:,5),2),'k')
scatter(ones([length(df.langsel.(group)(:,1)),1])*7.05,df.langsel.(group)(:,10),'k')

scatter(ones([length(df.tomsel.(group)(:,1)),1])*1.95,nanmean(df.tomsel.(group)(:,[1,2]),2),'k')
scatter(ones([length(df.tomsel.(group)(:,1)),1])*3.95,nanmean(df.tomsel.(group)(:,[6,7]),2),'k')
scatter(ones([length(df.tomsel.(group)(:,1)),1])*5.95,nanmean(df.tomsel.(group)(:,5),2),'k')
scatter(ones([length(df.tomsel.(group)(:,1)),1])*7.95,nanmean(df.tomsel.(group)(:,10),2),'k')

legend({'Lang','ToM'})
xticklabels({'LH Lang','RH Lang','LH TPJ','RH TPJ'})
ylabel({'Selectivity'})
title(group)
ylim([-1 2])

%% Are language and ToM regions functionally distinct 
% this code if for reproducing Table 1
    % to make table S2, use motmatch groups
    % to make table S3, use the EnNs groups
% prep the data for rmANOVA:
clear sels task sub fwd aovtable
group='adultsmotmatchEnTx'; subgroup='adultsmotmatch'; % sub group just needs to have the number of subjects 
sels=[df.langsel1.(group);df.tomsel1.(group)];
task=[repmat({'lang'},[length(sels)/2,1]);repmat({'tom'},[length(sels)/2,1])]; %lang 0, ToM 1
sub=[df.subs.(subgroup);df.subs.(subgroup)]; % subject 
if contains(group,'kids')
fwd=[mean(df.motion.(subgroup).mean_fwd.lang,2);df.motion.(subgroup).mean_fwd.partlycloudy_rc_new(:,1)]; % fwd 
else
% for adults 
fwd=[mean(df.motion.(subgroup).lang,2);df.motion.(subgroup).pc]; % fwd 
end
aovtable=table(sub,task,sels,fwd);
    % see R studio script for calculating rmANOVAs

%% table S4, differentiation with age
% outcome of cross sectional correlation is in rlang and rtom
    % column 1: r value
    % column 2: p value
    % column 3: p value after bonferroni holm correction
    % rows are the 7 networks 
% longitudinal results are in ltp12: language changes across TPs; ttp12:
% ToM changes across TPs
group='kidsEnTx';con='EnTx'; %  
for i=1:length(networks)
    [rlang(i,1),rlang(i,2)]=partialcorr(df.langsel1.(group)(:,i),df.ages.kids,mean(df.motion.kids.mean_fwd.lang,2),'rows','complete');
    [rtom(i,1),rtom(i,2)]=partialcorr(df.tomsel1.(group)(:,i),df.ages.kids,df.motion.kids.mean_fwd.partlycloudy_rc_new(:,1),'rows','complete');
   
   [~,pl(i,1),~,stats]=ttest(df.langsel1.(['kidslongTP1' con])(:,i),df.langsel1.(['kidslongTP2' con])(:,i));
   ltp12(i,1)=strcat('t(' ,string(stats.df), ')=',string(round(stats.tstat,2)) );
  [~,pt(i,1),~,stats]=ttest(df.tomsel1.(['kidslongTP1' con])(:,i),df.tomsel1.(['kidslongTP2' con])(:,i));
   ttp12(i,1)=strcat('t(' ,string(stats.df), ')=',string(round(stats.tstat,2)) );
end
rlang(:,3)=bonf_holm(rlang(:,2));
rtom(:,3)=bonf_holm(rtom(:,2));
%scatter(df.xsec.ages,tomsel1.xsec(:,1))

rtable=[rlang(:,1:2),rtom(:,1:2)];

%% figure 1B overlap 
kidgroup='kidsEnTx';
adultgroup='adultsEnTx';

thresholds={'1%','2%','3%','4%','5%','10%','20%','30%'};
for i=1:length(thresholds)
sgtitle('LH STL')
subplot(2,4,i)
histogram(df.dice.(kidgroup).dice.LH_STL(:,i),'NumBins',8)
hold on
histogram(df.dice.(adultgroup).dice.LH_STL(:,i),'NumBins',8)
title(thresholds{i})
ylabel('subject count')
xlabel('overlap')
legend('off')
ylim([0 50])
xlim([0 .60])
end

figure
thresholds={'1%','2%','3%','4%','5%','10%','20%','30%'};
for i=1:length(thresholds)
sgtitle('RH STL')
subplot(2,4,i)
histogram(df.dice.(kidgroup).dice.RH_STL(:,i),'NumBins',8)
hold on
histogram(df.dice.(adultgroup).dice.RH_STL(:,i),'NumBins',8)
title(thresholds{i})
ylabel('subject count')
xlabel('overlap')
legend('off')
ylim([0 50])
xlim([0 .60])
end
%% figure 1C: dice overlap
group='kidsEnTx'; % change to adultsEnTx to plot adults 
prct={'1','2','3','4','5','10','20','30'};
for i=1:length(prct)
meandice=squeeze(mean(df.diceperm.(group).real_dice));
    %sig_dice=1-(sum(df.diceperm.(group).pval_dice(:,:,i)<0.05)./size(df.spin.(group).pval_dice,1));
subplot(2,4,i)
imagesc([meandice(1:2,i),meandice(3:4,i)])
hold on
title(sprintf('%s',prct{i}))
colorbar
sgtitle(group,'FontSize',25)
clim([0 1])
xticks([1 2])
%xticklabels({'LH Lang','RH Lang'})
yticks([1 2])
%yticklabels({'LH ToM','RH ToM'})
set(gcf,'color','w'); % set graph parameters 
set(gca,'box','off','LineWidth',1.5,'FontSize',20);
set(gca,'TickLabelInterpreter','none') % interpreter none is helpful for plotting names with '_'
set(gcf,'renderer','painters'); % your plots are made slower but prettier 

end


%% overlap stats in text  

% adult results listed in text
% mean and std of overlap
mean(df.dice.adultsEnTx.dice.LH_STL)
std(df.dice.adultsEnTx.dice.LH_STL)
% percent overlap similar to change 
sum(squeeze(df.diceperm.adultsEnTx.pval_dice(:,1,:))>=0.05)/length(df.subs.adults)

mean(df.dice.adultsEnTx.dice.RH_STL)
std(df.dice.adultsEnTx.dice.RH_STL)
sum(squeeze(df.diceperm.adultsEnTx.pval_dice(:,4,:))>=0.05)/length(df.subs.adults)

% LH to RH overlap 
LHlang_RHToM=[squeeze(mean(df.diceperm.adultsEnTx.real_dice(:,3,:))),squeeze(std(df.diceperm.adultsEnTx.real_dice(:,3,:)))]
sum(squeeze(df.diceperm.adultsEnTx.pval_dice(:,3,:))>=0.05)/length(df.subs.adults)

% kids results 
mean(df.dice.kidsEnTx.dice.LH_STL)
std(df.dice.kidsEnTx.dice.LH_STL)
sum(squeeze(df.diceperm.kidsEnTx.pval_dice(:,1,:))>=0.05)/length(df.subs.kids)

mean(df.dice.kidsEnTx.dice.RH_STL)
std(df.dice.kidsEnTx.dice.RH_STL)
sum(squeeze(df.diceperm.kidsEnTx.pval_dice(:,4,:))>=0.05)/length(df.subs.kids)

LHlang_RHToM=[squeeze(mean(df.diceperm.kidsEnTx.real_dice(:,3,:))),squeeze(std(df.diceperm.kidsEnTx.real_dice(:,3,:)))]
sum(squeeze(df.diceperm.kidsEnTx.pval_dice(:,3,:))>=0.05)/length(df.subs.kids)

%% overlap stats in table 2
% output of interest is ov
    % column 1: mean (std) % similar change for LH overlap
    % column 2: mean (std) % similar change for RH overlap
    % column 3: mean (std) % similar change for LH lang-RH ToM overlap
    % the rows are the different threshold for making hotspot fROI: 1%-5%,
    % 10%,20%,30%

% change to motmatch for Table S5
% change the group to EnNs for Table S6
group='adultsEnNs';group1='adults';
for i=1:8
meanov=nanmean(df.dice.(group).dice.LH_STL(:,i));
stdov=nanstd(df.dice.(group).dice.LH_STL(:,i));
perc_chance=(sum(squeeze(df.diceperm.(group).pval_dice(:,1,i))>=0.05)./length(df.subs.(group1)))*100;
ov{i,1} = sprintf('%2.3f (%2.3f); %2.1f%%',meanov,stdov,perc_chance);
meanov=nanmean(df.dice.(group).dice.RH_STL(:,i));
stdov=nanstd(df.dice.(group).dice.RH_STL(:,i));
perc_chance=(sum(squeeze(df.diceperm.(group).pval_dice(:,4,i))>=0.05)./length(df.subs.(group1)))*100;
ov{i,2} = sprintf('%2.3f (%2.3f); %2.1f%%',meanov,stdov,perc_chance);
meanov=nanmean(df.diceperm.(group).real_dice(:,3,i));
stdov=nanstd(df.diceperm.(group).real_dice(:,3,i));
perc_chance=(sum(squeeze(df.diceperm.(group).pval_dice(:,3,i))>=0.05)./length(df.subs.(group1)))*100;
ov{i,3} = sprintf('%2.3f (%2.3f); %2.1f%%',meanov,stdov,perc_chance);
end
%% overlap and age changes 
% table S7
% for table S8, use EnNs results 

% this is cross sectional results: results.ovcor
    % column 1: r value
    % column 2: pval
    % column 3: bonferrnoi-holm p val
    % rows: thresholds, 1-5%, 10%, 20%, 30%
sec={'LH_STL','RH_STL'};
group='kidsEnNs'; group1='kids';
motion=nanmean([df.motion.(group1).mean_fwd.lang,df.motion.(group1).mean_fwd.partlycloudy_rc_new],2);
for s=1:length(sec)
for i=1:8
    
 [r,p]=partialcorr(df.dice.(group).dice.(sec{s})(:,i),df.ages.(group1),motion);
 results.ovcor.(group).(sec{s})(i,1)=r;
 results.ovcor.(group).(sec{s})(i,2)=p;
 
 [r,p]=partialcorr(squeeze(df.diceperm.(group).real_dice(:,3,i)),df.ages.(group1),motion);
 results.ovcor.(group).LHlangRHToM(i,1)=r;
 results.ovcor.(group).LHlangRHToM(i,2)=p;


end
end

results.ovcor.(group).RH_STL(:,3)=bonf_holm(results.ovcor.(group).RH_STL(:,2));
results.ovcor.(group).LH_STL(:,3)=bonf_holm(results.ovcor.(group).LH_STL(:,2));
results.ovcor.(group).LHlangRHToM(:,3)=bonf_holm(results.ovcor.(group).LHlangRHToM(:,2));


% this is the longitudinal results: results.ovttest.long 
    % table results are ov_tp
    % column 1: t stat (dof)
    % column 2: p value 
    % column 3: cohen's D
    % column 4: cohen's d 95% CI
    % rows are the 8 thresholds (1%-5%,10%,20%,30%)
groupTP1='kidslongTP1EnNs';
groupTP2='kidslongTP2EnNs';
sec={'LH_STL','RH_STL'};

for s=1:length(sec)
    for i=1:8
    [~,p,~,stats]=ttest(df.dice.(groupTP1).dice.(sec{s})(:,i),df.dice.(groupTP2).dice.(sec{s})(:,i));
    cd=meanEffectSize(df.dice.(groupTP1).dice.(sec{s})(:,i),df.dice.(groupTP2).dice.(sec{s})(:,i),'Effect','cohen');

    results.ovttest.long.(sec{s})(i,1)=stats.tstat;
    results.ovttest.long.(sec{s})(i,2)=stats.df;
    results.ovttest.long.(sec{s})(i,3)=p;
    ci=string(round(table2array(cd(1,2)),2));
    ov_tp.(sec{s}){i,1} = sprintf('%2.2f (%d)',stats.tstat,stats.df);
    ov_tp.(sec{s}){i,2} = sprintf('%2.2f',p);
    ov_tp.(sec{s}){i,3} = sprintf('%2.2f,',table2array(cd(1,1)));
    ov_tp.(sec{s}){i,4} = sprintf('[%s,%s]',ci(1),ci(2));
    end
end
  results.ovttest.long.LH_STL(:,4)=bonf_holm( results.ovttest.long.LH_STL(:,3));
  results.ovttest.long.RH_STL(:,4)=bonf_holm( results.ovttest.long.RH_STL(:,3));

for i=1:8
    [~,p,~,stats]=ttest(df.diceperm.(groupTP1).real_dice(:,i),squeeze(df.diceperm.(groupTP2).real_dice(:,3,i)));
    cd=meanEffectSize(df.diceperm.(groupTP1).real_dice(:,i),squeeze(df.diceperm.(groupTP2).real_dice(:,3,i)),'Effect','cohen');

    results.ovttest.long.LHlang_RHToM(i,1)=stats.tstat;
    results.ovttest.long.LHlang_RHToM(i,2)=stats.df;
    results.ovttest.long.LHlang_RHToM(i,3)=p;
    ci=string(round(table2array(cd(1,2)),2));
    ov_tp.LHlang_RHToM{i,1} = sprintf('%2.2f (%d)',stats.tstat,stats.df);
    ov_tp.LHlang_RHToM{i,2} = sprintf('%2.2f',p);
    ov_tp.LHlang_RHToM{i,3} = sprintf('%2.2f,',table2array(cd(1,1)));
    ov_tp.LHlang_RHToM{i,4} = sprintf('[%s,%s]',ci(1),ci(2));
end

%% predicting adult STL activation 
group='kids'; % 'kids'
    % set the group to either kids or adults depending on stats you are
    % trying to reproduce 
% language activation prediction 
% get mean and std of self prediction (using a subject's own connectivity
mean(cfmodelresults.(group).selfprediction.lh.R2_EnTx_lang)
std(cfmodelresults.(group).selfprediction.lh.R2_EnTx_lang)
mean(cfmodelresults.(group).selfprediction.rh.R2_EnTx_lang)
std(cfmodelresults.(group).selfprediction.rh.R2_EnTx_lang)

% get mean and std of other prediction (using each other subs connectivty)
mean(cfmodelresults.(group).otherpred.lh.R2_EnTx_lang,'all')
std(mean(cfmodelresults.(group).otherpred.lh.R2_EnTx_lang,2))
mean(cfmodelresults.(group).otherpred.rh.R2_EnTx_lang,'all')
std(mean(cfmodelresults.(group).otherpred.rh.R2_EnTx_lang,2))
% self v other t-test: do fischer z transform 
[~,p,~,stats]=ttest(atanh(cfmodelresults.(group).selfprediction.lh.R2_EnTx_lang),mean(atanh(cfmodelresults.(group).otherpred.lh.R2_EnTx_lang),2))
meanEffectSize(atanh(cfmodelresults.(group).selfprediction.lh.R2_EnTx_lang),mean(atanh(cfmodelresults.(group).otherpred.lh.R2_EnTx_lang),2),Effect="cohen")
[~,p,~,stats]=ttest(atanh(cfmodelresults.(group).selfprediction.rh.R2_EnTx_lang),mean(atanh(cfmodelresults.(group).otherpred.rh.R2_EnTx_lang),2))
meanEffectSize(atanh(cfmodelresults.(group).selfprediction.rh.R2_EnTx_lang),mean(atanh(cfmodelresults.(group).otherpred.rh.R2_EnTx_lang),2),Effect="cohen")

% ToM activation prediction 
% get mean and std of self prediction (using a subject's own connectivity
mean(cfmodelresults.(group).selfprediction.lh.R2_MntlPain_ToM)
std(cfmodelresults.(group).selfprediction.lh.R2_MntlPain_ToM)
mean(cfmodelresults.(group).selfprediction.rh.R2_MntlPain_ToM)
std(cfmodelresults.(group).selfprediction.rh.R2_MntlPain_ToM)

% get mean and std of other prediction (using each other subs connectivty)
mean(cfmodelresults.(group).otherpred.lh.R2_MntlPain_ToM,'all')
std(mean(cfmodelresults.(group).otherpred.lh.R2_MntlPain_ToM,2))
mean(cfmodelresults.(group).otherpred.rh.R2_MntlPain_ToM,'all')
std(mean(cfmodelresults.(group).otherpred.rh.R2_MntlPain_ToM,2))
% self v other t-test: do fischer z transform 
[~,p,~,stats]=ttest(atanh(cfmodelresults.(group).selfprediction.lh.R2_MntlPain_ToM),mean(atanh(cfmodelresults.(group).otherpred.lh.R2_MntlPain_ToM),2))
meanEffectSize(atanh(cfmodelresults.(group).selfprediction.lh.R2_MntlPain_ToM),mean(atanh(cfmodelresults.(group).otherpred.lh.R2_MntlPain_ToM),2),Effect="cohen")
[~,p,~,stats]=ttest(atanh(cfmodelresults.(group).selfprediction.rh.R2_MntlPain_ToM),mean(atanh(cfmodelresults.(group).otherpred.rh.R2_MntlPain_ToM),2))
meanEffectSize(atanh(cfmodelresults.(group).selfprediction.rh.R2_MntlPain_ToM),mean(atanh(cfmodelresults.(group).otherpred.rh.R2_MntlPain_ToM),2),Effect="cohen")

%% model fit and age correlations

[r,p]=partialcorr(atanh(cfmodelresults.kids.selfprediction.lh.R2_EnTx_lang),df.ages.kidscf,df.motion.kidscf.restmot.fwd)
[r,p]=partialcorr(atanh(cfmodelresults.kids.selfprediction.rh.R2_EnTx_lang),df.ages.kidscf,df.motion.kidscf.restmot.fwd)

[r,p]=partialcorr(atanh(cfmodelresults.kids.selfprediction.lh.R2_MntlPain_ToM),df.ages.kidscf,df.motion.kidscf.restmot.fwd)
[r,p]=partialcorr(atanh(cfmodelresults.kids.selfprediction.rh.R2_MntlPain_ToM),df.ages.kidscf,df.motion.kidscf.restmot.fwd)

%% model fit across TPs
TP1self.lh.lang=diag(cfmodelresults.kidsTP1.selfprediction.lh.R2_EnTx_lang);
TP1self.rh.lang=diag(cfmodelresults.kidsTP1.selfprediction.rh.R2_EnTx_lang);
TP1self.lh.ToM=diag(cfmodelresults.kidsTP1.selfprediction.lh.R2_MntlPain_ToM);
TP1self.rh.ToM=diag(cfmodelresults.kidsTP1.selfprediction.rh.R2_MntlPain_ToM);

mean(TP1self.lh.lang)
std(TP1self.lh.lang)
mean(TP1self.rh.lang)
std(TP1self.rh.lang)

mean(TP1self.lh.ToM)
std(TP1self.lh.ToM)
mean(TP1self.rh.ToM)
std(TP1self.rh.ToM)

[~,tp2_idx]=intersect(df.subs.kidscf,df.subs.kidscfTP2);
TP2self.lh.lang=cfmodelresults.kids.selfprediction.lh.R2_EnTx_lang(tp2_idx);
TP2self.rh.lang=cfmodelresults.kids.selfprediction.rh.R2_EnTx_lang(tp2_idx);
TP2self.lh.ToM=cfmodelresults.kids.selfprediction.lh.R2_MntlPain_ToM(tp2_idx);
TP2self.rh.ToM=cfmodelresults.kids.selfprediction.rh.R2_MntlPain_ToM(tp2_idx);

[~,p,~,stats]=ttest(atanh(TP1self.lh.lang),atanh(TP2self.lh.lang))
meanEffectSize(atanh(TP1self.lh.lang),atanh(TP2self.lh.lang),Effect='cohen')
[~,p,~,stats]=ttest(atanh(TP1self.rh.lang),atanh(TP2self.rh.lang))
meanEffectSize(atanh(TP1self.rh.lang),atanh(TP2self.rh.lang),Effect='cohen')

[~,p,~,stats]=ttest(atanh(TP1self.lh.ToM),atanh(TP2self.lh.ToM))
meanEffectSize(atanh(TP1self.lh.ToM),atanh(TP2self.lh.ToM),Effect='cohen')
[~,p,~,stats]=ttest(atanh(TP1self.rh.ToM),atanh(TP2self.rh.ToM))
meanEffectSize(atanh(TP1self.rh.ToM),atanh(TP2self.rh.ToM),Effect='cohen')


%% Plot Figure 2A
group='adults';  subs=length(df.subs.adultscf);
    % change to kids and df.subs.kidscf when plotting kids 
clear predcorr predcorr_b predcorr_other
predcorr(:,1)=cfmodelresults.(group).selfprediction.lh.R2_EnTx_lang;
predcorr(:,2)=cfmodelresults.(group).selfprediction.rh.R2_EnTx_lang;
predcorr(:,3)=cfmodelresults.(group).selfprediction.lh.R2_MntlPain_ToM;
predcorr(:,4)=cfmodelresults.(group).selfprediction.rh.R2_MntlPain_ToM;

predcorr_other(:,1)=mean(cfmodelresults.(group).otherpred.lh.R2_EnTx_lang,2);
predcorr_other(:,2)=mean(cfmodelresults.(group).otherpred.rh.R2_EnTx_lang,2);
predcorr_other(:,3)=mean(cfmodelresults.(group).otherpred.lh.R2_MntlPain_ToM,2);
predcorr_other(:,4)=mean(cfmodelresults.(group).otherpred.rh.R2_MntlPain_ToM,2);

predcorr_b(:,1)=cfmodelresults.(group).wrongBpred.lh.R2_EnTx_lang;
predcorr_b(:,2)=cfmodelresults.(group).wrongBpred.rh.R2_EnTx_lang;
predcorr_b(:,3)=cfmodelresults.(group).wrongBpred.lh.R2_MntlPain_ToM;
predcorr_b(:,4)=cfmodelresults.(group).wrongBpred.rh.R2_MntlPain_ToM;
xvals=errorbar_groups([mean(predcorr);mean(predcorr_other);mean(predcorr_b)],[ste(predcorr);ste(predcorr_other);ste(predcorr_b)]);
hold on
for i=1:length(xvals)
    xval=[ones([subs,1]).*(xvals(i)-0.9),ones([subs,1]).*xvals(i),ones([subs,1]).*(xvals(i)+0.9)];
    yval=[predcorr(:,i),predcorr_other(:,i),predcorr_b(:,i)];
    scatter(xval,yval,'k')
    for s=1:subs
    plot(xval(s,:),yval(s,:),'r')

    end
end
title([ group 'Model Performance'])
legend({'Self','Other','Opposite Task Betas'})
ylabel('Correlation Real and Predicted')
xticklabels({'Lang LH','Lang RH','ToM LH','ToM RH'})
set(gcf,'color','w');
set(gca,'box','off','LineWidth',2.5,'FontSize',15,'Layer', 'Top');

%% Figure 2B: TP1 vs TP2
subs=length(df.subs.kidscfTP1);
xvals=errorbar_groups([mean(TP1self.lh.lang),mean(TP1self.rh.lang),mean(TP1self.lh.ToM),mean(TP1self.rh.ToM);mean(TP2self.lh.lang),mean(TP2self.rh.lang),mean(TP2self.lh.ToM),mean(TP2self.rh.ToM)],[ste(TP1self.lh.lang),ste(TP1self.rh.lang),ste(TP1self.lh.ToM),ste(TP1self.rh.ToM);ste(TP2self.lh.lang),ste(TP2self.rh.lang),ste(TP2self.lh.ToM),ste(TP2self.rh.ToM)]);
hold on
title('Kids Longitudinal Model Fit')
xticklabels({'LH Lang','RH Lang','LH ToM','RH ToM'})
%xticklabels({'LH Lang','RH Lang'}); %;,'LH ToM','RH ToM'})

ylabel('Predicted-Actual Correlation')

scatter(ones([subs,1])*1.95,TP2self.lh.lang,'k')
scatter(ones([subs,1])*1.05,TP1self.lh.lang,'k')

scatter(ones([subs,1])*3.95,TP2self.rh.lang,'k')
scatter(ones([subs,1])*3.05,TP1self.rh.lang,'k')

scatter(ones([subs,1])*5.95,TP2self.lh.ToM,'k')
scatter(ones([subs,1])*5.05,TP1self.lh.ToM,'k')

scatter(ones([subs,1])*7.95,TP2self.rh.ToM,'k')
scatter(ones([subs,1])*7.05,TP1self.rh.ToM,'k')

for s=1:subs
  plot([1.05,1.95],[TP1self.lh.lang(s,1),TP2self.lh.lang(s,1)],'r')
  plot([3.05,3.95],[TP1self.rh.lang(s,1),TP2self.rh.lang(s,1)],'r')
  plot([5.05,5.95],[TP1self.lh.ToM(s,1),TP2self.lh.ToM(s,1)],'r')
  plot([7.05,7.95],[TP1self.rh.ToM(s,1),TP2self.rh.ToM(s,1)],'r')
end
legend({'TP1','TP2'})
set(gcf,'color','w');
set(gca,'box','off','LineWidth',2.5,'FontSize',15,'Layer', 'Top');

%% comparing across models for predicting lang and ToM

% adults lang v ToM
[~,p,~,stats]=ttest(atanh(cfmodelresults.adults.selfprediction.lh.R2_EnTx_lang),atanh(cfmodelresults.adults.selfprediction.lh.R2_MntlPain_ToM))
meanEffectSize(atanh(cfmodelresults.adults.selfprediction.lh.R2_EnTx_lang),atanh(cfmodelresults.adults.selfprediction.lh.R2_MntlPain_ToM),Effect="cohen")
[~,p,~,stats]=ttest(atanh(cfmodelresults.adults.selfprediction.rh.R2_EnTx_lang),atanh(cfmodelresults.adults.selfprediction.rh.R2_MntlPain_ToM))
meanEffectSize(atanh(cfmodelresults.adults.selfprediction.rh.R2_EnTx_lang),atanh(cfmodelresults.adults.selfprediction.rh.R2_MntlPain_ToM),Effect="cohen")

% children lang v ToM
[~,p,~,stats]=ttest(atanh(cfmodelresults.kids.selfprediction.lh.R2_EnTx_lang),atanh(cfmodelresults.kids.selfprediction.lh.R2_MntlPain_ToM))
meanEffectSize(atanh(cfmodelresults.kids.selfprediction.lh.R2_EnTx_lang),atanh(cfmodelresults.kids.selfprediction.lh.R2_MntlPain_ToM),Effect="cohen")
[~,p,~,stats]=ttest(atanh(cfmodelresults.kids.selfprediction.rh.R2_EnTx_lang),atanh(cfmodelresults.kids.selfprediction.rh.R2_MntlPain_ToM))
meanEffectSize(atanh(cfmodelresults.kids.selfprediction.rh.R2_EnTx_lang),atanh(cfmodelresults.kids.selfprediction.rh.R2_MntlPain_ToM),Effect="cohen")

%% Connectivity fingerprints for Language vs. ToM in the STL
[r_beta,p_beta]=corr([meanbetas.kids.R2_EnTx_lang.lh,meanbetas.kids.R2_EnTx_lang.rh,meanbetas.kids.R2_MntlPain_ToM.lh,meanbetas.kids.R2_MntlPain_ToM.rh,meanbetas.adults.R2_EnTx_lang.lh,meanbetas.adults.R2_EnTx_lang.rh,meanbetas.adults.R2_MntlPain_ToM.lh,meanbetas.adults.R2_MntlPain_ToM.rh],'Type','Pearson','rows','pairwise');
p_beta(p_beta==1)=0;
ptri=tril(p_beta);
pval=squareform(p_beta)';
pbf=bonf_holm(pval);
pbf_square=squareform(pbf);
    % r beta & p_beta (rows and columns) is in the order of 
    % kids lang lh
    % kids lang rh
    % kids ToM lh
    % kids ToM rh
    % adults lang lh
    % adults lang rh
    % adults ToM lh
    % adults ToM rh

% look at adult to adult models
adults_r=r_beta(5:8,5:8);
adults_pbh=pbf_square(5:8,5:8);
adults_sig=r_beta(5:8,5:8).*(pbf_square(5:8,5:8)<0.05);

kids_r=r_beta(1:4,1:4);
kids_pbh=pbf_square(1:4,1:4);
kids_sig=r_beta(1:4,1:4).*(pbf_square(1:4,1:4)<0.05);

ak_r=r_beta(5:8,1:4);
ak_pbh=pbf_square(5:8,1:4);
ak_sig=r_beta(5:8,1:4).*(pbf_square(5:8,1:4)<0.05);

%% Figure 2C
imagesc(r_beta)
hold on
colorbar
clim([0 1])
colormap(turbo)
title('Correlation of Betas Across Models')
xticklabels({'Kids LH Lang','Kids RH Lang','Kids LH ToM','Kids RH ToM', ...
    'Adults LH Lang','Adults RH Lang','Adults LH ToM','Adults RH ToM'})
yticklabels({'Kids LH Lang','Kids RH Lang','Kids LH ToM','Kids RH ToM', ...
    'Adults LH Lang','Adults RH Lang','Adults LH ToM','Adults RH ToM'})

%% What contributes to these differences across domains? 
lang='R2_EnTx_lang';
ToM='R2_MntlPain_ToM';
for i=1:145
% kids LH
[~,p,~,stats]=ttest(betas.kids.(lang).lh(i,:),betas.kids.(ToM).lh(i,:));
betacomp.kids_lh(i,2)=p;
betacomp.kids_lh(i,1)=stats.tstat;
% kids RH
[~,p,~,stats]=ttest(betas.kids.(lang).rh(i,:),betas.kids.(ToM).rh(i,:));
betacomp.kids_rh(i,2)=p;
betacomp.kids_rh(i,1)=stats.tstat;

% adults LH
[~,p,~,stats]=ttest(betas.adults.(lang).lh(i,:),betas.adults.(ToM).lh(i,:));
betacomp.adults_lh(i,2)=p;
betacomp.adults_lh(i,1)=stats.tstat;
%adults RH
[~,p,~,stats]=ttest(betas.adults.(lang).rh(i,:),betas.adults.(ToM).rh(i,:));
betacomp.adults_rh(i,2)=p;
betacomp.adults_rh(i,1)=stats.tstat;

end

betacomp.adults_rh(:,3)=bonf_holm(betacomp.adults_rh(:,2));
betacomp.adults_lh(:,3)=bonf_holm(betacomp.adults_lh(:,2));
betacomp.kids_rh(:,3)=bonf_holm(betacomp.kids_rh(:,2));
betacomp.kids_lh(:,3)=bonf_holm(betacomp.kids_lh(:,2));

% get the % of predictors that significantly differ across models 
    % in betacomp, the rows are the 145 regions
    % column 1 is t stat
    % column 2 is pval
    % column 3 is bonferroni-holm pval
(sum(betacomp.adults_lh(:,3)<0.05)/145)*100
(sum(betacomp.adults_rh(:,3)<0.05)/145)*100
(sum(betacomp.kids_lh(:,3)<0.05)/145)*100
(sum(betacomp.kids_rh(:,3)<0.05)/145)*100

%% compare true models with using the wrong betas 
% adults 
mean(cfmodelresults.adults.selfprediction.lh.R2_EnTx_lang-cfmodelresults.adults.wrongBpred.lh.R2_EnTx_lang)
std(cfmodelresults.adults.selfprediction.lh.R2_EnTx_lang-cfmodelresults.adults.wrongBpred.lh.R2_EnTx_lang)
mean(cfmodelresults.adults.selfprediction.rh.R2_EnTx_lang-cfmodelresults.adults.wrongBpred.rh.R2_EnTx_lang)
std(cfmodelresults.adults.selfprediction.rh.R2_EnTx_lang-cfmodelresults.adults.wrongBpred.rh.R2_EnTx_lang)
mean(cfmodelresults.adults.selfprediction.lh.R2_MntlPain_ToM-cfmodelresults.adults.wrongBpred.lh.R2_MntlPain_ToM)
std(cfmodelresults.adults.selfprediction.lh.R2_MntlPain_ToM-cfmodelresults.adults.wrongBpred.lh.R2_MntlPain_ToM)
mean(cfmodelresults.adults.selfprediction.rh.R2_MntlPain_ToM-cfmodelresults.adults.wrongBpred.rh.R2_MntlPain_ToM)
std(cfmodelresults.adults.selfprediction.rh.R2_MntlPain_ToM-cfmodelresults.adults.wrongBpred.rh.R2_MntlPain_ToM)

[~,p,~,stats]=ttest(atanh(cfmodelresults.adults.selfprediction.lh.R2_EnTx_lang),atanh(cfmodelresults.adults.wrongBpred.lh.R2_EnTx_lang))
meanEffectSize(atanh(cfmodelresults.adults.selfprediction.lh.R2_EnTx_lang),atanh(cfmodelresults.adults.wrongBpred.lh.R2_EnTx_lang),Effect="cohen")
[~,p,~,stats]=ttest(atanh(cfmodelresults.adults.selfprediction.rh.R2_EnTx_lang),atanh(cfmodelresults.adults.wrongBpred.rh.R2_EnTx_lang))
meanEffectSize(atanh(cfmodelresults.adults.selfprediction.rh.R2_EnTx_lang),atanh(cfmodelresults.adults.wrongBpred.rh.R2_EnTx_lang),Effect="cohen")

[~,p,~,stats]=ttest(atanh(cfmodelresults.adults.selfprediction.lh.R2_MntlPain_ToM),atanh(cfmodelresults.adults.wrongBpred.lh.R2_MntlPain_ToM))
meanEffectSize(atanh(cfmodelresults.adults.selfprediction.lh.R2_MntlPain_ToM),atanh(cfmodelresults.adults.wrongBpred.lh.R2_MntlPain_ToM),Effect="cohen")
[~,p,~,stats]=ttest(atanh(cfmodelresults.adults.selfprediction.rh.R2_MntlPain_ToM),atanh(cfmodelresults.adults.wrongBpred.rh.R2_MntlPain_ToM))
meanEffectSize(atanh(cfmodelresults.adults.selfprediction.rh.R2_MntlPain_ToM),atanh(cfmodelresults.adults.wrongBpred.rh.R2_MntlPain_ToM),Effect="cohen")


% kids 
mean(cfmodelresults.kids.selfprediction.lh.R2_EnTx_lang-cfmodelresults.kids.wrongBpred.lh.R2_EnTx_lang)
std(cfmodelresults.kids.selfprediction.lh.R2_EnTx_lang-cfmodelresults.kids.wrongBpred.lh.R2_EnTx_lang)
mean(cfmodelresults.kids.selfprediction.rh.R2_EnTx_lang-cfmodelresults.kids.wrongBpred.rh.R2_EnTx_lang)
std(cfmodelresults.kids.selfprediction.rh.R2_EnTx_lang-cfmodelresults.kids.wrongBpred.rh.R2_EnTx_lang)
mean(cfmodelresults.kids.selfprediction.lh.R2_MntlPain_ToM-cfmodelresults.kids.wrongBpred.lh.R2_MntlPain_ToM)
std(cfmodelresults.kids.selfprediction.lh.R2_MntlPain_ToM-cfmodelresults.kids.wrongBpred.lh.R2_MntlPain_ToM)
mean(cfmodelresults.kids.selfprediction.rh.R2_MntlPain_ToM-cfmodelresults.kids.wrongBpred.rh.R2_MntlPain_ToM)
std(cfmodelresults.kids.selfprediction.rh.R2_MntlPain_ToM-cfmodelresults.kids.wrongBpred.rh.R2_MntlPain_ToM)

[~,p,~,stats]=ttest(atanh(cfmodelresults.kids.selfprediction.lh.R2_EnTx_lang),atanh(cfmodelresults.kids.wrongBpred.lh.R2_EnTx_lang))
meanEffectSize(atanh(cfmodelresults.kids.selfprediction.lh.R2_EnTx_lang),atanh(cfmodelresults.kids.wrongBpred.lh.R2_EnTx_lang),Effect="cohen")
[~,p,~,stats]=ttest(atanh(cfmodelresults.kids.selfprediction.rh.R2_EnTx_lang),atanh(cfmodelresults.kids.wrongBpred.rh.R2_EnTx_lang))
meanEffectSize(atanh(cfmodelresults.kids.selfprediction.rh.R2_EnTx_lang),atanh(cfmodelresults.kids.wrongBpred.rh.R2_EnTx_lang),Effect="cohen")

[~,p,~,stats]=ttest(atanh(cfmodelresults.kids.selfprediction.lh.R2_MntlPain_ToM),atanh(cfmodelresults.kids.wrongBpred.lh.R2_MntlPain_ToM))
meanEffectSize(atanh(cfmodelresults.kids.selfprediction.lh.R2_MntlPain_ToM),atanh(cfmodelresults.kids.wrongBpred.lh.R2_MntlPain_ToM),Effect="cohen")
[~,p,~,stats]=ttest(atanh(cfmodelresults.kids.selfprediction.rh.R2_MntlPain_ToM),atanh(cfmodelresults.kids.wrongBpred.rh.R2_MntlPain_ToM))
meanEffectSize(atanh(cfmodelresults.kids.selfprediction.rh.R2_MntlPain_ToM),atanh(cfmodelresults.kids.wrongBpred.rh.R2_MntlPain_ToM),Effect="cohen")

%% For figure 3 and Figure S4 
% plot the top 10 most positive and top 10 most negative t stats in
% betacomp for each hemisphere of kids & adults separately 
% for brain plotting code, please contanct saygin.3@osu.edu