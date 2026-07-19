function artifacts = run_mortality_experiment(cohortCsv, outputDir, cfg)
%RUN_MORTALITY_EXPERIMENT Run patient-separated mortality baselines.
if ~isfolder(outputDir), mkdir(outputDir); end
cohort = load_icu_cohort(cohortCsv,cfg);
split = create_patient_splits(cohort,cfg);
features = table2array(cohort(:,cellstr(cfg.featureNames)));
outcome = double(cohort.(cfg.outcomeName));

prep = fit_preprocessor(features(split.train,:),cfg.featureNames);
XTrain = apply_preprocessor(features(split.train,:),prep);
XValidation = apply_preprocessor(features(split.validation,:),prep);
XTest = apply_preprocessor(features(split.test,:),prep);
yTrain = outcome(split.train);
yValidation = outcome(split.validation);
yTest = outcome(split.test);

models = train_models(XTrain,yTrain,cfg);
names = ["Logistic regression","Random forest"];
keys = ["logistic","randomForest"];
metricRows = cell(numel(keys),1);
calibrationRows = cell(numel(keys),1);
thresholds = zeros(numel(keys),1);
for i = 1:numel(keys)
    model = models.(keys(i));
    validationProbability = predict_positive_probability(model,XValidation);
    thresholds(i) = select_threshold(yValidation,validationProbability);
    testProbability = predict_positive_probability(model,XTest);
    [metric,calibration] = evaluate_binary_model( ...
        yTest,testProbability,thresholds(i),cfg.calibrationBins);
    metric = addvars(metric,names(i),'Before',1,'NewVariableNames','Model');
    calibration = addvars(calibration,repmat(names(i),height(calibration),1), ...
        'Before',1,'NewVariableNames','Model');
    metricRows{i} = metric;
    calibrationRows{i} = calibration;
end
metrics = vertcat(metricRows{:});
calibration = vertcat(calibrationRows{:});
writetable(metrics,fullfile(outputDir,'held_out_metrics.csv'));
writetable(calibration,fullfile(outputDir,'held_out_calibration.csv'));

splitSummary = table( ...
    ["Train";"Validation";"Test"], ...
    [sum(split.train);sum(split.validation);sum(split.test)], ...
    [numel(split.trainPatients);numel(split.validationPatients);numel(split.testPatients)], ...
    [mean(outcome(split.train));mean(outcome(split.validation));mean(outcome(split.test))], ...
    'VariableNames',{'Split','Stays','Patients','EventRate'});
writetable(splitSummary,fullfile(outputDir,'split_summary.csv'));
if cfg.saveModels
    save(fullfile(outputDir,'mortality_models.mat'), ...
        'models','prep','cfg','thresholds','-v7.3');
end
artifacts = struct('metrics',metrics,'calibration',calibration, ...
    'splitSummary',splitSummary,'models',models,'preprocessor',prep, ...
    'thresholds',thresholds);
end
