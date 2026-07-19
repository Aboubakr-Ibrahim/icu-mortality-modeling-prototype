function prep = fit_preprocessor(trainFeatures, featureNames)
%FIT_PREPROCESSOR Fit median imputation and scaling on training data only.
X = double(trainFeatures);
if isempty(X)
    error('ICUMortality:EmptyTraining','Training features must not be empty.');
end
medians = median(X,1,'omitnan');
if any(isnan(medians))
    error('ICUMortality:AllMissingFeature', ...
        'A training feature is entirely missing.');
end
X = fillmissing(X,'constant',medians);
mu = mean(X,1);
sigma = std(X,0,1);
sigma(sigma <= eps) = 1;
prep = struct('featureNames',string(featureNames), ...
    'medians',medians,'mu',mu,'sigma',sigma);
end
