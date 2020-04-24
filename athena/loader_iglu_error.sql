CREATE EXTERNAL TABLE IF NOT EXISTS {{ DATABASE }}.loader_iglu_error (
  schema string,
  data struct<
    failure: array<struct<
      schemaKey: STRING,
      error: struct<
        error: string,
        lookupHistory: array<struct<
          repostitory: STRING,
          errors: array<struct<
            error: string,
            message: STRING
          >>,
          attempts: INT,
          lastAttempt: STRING
        >>,
        dataReports: array<struct<
          message: STRING,
          path: STRING,
          keyword: STRING,
          targets: string
        >>,
        schemaIssues: array<struct<
          path: STRING,
          message: STRING
        >>
      >,
      message: STRING,
      schemaCriterion: STRING,
      value: string,
      expected: STRING,
      key: string
    >>,
    payload: struct<
      app_id: STRING,
      platform: STRING,
      etl_tstamp: STRING,
      collector_tstamp: STRING,
      dvce_created_tstamp: STRING,
      event: STRING,
      event_id: STRING,
      txn_id: INT,
      name_tracker: STRING,
      v_tracker: STRING,
      v_collector: STRING,
      v_etl: STRING,
      user_id: STRING,
      user_ipaddress: STRING,
      user_fingerprint: STRING,
      domain_userid: STRING,
      domain_sessionidx: INT,
      network_userid: STRING,
      geo_country: STRING,
      geo_region: STRING,
      geo_city: STRING,
      geo_zipcode: STRING,
      geo_latitude: DECIMAL(8,5),
      geo_longitude: DECIMAL(8,5),
      geo_region_name: STRING,
      ip_isp: STRING,
      ip_organization: STRING,
      ip_domain: STRING,
      ip_netspeed: STRING,
      page_url: STRING,
      page_title: STRING,
      page_referrer: STRING,
      page_urlscheme: STRING,
      page_urlhost: STRING,
      page_urlport: INT,
      page_urlpath: STRING,
      page_urlquery: STRING,
      page_urlfragment: STRING,
      refr_urlscheme: STRING,
      refr_urlhost: STRING,
      refr_urlport: INT,
      refr_urlpath: STRING,
      refr_urlquery: STRING,
      refr_urlfragment: STRING,
      refr_medium: STRING,
      refr_source: STRING,
      refr_term: STRING,
      mkt_medium: STRING,
      mkt_source: STRING,
      mkt_term: STRING,
      mkt_content: STRING,
      mkt_campaign: STRING,
      se_category: STRING,
      se_action: STRING,
      se_label: STRING,
      se_property: STRING,
      se_value: DECIMAL(8,5),
      tr_orderid: STRING,
      tr_affiliation: STRING,
      tr_total: DECIMAL(8,5),
      tr_tax: DECIMAL(8,5),
      tr_shipping: DECIMAL(8,5),
      tr_city: STRING,
      tr_state: STRING,
      tr_country: STRING,
      ti_orderid: STRING,
      ti_sku: STRING,
      ti_name: STRING,
      ti_category: STRING,
      ti_price: DECIMAL(8,5),
      ti_quantity: INT,
      pp_xoffset_min: INT,
      pp_xoffset_max: INT,
      pp_yoffset_min: INT,
      pp_yoffset_max: INT,
      useragent: STRING,
      br_name: STRING,
      br_family: STRING,
      br_version: STRING,
      br_type: STRING,
      br_renderengine: STRING,
      br_lang: STRING,
      br_features_pdf: BOOLEAN,
      br_features_flash: BOOLEAN,
      br_features_java: BOOLEAN,
      br_features_director: BOOLEAN,
      br_features_quicktime: BOOLEAN,
      br_features_realplayer: BOOLEAN,
      br_features_windowsmedia: BOOLEAN,
      br_features_gears: BOOLEAN,
      br_features_silverlight: BOOLEAN,
      br_cookies: BOOLEAN,
      br_colordepth: STRING,
      br_viewwidth: INT,
      br_viewheight: INT,
      os_name: STRING,
      os_family: STRING,
      os_manufacturer: STRING,
      os_timezone: STRING,
      dvce_type: STRING,
      dvce_ismobile: BOOLEAN,
      dvce_screenwidth: INT,
      dvce_screenheight: INT,
      doc_charset: STRING,
      doc_width: INT,
      doc_height: INT,
      tr_currency: STRING,
      tr_total_base: DECIMAL(8,5),
      tr_tax_base: DECIMAL(8,5),
      tr_shipping_base: DECIMAL(8,5),
      ti_currency: STRING,
      ti_price_base: DECIMAL(8,5),
      base_currency: STRING,
      geo_timezone: STRING,
      mkt_clickid: STRING,
      mkt_network: STRING,
      etl_tags: STRING,
      dvce_sent_tstamp: STRING,
      refr_domain_userid: STRING,
      refr_dvce_tstamp: STRING,
      domain_sessionid: STRING,
      derived_tstamp: STRING,
      event_vendor: STRING,
      event_name: STRING,
      event_format: STRING,
      event_version: STRING,
      event_fingerprint: STRING,
      true_tstamp: STRING,
      unstruct_event: string,
      contexts: string,
      derived_contexts: string
    >,
    processor: struct<
      artifact: STRING,
      version: STRING
    >
  >
)
ROW FORMAT SERDE 'org.openx.data.jsonserde.JsonSerDe'
STORED AS TEXTFILE
LOCATION 's3://{{ BUCKET }}/{{ PIPELINE }}/partitioned/com.snowplowanalytics.snowplow.badrows.loader_iglu_error'
