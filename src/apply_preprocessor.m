function X = apply_preprocessor(features, prep)
%APPLY_PREPROCESSOR Apply training-derived imputation and standardization.
X = double(features);
if size(X,2) ~= numel(prep.featureNames)
    error('ICUMortality:FeatureCountMismatch', ...
        'Feature count differs from the fitted preprocessor.');
end
X = fillmissing(X,'constant',prep.medians);
X = (X-prep.mu)./prep.sigma;
if any(~isfinite(X),'all')
    error('ICUMortality:NonfiniteProcessed','Processed features contain NaN or Inf.');
end
end
