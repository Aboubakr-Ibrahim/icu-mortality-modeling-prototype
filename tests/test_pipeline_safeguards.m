classdef test_pipeline_safeguards < matlab.unittest.TestCase
    methods(Test)
        function preprocessingUsesTrainingValues(testCase)
            addpath('src');
            train = [1 NaN;3 10;5 20];
            prep = fit_preprocessor(train,["a","b"]);
            testCase.verifyEqual(prep.medians,[3 15])
            transformed = apply_preprocessor([NaN NaN],prep);
            testCase.verifyEqual(transformed,[0 0],'AbsTol',1e-12)
        end

        function thresholdUsesPairedInputs(testCase)
            addpath('src');
            testCase.verifyError(@() select_threshold([0 1],[0.2]), ...
                'ICUMortality:ThresholdInput')
        end

        function perfectClassifierMetrics(testCase)
            addpath('src');
            [metric,~] = evaluate_binary_model([0;0;1;1], ...
                [0.1;0.2;0.8;0.9],0.5,2);
            testCase.verifyEqual(metric.Sensitivity,1)
            testCase.verifyEqual(metric.Specificity,1)
            testCase.verifyEqual(metric.F1,1)
            testCase.verifyGreaterThan(metric.AUROC,0.99)
        end

        function duplicateStayRejected(testCase)
            addpath('config','src');
            cfg = default_config();
            row = table([1;2],[10;10],[100;100],[0;1], ...
                [50;60],[0;1],[80;90],[110;100],[18;24], ...
                [37;38],[97;95],[15;14], ...
                'VariableNames',{'subject_id','hadm_id','stay_id', ...
                'hospital_expire_flag','age','sex_female','heart_rate_mean', ...
                'sbp_mean','respiratory_rate_mean','temperature_mean', ...
                'spo2_mean','gcs_min'});
            path = [tempname '.csv'];
            cleanup = onCleanup(@() delete(path));
            writetable(row,path);
            testCase.verifyError(@() load_icu_cohort(path,cfg), ...
                'ICUMortality:DuplicateStay')
        end
    end
end
