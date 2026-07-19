# V2 methodology

## Intended question

Among eligible adult ICU stays, can information documented during the first 24 hours support a research estimate of in-hospital mortality risk?

The prediction time is 24 hours after ICU admission. The outcome is the documented in-hospital mortality flag. The framework is retrospective research software and is not intended for care.

## Leakage control

Complete patients—not rows—are divided into training, validation, and test groups. Median imputation and standardization are fitted only on the training group. Decision thresholds are selected only from validation predictions. The held-out test group is used once for reporting.

Features that summarize future care or outcomes, including total hospital length of stay and total ICU duration, are excluded.

## Models

V2 compares:

1. Ridge-regularized logistic regression as an interpretable linear baseline.
2. Random Forest as a nonlinear tabular baseline.

An LSTM is not used because the current feature contract contains static 24-hour summaries rather than genuine time sequences.

## Evaluation

Held-out reporting includes event rate, sensitivity, specificity, precision, negative predictive value, F1, balanced accuracy, AUROC, AUPRC, Brier score, and calibration bins. Results must include cohort size, class balance, patient separation, preprocessing details, and limitations.

## Evidence boundary

The repository provides a reproducible framework, not a validated model. Any numerical result requires an authorized cohort, successful execution, code review, cohort audit, and transparent reporting of every tested model.
