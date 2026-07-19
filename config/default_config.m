function cfg = default_config()
%DEFAULT_CONFIG Reproducible defaults for the ICU mortality V2 framework.
cfg.randomSeed = 20260719;
cfg.predictionWindowHours = 24;
cfg.validationFraction = 0.20;
cfg.testFraction = 0.20;
cfg.logisticLambda = 1e-3;
cfg.randomForestTrees = 300;
cfg.calibrationBins = 10;
cfg.featureNames = [ ...
    "age","sex_female","heart_rate_mean","sbp_mean", ...
    "respiratory_rate_mean","temperature_mean","spo2_mean","gcs_min"];
cfg.requiredIdentifiers = ["subject_id","hadm_id","stay_id"];
cfg.outcomeName = "hospital_expire_flag";
cfg.saveModels = true;
end
