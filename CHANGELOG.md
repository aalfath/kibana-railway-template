# Changelog

## 9.5.6 (2026-11-17)

First release of the template.

- Kibana 9.5.6 (`elastic/kibana@sha256:c7ed45da5c3cfea020fc6c99ce027f4d21d19dab330379c5115d5eb95f6ecebc`) and Elasticsearch 9.5.6 (`elastic/elasticsearch@sha256:79b4f1de4c15e6eca824723086a51e5934406d614d410cc11be77748cafac537`).
- Elasticsearch: single node, security on, private network only, data on a volume at `/usr/share/elasticsearch/data`, generated `elastic` and `kibana_system` passwords, anonymous access limited to `/_cluster/health`.
- Kibana: logs in to Elasticsearch as `kibana_system`, generated encryption keys, anonymous `/api/status` for the health check, telemetry off.
