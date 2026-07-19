function threshold = select_threshold(outcome, probability)
%SELECT_THRESHOLD Select Youden-J threshold using validation data only.
outcome = double(outcome(:));
probability = double(probability(:));
if numel(outcome) ~= numel(probability) || isempty(outcome)
    error('ICUMortality:ThresholdInput','Threshold inputs must be paired and nonempty.');
end
candidates = unique([0;probability;1]);
bestScore = -Inf;
threshold = 0.5;
for value = candidates'
    predicted = probability >= value;
    tp = sum(predicted == 1 & outcome == 1);
    fn = sum(predicted == 0 & outcome == 1);
    tn = sum(predicted == 0 & outcome == 0);
    fp = sum(predicted == 1 & outcome == 0);
    sensitivity = tp/max(tp+fn,1);
    specificity = tn/max(tn+fp,1);
    score = sensitivity+specificity-1;
    if score > bestScore
        bestScore = score;
        threshold = value;
    end
end
end
