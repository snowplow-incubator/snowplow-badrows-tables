## Athena bad rows tables

This directory contains sql statements for creating tables in [AWS Athena][athena home] based on Snowplow's structured bad rows formats.
You should create a separate table for each of Snowplow's [different bad row schemas][all badrow schemas].

### Create tables

Go to [the Athena dashboard][athena dashboard] and use the query editor.  Start by creating a database named after your pipeline (e.g. prod1 or qa1):

```sql
CREATE DATABASE IF NOT EXISTS {{ DATABASE }}
```

The sql statements in this repo contain a few placeholders which you will need to edit before you can create the tables:

* `{{ DATABASE }}` - change this to the name of your pipeline, e.g. prod1 or qa1.
* `s3://{{ BUCKET }}/{{ PIPELINE }}` - This should point to the directory in S3 where your bad rows files are stored.

Now run each sql statement in turn by copying them into the Athena query editor.

![Athena create table](https://github.com/snowplow-incubator/snowplow-badrows-tables/wiki/images/athena-create-table.png)

| Athena create statement | Corresponding bad rows JSON schema |
| - | - |
| [adapter_failures.sql](adapter_failures.sql) | [adapter_failures 1-0-0] |
| [collector_payload_format_violation.sql](collector_payload_format_violation.sql) | [collector_payload_format_violation 1-0-0] |
| [enrichment_failures.sql](enrichment_failures.sql) | [enrichment_failures 1-0-0] |
| [loader_iglu_error.sql](loader_iglu_error.sql) | [loader_iglu_error 2-0-0] |
| [loader_parsing_error.sql](loader_parsing_error.sql) | [loader_parsing_error 2-0-0] |
| [loader_recovery_error.sql](loader_recovery_error.sql) | [loader_recovery_error 1-0-0] |
| [loader_runtime_error.sql](loader_runtime_error.sql) | [loader_runtime_error 1-0-1] |
| [relay_failure.sql](relay_failure.sql) | [relay_failure 1-0-0] |
| [schema_violations.sql](schema_violations.sql) | [schema_violations 1-0-0] |
| [size_violation.sql](size_violation.sql) | [size_violation 1-0-0] |
| [tracker_protocol_violations.sql](tracker_protocol_violations.sql) | [tracker_protocol_violations 1-0-0] |

### Example usage of tables

You might want to start by getting counts of each bad row type from the last week. Repeat this query for each table you have created:

```sql
SELECT COUNT(*) FROM schema_violations
WHERE from_iso8601_timestamp(data.failure.timestamp) > DATE_ADD('day', -7, now())
```

![Athena count](https://github.com/snowplow-incubator/snowplow-badrows-tables/wiki/images/athena-count.png)

If you have schema violations, you might want to find which tracker sent the event:

```sql
SELECT data.payload.enriched.app_id, COUNT(*) FROM schema_violations
WHERE from_iso8601_timestamp(data.failure.timestamp) > DATE_ADD('day', -7, now())
GROUP BY data.payload.enriched.app_id
```

You can do a deeper dive into the error messages to get a explanation of the last 10 failures:

```sql
SELECT data.failure.messages[1].field AS field,
       data.failure.messages[1].value AS value,
       data.failure.messages[1].error AS error,
       data.failure.messages[1].json AS json,
       data.failure.messages[1].schemaKey AS schemaKey,
       data.failure.messages[1].schemaCriterion AS schemaCriterion
FROM schema_violations
ORDER BY data.failure.timestamp DESC
LIMIT 10
```


[athena home]: https://aws.amazon.com/athena/
[all badrow schemas]: https://github.com/snowplow/iglu-central/tree/master/schemas/com.snowplowanalytics.snowplow.badrows
[athena dashboard]: https://eu-central-1.console.aws.amazon.com/athena/home

[adapter_failures 1-0-0]: https://github.com/snowplow/iglu-central/blob/master/schemas/com.snowplowanalytics.snowplow.badrows/adapter_failures/jsonschema/1-0-0
[collector_payload_format_violation 1-0-0]: https://github.com/snowplow/iglu-central/blob/master/schemas/com.snowplowanalytics.snowplow.badrows/collector_payload_format_violation/jsonschema/1-0-0
[enrichment_failures 1-0-0]: https://github.com/snowplow/iglu-central/blob/master/schemas/com.snowplowanalytics.snowplow.badrows/enrichment_failures/jsonschema/1-0-0
[loader_iglu_error 2-0-0]: https://github.com/snowplow/iglu-central/blob/master/schemas/com.snowplowanalytics.snowplow.badrows/loader_iglu_error/jsonschema/2-0-0
[loader_parsing_error 2-0-0]: https://github.com/snowplow/iglu-central/blob/master/schemas/com.snowplowanalytics.snowplow.badrows/loader_parsing_error/jsonschema/2-0-0
[loader_recovery_error 1-0-0]: https://github.com/snowplow/iglu-central/blob/master/schemas/com.snowplowanalytics.snowplow.badrows/loader_recovery_error/jsonschema/1-0-0
[loader_runtime_error 1-0-1]: https://github.com/snowplow/iglu-central/blob/master/schemas/com.snowplowanalytics.snowplow.badrows/loader_runtime_error/jsonschema/1-0-1
[relay_failure 1-0-0]: https://github.com/snowplow/iglu-central/blob/master/schemas/com.snowplowanalytics.snowplow.badrows/relay_failure/jsonschema/1-0-0
[schema_violations 1-0-0]: https://github.com/snowplow/iglu-central/blob/master/schemas/com.snowplowanalytics.snowplow.badrows/schema_violations/jsonschema/1-0-0
[size_violation 1-0-0]: https://github.com/snowplow/iglu-central/blob/master/schemas/com.snowplowanalytics.snowplow.badrows/size_violation/jsonschema/1-0-0
[tracker_protocol_violations 1-0-0]: https://github.com/snowplow/iglu-central/blob/master/schemas/com.snowplowanalytics.snowplow.badrows/tracker_protocol_violations/jsonschema/1-0-0
