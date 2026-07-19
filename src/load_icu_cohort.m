function cohort = load_icu_cohort(csvPath, cfg)
%LOAD_ICU_COHORT Load a one-row-per-stay, prediction-time-safe cohort.
if ~isfile(csvPath)
    error('ICUMortality:MissingCohort','Cohort file not found: %s',csvPath);
end
cohort = readtable(csvPath,'VariableNamingRule','preserve');
required = [cfg.requiredIdentifiers,cfg.outcomeName,cfg.featureNames];
missing = setdiff(required,string(cohort.Properties.VariableNames));
if ~isempty(missing)
    error('ICUMortality:MissingVariables', ...
        'Cohort is missing required variables: %s',strjoin(missing,', '));
end
if isempty(cohort)
    error('ICUMortality:EmptyCohort','Cohort contains no rows.');
end
if numel(unique(cohort.stay_id)) ~= height(cohort)
    error('ICUMortality:DuplicateStay','stay_id must be unique: one row per ICU stay.');
end
outcome = double(cohort.(cfg.outcomeName));
if any(~ismember(outcome,[0 1])) || any(~isfinite(outcome))
    error('ICUMortality:InvalidOutcome','Outcome must contain only finite 0/1 values.');
end
if numel(unique(outcome)) < 2
    error('ICUMortality:SingleClass','Both outcome classes are required.');
end
features = table2array(cohort(:,cellstr(cfg.featureNames)));
if ~isnumeric(features)
    error('ICUMortality:NonNumericFeatures','Configured model features must be numeric.');
end
if any(isinf(features),'all')
    error('ICUMortality:InfiniteFeatures','Feature values must not contain Inf.');
end
if any(cohort.age < 18 | cohort.age > 120,'omitmissing')
    error('ICUMortality:InvalidAge','Age must be between 18 and 120 years.');
end
end
