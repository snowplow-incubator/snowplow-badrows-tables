# snowplow-badrows-tables

Resources to enable SQL queries over Snowplow bad rows

## Overview

A "bad row" is any payload that hits a Snowplow pipeline, but which cannot be successfully parsed or processed.
Bad rows are preserved by writing them to cloud storage (e.g. [S3][S3 home] or [GCS][GCS home]) as newline-delimited JSON objects.

[Athena][athena home] on AWS and [BigQuery][bigquery home] on GCP are tools that let you query your bad rows, using the cloud storage files as a back-end data source.

```sql
SELECT data.failure.messages FROM adatper_failures
WHERE data.failure.timestamp > timestamp '2020-04-01'
```

This is great for debugging your pipeline without the need to load your bad rows into a separate database.

## Setup

To create tables in Athena or BigQuery, you need to provide a table definitions corresponding to the JSON schema of your bad row files.
Each different bad row type (e.g. schema violations, adapter failures) has its own JSON schema, and therefore requires its own separate table.

This repo is split into:

* [Resources and instructions for Athena](athena) if your bad rows are in AWS S3
* [Resources and instructions for BigQuery](bigquery) if your bad rows are in Google Cloud Storage


[S3 home]: https://aws.amazon.com/s3/
[athena home]: https://aws.amazon.com/athena/
[GCS home]: https://cloud.google.com/storage
[bigquery home]: https://cloud.google.com/bigquery
