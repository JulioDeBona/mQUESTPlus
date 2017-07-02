function qpQuestPlusDemo
%qpQuestPlusDemo  Demonstrate QUEST+ and closely related.
%
% Description:
%    This script shows the usage for QUEST+.

% 07/01/17  dhb  Created.

%% Close out stray figures
close all;

%% qpInitialize
fprintf('*** qpInitialize:\n');
questData = qpInitialize

%% qpRun with its defaults
%
% This runs a test of estimating a Weibull threshold using
% TAFC trials.
fprintf('*** qpRun, Weibull estimate threshold:\n');
rng(2002);
questData = qpRun(32, ...
    'psiParamsDomainList',{-40:0, 3.5, 0.5, 0.02}, ...
    'qpOutcomeF',@(x) qpSimulatedObserver(x,@qpPFWeibull,[-20, 3.5, .5, .02]), ...
    'verbose',false);
psiParamsIndex = qpListMaxArg(questData.posterior);
psiParams = questData.psiParamsDomain(psiParamsIndex,:);
fprintf('Max posterior parameters: %0.1f, %0.1f, %0.1f %0.2f\n', ...
    psiParams(1),psiParams(2),psiParams(3),psiParams(4));

% Plot with fit from quest
figure; clf; hold on
stimCounts = qpCounts(qpData(questData.trialData),questData.nOutcomes);
stim = [stimCounts.stim];
stimFine = linspace(-40,0,100)';
fitProportions = qpPFWeibull(stimFine,psiParams);
for cc = 1:length(stimCounts)
    nTrials(cc) = sum(stimCounts(cc).outcomeCounts);
    pCorrect(cc) = stimCounts(cc).outcomeCounts(2)/nTrials(cc);
end
for cc = 1:length(stimCounts)
    h = scatter(stim(cc),pCorrect(cc),100,'o','MarkerEdgeColor',[0 0 1],'MarkerFaceColor',[0 0 1],...
        'MarkerFaceAlpha',nTrials(cc)/max(nTrials),'MarkerEdgeAlpha',nTrials(cc)/max(nTrials));
end
plot(stimFine,fitProportions(:,2),'-b','LineWidth',2);
xlabel('Stimulus Value');
ylabel('Proportion Correct');
xlim([-40 00]); ylim([0 1]);

%% qpRun estimating three parameters of a Weibull
%
% This runs a test of estimating a Weibull threshold, slope
% and lapse using TAFC trials.
fprintf('\n*** qpRun, Weibull estimate threshold, slope & lapse:\n');
rng(2004);
questData = qpRun(128, ...
    'psiParamsDomainList',{-40:0, 2:5, 0.5, 0:0.01:0.04}, ...
    'qpOutcomeF',@(x) qpSimulatedObserver(x,@qpPFWeibull,[-20, 3, .5, .02]), ...
    'verbose',false);
psiParamsIndex = qpListMaxArg(questData.posterior);
psiParams = questData.psiParamsDomain(psiParamsIndex,:);
fprintf('Max posterior parameters: %0.1f, %0.1f, %0.1f %0.2f\n', ...
    psiParams(1),psiParams(2),psiParams(3),psiParams(4));

% Plot with fit from quest
figure; clf; hold on
stimCounts = qpCounts(qpData(questData.trialData),questData.nOutcomes);
stim = [stimCounts.stim];
stimFine = linspace(-40,0,100)';
fitProportions = qpPFWeibull(stimFine,psiParams);
for cc = 1:length(stimCounts)
    nTrials(cc) = sum(stimCounts(cc).outcomeCounts);
    pCorrect(cc) = stimCounts(cc).outcomeCounts(2)/nTrials(cc);
end
for cc = 1:length(stimCounts)
    h = scatter(stim(cc),pCorrect(cc),100,'o','MarkerEdgeColor',[0 0 1],'MarkerFaceColor',[0 0 1],...
        'MarkerFaceAlpha',nTrials(cc)/max(nTrials),'MarkerEdgeAlpha',nTrials(cc)/max(nTrials));
end
plot(stimFine,fitProportions(:,2),'-b','LineWidth',2);
xlabel('Stimulus Value');
ylabel('Proportion Correct');
xlim([-40 00]); ylim([0 1]);



