# Limitations and responsible interpretation

- No cohort or numerical V2 result is included.
- The framework cannot verify from a CSV alone that every feature was available by the 24-hour prediction time; cohort construction must be audited.
- A small demo cohort is suitable for pipeline verification, not generalizable performance.
- Patient-level splitting does not address hospital-level, temporal, geographic, or demographic distribution shift.
- Mean/minimum summaries can hide clinically relevant temporal patterns.
- Missingness may encode care processes and requires explicit analysis.
- Binary sex encoding is an analytical simplification and must be documented carefully.
- Logistic regression and Random Forest are baselines, not automatically clinically appropriate models.
- AUPRC depends strongly on event prevalence and must be interpreted with cohort class balance.
- Threshold selection is context-dependent and cannot establish a clinical operating point.
- Calibration, subgroup performance, confidence intervals, external validation, and prospective evaluation are required before considering real-world relevance.
- Mortality labels and risk estimates can raise serious fairness, communication, and allocation concerns.
- The software is not a medical device and must not be used for prognosis, triage, treatment, monitoring, or patient-care decisions.
