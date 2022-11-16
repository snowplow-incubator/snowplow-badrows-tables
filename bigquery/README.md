## BigQuery bad rows tables

This directory contains sql statements for creating tables in [BigQuery][bigquery home] based on Snowplow's structured bad rows formats.
You should create a separate table for each of Snowplow's [different bad row schemas][all badrow schemas].

We have a seperate table for the following failures:
- adapter_failures
- enrichment_failures
- schema_violations
- size_violation
- tracker_protocol_violations


## Create tables

These instructions make use of the [bq command-line tool][bq docs] which is packaged with the [google cloud sdk][sdk docs].
Follow the sdk instructions for how to [initialize and authenticate the sdk][sdk init].
Also take a look at the [BigQuery dashboard][bq console] as you run these commands, so you can see your tables as you create them.

Create a dataset to contain your bad rows tables:

```bash
bq mk --data_location=EU-NORTH sp_bad_rows
# Dataset 'nrk-datahub:bad_rows' successfully created.
```

Now run `bq mk` for each table definition in turn.  Use the `--external_table_definition` parameter so that bigquery uses the bucket as the back-end data source.
Here is how to run the command for the tables we have defined above:

```bash
bq mk \
  --display_name="Adapter failures" \
  --external_table_definition=./adapter_failures.json \
  sp_bad_rows.adapter_failures

# Table 'nrk-datahub:sp_bad_rows.adapter_failures' successfully created.

bq mk \
  --display_name "Snowplow enrichment failures" \
  --external_table_definition=./enrichment_failures.json \
  sp_bad_rows.enrichment_failures

# Table 'nrk-datahub:sp_bad_rows.enrichment_failures' successfully created

bq mk \
  --display_name "Schema violations" \
  --external_table_definition=./schema_violations.json \
  sp_bad_rows.schema_violations

# Table 'nrk-datahub:sp_bad_rows.schema_violations' successfully created.

bq mk \
  --display_name "Size violation" \
  --external_table_definition=./size_violation.json \
  sp_bad_rows.size_violation

# Table 'nrk-datahub:sp_bad_rows.size_violation' successfully created.

bq mk \
  --display_name "Tracker protocol violations" \
  --external_table_definition=./tracker_protocol_violations.json \
  sp_bad_rows.tracker_protocol_violations

# Table 'nrk-datahub:sp_bad_rows.tracker_protocol_violations' successfully created.
```



### Example usage of tables

You can query your tables from the query editor in the [BigQuery console][bq console].  You might want to start by getting counts of each bad row type from the last week. This query will work, but it is relatively expensive because it will scan all files in the `schema_violations` directory:

```sql
SELECT COUNT(*) FROM sp_bad_rows.schema_violations
WHERE data.failure.timestamp > TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 7 DAY);
```

You can construct a more economical query by using the `_FILE_NAME` pseudo column to restrict the scan to files from the last week:

```sql
SELECT COUNT(*) FROM sp_bad_rows.schema_violations
WHERE DATE(PARSE_TIMESTAMP('%Y-%m-%dT%H:%M:%S', LTRIM(REGEXP_EXTRACT(_FILE_NAME, 'output-[0-9]+-[0-9]+-[0-9]+T[0-9]+:[0-9]+:[0-9]+'), 'output-'))) >= DATE_SUB(CURRENT_DATE, INTERVAL 7 DAY);
```

You can repeat that query for each table you created in your bad rows dataset.

![BigQuery count](https://github.com/snowplow-incubator/snowplow-badrows-tables/wiki/images/bigquery-count.png)


For more specific summary queries for the different tables you have these queries.

Summary for adapter failures:
```sql
SELECT msg.field AS field,
       msg.value AS value,
       msg.expectation AS expectation,
       COUNT(schema) AS count,
FROM `nrk-datahub.sp_bad_rows.adapter_failures`,
 unnest(data.failure.messages) AS msg
WHERE DATE(PARSE_TIMESTAMP('%Y-%m-%dT%H:%M:%S', LTRIM(REGEXP_EXTRACT(_FILE_NAME, 'output-[0-9]+-[0-9]+-[0-9]+T[0-9]+:[0-9]+:[0-9]+'), 'output-'))) >= DATE_SUB(CURRENT_DATE, INTERVAL 7 DAY)

GROUP BY 1,2,3;
```

Summary for enrichment failures:

```sql 
SELECT 
  msg.message.field,
  msg.message.value,
  msg.message.expectation,
  count(schema) AS count,
FROM `nrk-datahub.sp_bad_rows.enrichment_failures`,
unnest(data.failure.messages) AS msg

group by 1,2,3;
```


Summary for schema violations
```sql
SELECT
  JSON_EXTRACT_SCALAR(msg.error.dataReports[0].message) as message,
  msg.schemaKey,
  REGEXP_EXTRACT(data.payload.enriched.useragent, r'^([^;]+;)') as useragent,
  data.payload.enriched.app_id,
  COUNT(schema) as count
  FROM `nrk-datahub.sp_bad_rows.schema_violations`,
  unnest(data.failure.messages) as msg
WHERE 
DATE(PARSE_TIMESTAMP('%Y-%m-%dT%H:%M:%S', LTRIM(REGEXP_EXTRACT(_FILE_NAME, 'output-[0-9]+-[0-9]+-[0-9]+T[0-9]+:[0-9]+:[0-9]+'), 'output-'))) >= DATE_SUB(CURRENT_DATE, INTERVAL 14 DAY)
  GROUP BY 1, 2, 3, 4
  ORDER BY 1;
```

Size violations:

```sql 
SELECT COUNT(*) count
FROM `nrk-datahub.sp_bad_rows.size_violation`
WHERE
DATE(PARSE_TIMESTAMP('%Y-%m-%dT%H:%M:%S', LTRIM(REGEXP_EXTRACT(_FILE_NAME, 'output-[0-9]+-[0-9]+-[0-9]+T[0-9]+:[0-9]+:[0-9]+'), 'output-'))) >= DATE_SUB(CURRENT_DATE, INTERVAL 7 DAY);
```

If you have tracker protocol failures, you can get a summary of the last days errors:

```sql 
SELECT msg.field AS field,
       msg.expectation AS expectation,
       JSON_EXTRACT_SCALAR(msg.error) AS errorMessage,
       COUNT(schema) as count,
FROM sp_bad_rows.tracker_protocol_violations,
unnest(data.failure.messages) AS msg
WHERE DATE(PARSE_TIMESTAMP('%Y-%m-%dT%H:%M:%S', LTRIM(REGEXP_EXTRACT(_FILE_NAME, 'output-[0-9]+-[0-9]+-[0-9]+T[0-9]+:[0-9]+:[0-9]+'), 'output-'))) >= DATE_SUB(CURRENT_DATE, INTERVAL 1 DAY)
GROUP BY 1,2,3;
```


[bigquery home]: https://cloud.google.com/bigquery
[all badrow schemas]: https://github.com/snowplow/iglu-central/tree/master/schemas/com.snowplowanalytics.snowplow.badrows
[bq docs]: https://cloud.google.com/bigquery/docs/bq-command-line-tool
[bq console]: https://console.cloud.google.com/bigquery
[sdk docs]: https://cloud.google.com/sdk/docs
[sdk init]: https://cloud.google.com/sdk/docs/initializing
