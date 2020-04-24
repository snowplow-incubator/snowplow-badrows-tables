CREATE EXTERNAL TABLE IF NOT EXISTS {{ DATABASE }}.loader_parsing_error (
  schema string,
  data struct<
    payload: STRING,
    failure: struct<
      type: string,
      fieldCount: INT,
      errors: array<struct<
        type: string,
        key: STRING,
        value: STRING,
        message: STRING
      >>
    >,
    processor: struct<
      artifact: STRING,
      version: STRING
    >
  >
)
ROW FORMAT SERDE 'org.openx.data.jsonserde.JsonSerDe'
STORED AS TEXTFILE
LOCATION 's3://{{ BUCKET }}/{{ PIPELINE }}/partitioned/com.snowplowanalytics.snowplow.badrows.loader_parsing_error'
