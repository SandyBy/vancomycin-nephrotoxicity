-- Determine baseline creatinine.
DROP TABLE IF EXISTS vanco.apache;
CREATE TABLE vanco.apache AS
SELECT
  pt.patientunitstayid
  , CASE
    WHEN apr.predictedhospitalmortality = -1 THEN NULL
    ELSE apr.predictedhospitalmortality
  END as apache_prob
  , CASE
    WHEN apv.aids = 1 OR apv.immunosuppression = 1 THEN 1
    ELSE 0
  END AS immunocompromised
FROM eicu_crd.patient pt
INNER JOIN eicu_crd.apachepatientresult apr
  ON pt.patientunitstayid = apr.patientunitstayid
  AND apr.apacheversion = 'IVa'
INNER JOIN eicu_crd.apachepredvar apv
  ON pt.patientunitstayid = apv.patientunitstayid
ORDER BY pt.patientunitstayid;