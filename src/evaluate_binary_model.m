function [metrics, calibration] = evaluate_binary_model(outcome, probability, threshold, bins)
%EVALUATE_BINARY_MODEL Evaluate paired binary outcomes and probabilities.
outcome = double(outcome(:));
probability = double(probability(:));
if numel(outcome) ~= numel(probability) || isempty(outcome)
    error('ICUMortality:EvaluationInput','Evaluation inputs must be paired and nonempty.');
end
if any(~ismember(outcome,[0 1])) || any(~isfinite(probability)) || ...
        any(probability < 0 | probability > 1)
    error('ICUMortality:InvalidEvaluation','Invalid outcome or probability values.');
end
predicted = probability >= threshold;
tp = sum(predicted == 1 & outcome == 1);
fn = sum(predicted == 0 & outcome == 1);
tn = sum(predicted == 0 & outcome == 0);
fp = sum(predicted == 1 & outcome == 0);
sensitivity = tp/max(tp+fn,1);
specificity = tn/max(tn+fp,1);
precision = tp/max(tp+fp,1);
npv = tn/max(tn+fn,1);
f1 = 2*precision*sensitivity/max(precision+sensitivity,eps);
[~,~,~,auroc] = perfcurve(outcome,probability,1);
[recall,prPrecision,~,auprc] = perfcurve(outcome,probability,1, ...
    'XCrit','reca','YCrit','prec'); %#ok<ASGLU>
metrics = table(numel(outcome),mean(outcome),threshold,tp,fn,tn,fp, ...
    sensitivity,specificity,precision,npv,f1, ...
    (sensitivity+specificity)/2,auroc,auprc, ...
    mean((probability-outcome).^2), ...
    'VariableNames',{'N','EventRate','Threshold','TP','FN','TN','FP', ...
    'Sensitivity','Specificity','Precision','NPV','F1', ...
    'BalancedAccuracy','AUROC','AUPRC','BrierScore'});
calibration = calibration_table(outcome,probability,bins);
end

function output = calibration_table(outcome,probability,bins)
edges = linspace(0,1,bins+1);
bin = discretize(probability,edges);
rows = cell(bins,1);
for i = 1:bins
    selected = bin == i;
    rows{i} = table(i,sum(selected),mean(probability(selected),'omitnan'), ...
        mean(outcome(selected),'omitnan'), ...
        'VariableNames',{'Bin','N','MeanProbability','ObservedRate'});
end
output = vertcat(rows{:});
end
