function probability = predict_positive_probability(model, X)
%PREDICT_POSITIVE_PROBABILITY Return probability/score for outcome class 1.
[~,scores] = predict(model,X);
if isa(model,'TreeBagger')
    classValues = str2double(string(model.ClassNames));
else
    classValues = double(model.ClassNames);
end
positiveIndex = find(classValues == 1,1);
if isempty(positiveIndex)
    error('ICUMortality:MissingPositiveClass','Model does not contain class 1.');
end
probability = double(scores(:,positiveIndex));
if any(~isfinite(probability)) || any(probability < 0 | probability > 1)
    error('ICUMortality:InvalidProbability', ...
        'Predicted positive-class probabilities must be finite and within [0,1].');
end
end
