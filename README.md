# ICU Mortality Modeling Prototype

A transparent MATLAB research framework for rebuilding an earlier ICU mortality experiment with a fixed prediction time, observed features, patient-level separation, training-only preprocessing, interpretable baselines, calibration assessment, and responsible reporting.

## Why this repository exists

I developed the predecessor experiment as paid or voluntary biomedical research and MATLAB work. It explored MIMIC-III mortality modeling with Random Forest and LSTM methods, but its simulated qSOFA inputs, post-outcome duration variables, record-level split, and static use of an LSTM made the reported performance unsuitable as clinical evidence.

V2 preserves the learning and contribution while correcting the methodology. The original reported 95% Random Forest and 87% LSTM accuracies are not reused as validated results.

## V2 research question

Among eligible adult ICU stays, can information available during the first 24 hours support a retrospective research estimate of in-hospital mortality risk?

- Prediction time: 24 hours after ICU admission
- Outcome: documented in-hospital mortality
- Unit: one row per eligible ICU stay
- Grouping: complete patients remain in one split
- Intended use: research and portfolio demonstration only

## Main safeguards

- Patient-level train, validation, and held-out test separation
- Observed first-24-hour features only
- No total hospital length of stay or total ICU duration as predictors
- No simulated qSOFA or randomly generated clinical measurements
- Median imputation and standardization fitted on training data only
- Validation-only decision-threshold selection
- Locked held-out test reporting
- Logistic-regression and Random Forest baselines
- Sensitivity, specificity, precision, NPV, F1, balanced accuracy, AUROC, AUPRC, Brier score, and calibration bins
- Strict cohort, outcome, identifier, missingness, and feature validation
- Tests covering preprocessing, alignment, metrics, and duplicate stays
- Explicit predecessor audit, limitations, privacy boundary, and publication checklist

## Repository structure

| Path | Purpose |
|---|---|
| config | Reproducible experimental settings |
| src | Cohort validation, patient splitting, preprocessing, modeling, thresholding, and evaluation |
| tests | Unit tests for critical safeguards |
| data | Local cohort contract; patient-level data are excluded |
| docs | Methodology, predecessor audit, and limitations |
| results | Publication checklist; generated outputs are excluded |

## Required local cohort

The code expects an authorized local data/icu_mortality_cohort.csv with one row per ICU stay. The documented feature contract includes age, sex encoding, and observed first-24-hour heart rate, systolic pressure, respiratory rate, temperature, oxygen saturation, and GCS summaries.

The repository does not redistribute MIMIC data or derived patient-level records.

## Quick start

~~~matlab
addpath('config','src');
cfg = default_config();

testResults = runtests('tests');
table(testResults)

artifacts = run_mortality_experiment( ...
    "data/icu_mortality_cohort.csv","results",cfg);
~~~

## Requirements

- MATLAB R2022b or newer recommended
- Statistics and Machine Learning Toolbox

## Verification status

The V2 framework has been statically reviewed but has not been executed in this environment because MATLAB and an audited local cohort are unavailable. No V2 numerical performance is claimed.

A demo-dataset run may verify engineering behavior, but it cannot establish clinical validity or generalization.

## Responsible use

This repository is educational and retrospective research software. It is not a medical device and must not be used for diagnosis, prognosis, triage, monitoring, treatment, resource allocation, alarms, or patient-care decisions.

## Author and contribution

**Aboubakr Ibrahim** — Biomedical Engineer and Biomedical Research & MATLAB Developer

Contribution: research development, MATLAB implementation, ICU feature analysis, model experimentation, evaluation, visualization, and documentation.

## License

[MIT](LICENSE)
