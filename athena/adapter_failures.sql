CREATE EXTERNAL TABLE IF NOT EXISTS {{ DATABASE }}.adapter_failures (
  schema string,
  data struct<
    failure: struct<
      timestamp: STRING,
      vendor: STRING,
      version: STRING,
      messages: array<struct<
        field: STRING,
        value: STRING,
        expectation: STRING,
        error: STRING,
        json: string,
        actual: STRING,
        expectedMapping: string
      >>
    >,
    payload: struct<
      vendor: STRING,
      version: STRING,
      querystring: array<struct<
        name: STRING,
        value: STRING
      >>,
      contentType: STRING,
      body: STRING,
      collector: STRING,
      encoding: STRING,
      hostname: STRING,
      timestamp: STRING,
      ipAddress: STRING,
      useragent: STRING,
      refererUri: STRING,
      headers: array<STRING>,
      networkUserId: STRING
    >,
    processor: struct<
      artifact: STRING,
      version: STRING
    >
  >
)
ROW FORMAT SERDE 'org.openx.data.jsonserde.JsonSerDe'
STORED AS TEXTFILE
LOCATION 's3://{{ BUCKET }}/{{ PIPELINE }}/partitioned/com.snowplowanalytics.snowplow.badrows.adapter_failures'
