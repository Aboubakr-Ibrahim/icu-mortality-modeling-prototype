# Local cohort contract

The repository does not distribute MIMIC records or derived patient-level data. Place an authorized local file named icu_mortality_cohort.csv in this directory.

Each row must represent one adult patient's first eligible ICU stay, or another clearly documented one-row-per-stay cohort. Required columns are:

| Column | Meaning |
|---|---|
| subject_id | Patient grouping identifier |
| hadm_id | Hospital-admission identifier |
| stay_id | Unique ICU-stay identifier |
| hospital_expire_flag | Legitimate 0/1 in-hospital mortality outcome |
| age | Age known at admission |
| sex_female | Documented binary encoding |
| heart_rate_mean | Mean observed during first 24 hours |
| sbp_mean | Mean systolic blood pressure during first 24 hours |
| respiratory_rate_mean | Mean respiratory rate during first 24 hours |
| temperature_mean | Mean temperature during first 24 hours |
| spo2_mean | Mean oxygen saturation during first 24 hours |
| gcs_min | Minimum observed Glasgow Coma Scale during first 24 hours |

## Mandatory construction rules

- Use only observations available by the 24-hour prediction time.
- Do not use total hospital length of stay, total ICU duration, discharge status, post-24-hour treatment, or any future information as predictors.
- Derive the outcome from an authorized source field; never infer it from predictor thresholds.
- Preserve patient IDs locally only for grouping and leakage prevention.
- Document item-ID mappings, units, aggregation, exclusions, and missingness.
- Group all stays from one patient into exactly one experimental split.
- Do not commit source or derived patient-level records to GitHub.

A cohort file that does not satisfy these rules must not be used for performance reporting.
