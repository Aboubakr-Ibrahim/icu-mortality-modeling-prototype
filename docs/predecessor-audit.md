# Predecessor experiment audit

The earlier MATLAB contribution explored in-hospital ICU mortality using MIMIC-III administrative fields, a Random Forest, and an LSTM-shaped network. It is preserved as evidence of learning and commissioned MATLAB/research work, not as validated clinical modeling.

## Confirmed methodological problems

- Respiratory rate, systolic blood pressure, and GCS were randomly simulated.
- The resulting qSOFA value was therefore simulated rather than observed.
- Total hospital length of stay and total ICU duration were used as predictors without a defined prediction time. These variables include future information and create temporal leakage for early prediction.
- Median imputation occurred before the train/test split.
- The split was record-level rather than explicitly patient-level.
- The LSTM received static feature vectors rather than true longitudinal sequences.
- A single holdout and accuracy/confusion matrices were insufficient for model selection, calibration, uncertainty, or generalization.
- Statements about clinical deployment exceeded the evidence.
- Reported 95% Random Forest and 87% LSTM accuracy cannot be treated as validated results.

## V2 response

V2 defines a 24-hour prediction window, requires observed features, removes post-outcome duration variables, separates patients, fits preprocessing only on training data, uses interpretable baselines, selects thresholds only on validation data, and reserves the test split for final evaluation.

No predecessor metric is reused as a V2 performance claim.
