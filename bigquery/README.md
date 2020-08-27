## BigQuery bad rows tables

This directory contains sql statements for creating tables in [BigQuery][bigquery home] based on Snowplow's structured bad rows formats.
You should create a separate table for each of Snowplow's [different bad row schemas][all badrow schemas].

## Create tables

These instructions make use of the [bq command-line tool][bq docs] which is packaged with the [google cloud sdk][sdk docs].
Follow the sdk instructions for how to [initialize and authenticate the sdk][sdk init].
Also take a look at the [BigQuery dashboard][bq console] as you run these commands, so you can see your tables as you create them.

Create a dataset to contain your bad rows tables:

```bash
bq mk --data_location=EU bad_rows_prod1
# Dataset 'my-snowplow-project:bad_rows_prod1' successfully created.
```

The `--data-location` should match the location of your bad rows bucket.  Also replace `prod1` with the name of your pipeline.

The table definitions in this repo contain a `{{ BUCKET }}` placeholder which you will need to edit before you can create the tables.
Change this placeholder to match the GCS bucket where your bad rows files are stored.

Now run `bq mk` for each table definition in turn.  Use the `--external_table_definition` parameter so that bigquery uses the bucket as the back-end data source.
Here is how to run the command for the first three tables (note you should change the dataset name `bad_rows_prod1` to match the dataset you just created):

```bash
bq mk \
  --display_name="Adapter failures" \
  --external_table_definition=./adapter_failures.json \
  bad_rows_prod1.adapter_failures

# Table 'my-snowplow-project:bad_rows_prod1.adapter_failures' successfully created.

bq mk \
  --display_name "Schema violations" \
  --external_table_definition=./schema_violations.json \
  bad_rows_prod1.schema_violations

# Table 'my-snowplow-project:bad_rows_prod1.schema_violations' successfully created.

bq mk \
  --display_name "Tracker protocol violations" \
  --external_table_definition=./tracker_protocol_violations.json \
  bad_rows_prod1.tracker_protocol_violations

# Table 'my-snowplow-project:bad_rows_prod1.tracker_protocol_violations' successfully created.
```

Continue to run those commands for each of the table definitions in this directory.

| BigQuery table definition | Corresponding bad rows JSON schema |
| - | - |
| [adapter_failures.json](adapter_failures.json) | [adapter_failures 1-0-0] |
| [collector_payload_format_violation.json](collector_payload_format_violation.json) | [collector_payload_format_violation 1-0-0] |
| [enrichment_failures.json](enrichment_failures.json) | [enrichment_failures 2-0-0] |
| [loader_iglu_error.json](loader_iglu_error.json) | [loader_iglu_error 2-0-0] |
| [loader_parsing_error.json](loader_parsing_error.json) | [loader_parsing_error 2-0-0] |
| [loader_recovery_error.json](loader_recovery_error.json) | [loader_recovery_error 1-0-0] |
| [loader_runtime_error.json](loader_runtime_error.json) | [loader_runtime_error 1-0-1] |
| [relay_failure.json](relay_failure.json) | [relay_failure 1-0-0] |
| [schema_violations.json](schema_violations.json) | [schema_violations 2-0-0] |
| [size_violation.json](size_violation.json) | [size_violation 1-0-0] |
| [tracker_protocol_violations.json](tracker_protocol_violations.json) | [tracker_protocol_violations 1-0-0] |

### Example usage of tables

You can query your tables from the query editor in the [BigQuery console][bq console].  You might want to start by getting counts of each bad row type from the last week. This query will work, but it is relatively expensive because it will scan all files in the `schema_violations` directory:

```sql
SELECT COUNT(*) FROM bad_rows_prod1.schema_violations
WHERE data.failure.timestamp > TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 7 DAY);
```

You can construct a more economical query by using the `_FILE_NAME` pseudo column to restrict the scan to files from the last week:

```sql
SELECT COUNT(*) FROM bad_rows_prod1.schema_violations
WHERE DATE(PARSE_TIMESTAMP('%Y-%m-%dT%H:%M:%S', LTRIM(REGEXP_EXTRACT(_FILE_NAME, 'output-[0-9]+-[0-9]+-[0-9]+T[0-9]+:[0-9]+:[0-9]+'), 'output-'))) >= DATE_SUB(CURRENT_DATE, INTERVAL 7 DAY);
```

You can repeat that query for each table you created in your bad rows dataset.

