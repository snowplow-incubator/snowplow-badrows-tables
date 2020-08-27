CREATE EXTERNAL TABLE IF NOT EXISTS {{ DATABASE }}.collector_payload_format_violation (
  `schema` string,
  `data` struct<
    `failure`: struct<
      `timestamp`: STRING,
      `loader`: STRING,
      `message`: struct<
        `error`: STRING,
        `payloadField`: STRING,
        `value`: STRING,
        `expectation`: STRING
      >
    >,
    `payload`: STRING,
    `processor`: struct<
      `artifact`: STRING,
      `version`: STRING
    >
  >
)
ROW FORMAT SERDE 'org.openx.data.jsonserde.JsonSerDe'
STORED AS TEXTFILE
LOCATION 's3://{{ BUCKET }}/{{ PIPELINE }}/partitioned/com.snowplowanalytics.snowplow.badrows.collector_payload_format_violation'
