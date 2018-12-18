CREATE OR REPLACE FUNCTION ARRAY_OBJECT_TO_ELEMENT (
    A ARRAY
  )
  RETURNS ARRAY
  LANGUAGE JAVASCRIPT
AS $$
  return A.map(x => x.array_element)
$$
;

/* SAMPLE JSON DATA IN SOURCE FILE @ARRAY_OBJECT_TO_ELEMENT_STAGE/SAMPLE_DATA.jsonl.gz
{"ROW_NUM":1, "LABEL":"A", "NESTED_ARRAY":[{"array_element": "1086838269"},{"array_element": "2086838269"}]}
{"ROW_NUM":2, "LABEL":"B", "NESTED_ARRAY":[{"array_element": "3086838269"},{"array_element": "4086838269"}]}
*/

COPY INTO T_ARRAY_OBJECT_TO_ELEMENT
FROM
(
  SELECT OBJECT_INSERT($1
                      , 'NESTED_ARRAY'
                      , ARRAY_OBJECT_TO_ELEMENT($1:"NESTED_ARRAY")
                      , TRUE)
  FROM @ARRAY_OBJECT_TO_ELEMENT_STAGE/SAMPLE_DATA.jsonl.gz
)
FILE_FORMAT = (TYPE = 'JSON')
;
