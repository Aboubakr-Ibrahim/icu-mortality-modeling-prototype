function split = create_patient_splits(cohort, cfg)
%CREATE_PATIENT_SPLITS Split unique patients with no cross-split leakage.
patients = unique(cohort.subject_id,'stable');
patientOutcome = zeros(numel(patients),1);
for i = 1:numel(patients)
    patientOutcome(i) = max(cohort.(cfg.outcomeName)(cohort.subject_id == patients(i)));
end
if numel(unique(patientOutcome)) < 2
    error('ICUMortality:PatientSingleClass','Patient-level outcomes need both classes.');
end
stream = RandStream('Threefry','Seed',cfg.randomSeed);
previous = RandStream.setGlobalStream(stream);
cleanup = onCleanup(@() RandStream.setGlobalStream(previous));

outer = cvpartition(categorical(patientOutcome),'HoldOut',cfg.testFraction);
developmentPatients = patients(training(outer));
testPatients = patients(test(outer));
developmentOutcome = patientOutcome(training(outer));
relativeValidation = cfg.validationFraction/(1-cfg.testFraction);
inner = cvpartition(categorical(developmentOutcome),'HoldOut',relativeValidation);
trainPatients = developmentPatients(training(inner));
validationPatients = developmentPatients(test(inner));

split.train = ismember(cohort.subject_id,trainPatients);
split.validation = ismember(cohort.subject_id,validationPatients);
split.test = ismember(cohort.subject_id,testPatients);
split.trainPatients = trainPatients;
split.validationPatients = validationPatients;
split.testPatients = testPatients;
assert_patient_separation(split);
assert_class_balance(cohort.(cfg.outcomeName),split);
end

function assert_patient_separation(split)
if ~isempty(intersect(split.trainPatients,split.validationPatients)) || ...
        ~isempty(intersect(split.trainPatients,split.testPatients)) || ...
        ~isempty(intersect(split.validationPatients,split.testPatients))
    error('ICUMortality:PatientLeakage','A patient appears in multiple splits.');
end
end

function assert_class_balance(outcome,split)
names = ["train","validation","test"];
for name = names
    values = outcome(split.(name));
    if numel(unique(values)) < 2
        error('ICUMortality:SplitSingleClass', ...
            '%s split does not contain both outcome classes.',name);
    end
end
end
