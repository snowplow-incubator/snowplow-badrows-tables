CREATE EXTERNAL TABLE IF NOT EXISTS {{ DATABASE }}.loader_recovery_error (
  schema string,
  data struct<
    payload: STRING,
    failure: struct<
      error: struct<
        message: STRING,
        location: string,
        reason: STRING
      >
    >,
    processor: struct<
      artifact: STRING,
      version: STRING
    >
  >
)
ROW FORMAT SERDE 'org.openx.data.jsonserde.JsonSerDe'
STORED AS TEXTFILE
LOCATION 's3://{{ BUCKET }}/{{ PIPELINE }}/partitioned/com.snowplowanalytics.snowplow.badrows.loader_recovery_error'