![BigQuery count](https://github.com/snowplow-incubator/snowplow-badrows-tables/wiki/images/bigquery-count.png)

If you have schema violations, you might want to find which tracker sent the event:

```sql
SELECT data.payload.enriched.app_id, COUNT(*) FROM bad_rows_prod1.schema_violations
WHERE DATE(PARSE_TIMESTAMP('%Y-%m-%dT%H:%M:%S', LTRIM(REGEXP_EXTRACT(_FILE_NAME, 'output-[0-9]+-[0-9]+-[0-9]+T[0-9]+:[0-9]+:[0-9]+'), 'output-'))) >= DATE_SUB(CURRENT_DATE, INTERVAL 7 DAY)
GROUP BY data.payload.enriched.app_id;
```

If you have tracker protocol failures, you can do a deeper dive into the error messages to get a explanation of the last 10 failures:

```sql
SELECT data.failure.messages[OFFSET(0)].field AS field,
       data.failure.messages[OFFSET(0)].value AS value,
       data.failure.messages[OFFSET(0)].expectation AS expectation,
       data.failure.messages[OFFSET(0)].schemaKey AS schemaKey,
       data.failure.messages[OFFSET(0)].schemaCriterion AS schemaCriterion
FROM bad_rows_prod1.tracker_protocol_violations
WHERE DATE(PARSE_TIMESTAMP('%Y-%m-%dT%H:%M:%S', LTRIM(REGEXP_EXTRACT(_FILE_NAME, 'output-[0-9]+-[0-9]+-[0-9]+T[0-9]+:[0-9]+:[0-9]+'), 'output-'))) >= DATE_SUB(CURRENT_DATE, INTERVAL 7 DAY)
ORDER BY data.failure.timestamp DESC
LIMIT 10;
```

#### Appendix: Why bother with schemas?

BigQuery has a 'Auto-detect' feature to automatically generate the table definition for you by inspecting the file contents.
So you might wonder why it is necessary to provide explicit schema definitions for your tables.

There are two potential pitfalls when using the autogenerated schema with the Snowplow bad rows files:

* Optional fields. BigQuery might not "notice" that a field exists, depending on the sample of data used to detect the schema.
* Polymorphic fields, i.e. a field that can be either a string or an object. BigQuery will throw an exception if it sees an unexpected value for a field.

[bigquery home]: https://cloud.google.com/bigquery
[all badrow schemas]: https://github.com/snowplow/iglu-central/tree/master/schemas/com.snowplowanalytics.snowplow.badrows
[bq docs]: https://cloud.google.com/bigquery/docs/bq-command-line-tool
[bq console]: https://console.cloud.google.com/bigquery
[sdk docs]: https://cloud.google.com/sdk/docs
[sdk init]: https://cloud.google.com/sdk/docs/initializing

[adapter_failures 1-0-0]: https://github.com/snowplow/iglu-central/blob/master/schemas/com.snowplowanalytics.snowplow.badrows/adapter_failures/jsonschema/1-0-0
[collector_payload_format_violation 1-0-0]: https://github.com/snowplow/iglu-central/blob/master/schemas/com.snowplowanalytics.snowplow.badrows/collector_payload_format_violation/jsonschema/1-0-0
[enrichment_failures 2-0-0]: https://github.com/snowplow/iglu-central/blob/master/schemas/com.snowplowanalytics.snowplow.badrows/enrichment_failures/jsonschema/1-0-0
[loader_iglu_error 2-0-0]: https://github.com/snowplow/iglu-central/blob/master/schemas/com.snowplowanalytics.snowplow.badrows/loader_iglu_error/jsonschema/2-0-0
[loader_parsing_error 2-0-0]: https://github.com/snowplow/iglu-central/blob/master/schemas/com.snowplowanalytics.snowplow.badrows/loader_parsing_error/jsonschema/2-0-0
[loader_recovery_error 1-0-0]: https://github.com/snowplow/iglu-central/blob/master/schemas/com.snowplowanalytics.snowplow.badrows/loader_recovery_error/jsonschema/1-0-0
[loader_runtime_error 1-0-1]: https://github.com/snowplow/iglu-central/blob/master/schemas/com.snowplowanalytics.snowplow.badrows/loader_runtime_error/jsonschema/1-0-1
[relay_failure 1-0-0]: https://github.com/snowplow/iglu-central/blob/master/schemas/com.snowplowanalytics.snowplow.badrows/relay_failure/jsonschema/1-0-0
[schema_violations 1-0-0]: https://github.com/snowplow/iglu-central/blob/master/schemas/com.snowplowanalytics.snowplow.badrows/schema_violations/jsonschema/1-0-0
[size_violation 2-0-0]: https://github.com/snowplow/iglu-central/blob/master/schemas/com.snowplowanalytics.snowplow.badrows/size_violation/jsonschema/1-0-0
[tracker_protocol_violations 1-0-0]: https://github.com/snowplow/iglu-central/blob/master/schemas/com.snowplowanalytics.snowplow.badrows/tracker_protocol_violations/jsonschema/1-0-0
