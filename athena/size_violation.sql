CREATE EXTERNAL TABLE IF NOT EXISTS {{ DATABASE }}.size_violation (
  schema string,
  data struct<
    failure: struct<
      timestamp: STRING,
      maximumAllowedSizeBytes: INT,
      actualSizeBytes: INT,
      expectation: STRING
    >,
    payload: STRING,
    processor: struct<
      artifact: STRING,
      version: STRING
    >
  >
)
ROW FORMAT SERDE 'org.openx.data.jsonserde.JsonSerDe'
STORED AS TEXTFILE
LOCATION 's3://{{ BUCKET }}/{{ PIPELINE }}/partitioned/com.snowplowanalytics.snowplow.badrows.size_violation'
