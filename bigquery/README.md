# BigQuery bad rows tables

This directory contains sql statements for creating tables in [BigQuery](https://cloud.google.com/bigquery) based on Snowplow's structured bad rows formats.

Please find the usage instructions [in our docs](https://docs.snowplow.io/docs/managing-data-quality/failed-events/failed-events-in-athena-and-bigquery/).

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

[adapter_failures 1-0-0]: https://github.com/snowplow/iglu-central/blob/master/schemas/com.snowplowanalytics.snowplow.badrows/adapter_failures/jsonschema/1-0-0
[collector_payload_format_violation 1-0-0]: https://github.com/snowplow/iglu-central/blob/master/schemas/com.snowplowanalytics.snowplow.badrows/collector_payload_format_violation/jsonschema/1-0-0
[enrichment_failures 2-0-0]: https://github.com/snowplow/iglu-central/blob/master/schemas/com.snowplowanalytics.snowplow.badrows/enrichment_failures/jsonschema/2-0-0
[loader_iglu_error 2-0-0]: https://github.com/snowplow/iglu-central/blob/master/schemas/com.snowplowanalytics.snowplow.badrows/loader_iglu_error/jsonschema/2-0-0
[loader_parsing_error 2-0-0]: https://github.com/snowplow/iglu-central/blob/master/schemas/com.snowplowanalytics.snowplow.badrows/loader_parsing_error/jsonschema/2-0-0
[loader_recovery_error 1-0-0]: https://github.com/snowplow/iglu-central/blob/master/schemas/com.snowplowanalytics.snowplow.badrows/loader_recovery_error/jsonschema/1-0-0
[loader_runtime_error 1-0-1]: https://github.com/snowplow/iglu-central/blob/master/schemas/com.snowplowanalytics.snowplow.badrows/loader_runtime_error/jsonschema/1-0-1
[relay_failure 1-0-0]: https://github.com/snowplow/iglu-central/blob/master/schemas/com.snowplowanalytics.snowplow.badrows/relay_failure/jsonschema/1-0-0
[schema_violations 2-0-0]: https://github.com/snowplow/iglu-central/blob/master/schemas/com.snowplowanalytics.snowplow.badrows/schema_violations/jsonschema/2-0-0
[size_violation 1-0-0]: https://github.com/snowplow/iglu-central/blob/master/schemas/com.snowplowanalytics.snowplow.badrows/size_violation/jsonschema/1-0-0
[tracker_protocol_violations 1-0-0]: https://github.com/snowplow/iglu-central/blob/master/schemas/com.snowplowanalytics.snowplow.badrows/tracker_protocol_violations/jsonschema/1-0-0
