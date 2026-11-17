#!/bin/bash
# Kibana start script for the Kibana Railway template.
set -e
export SERVER_PORT="${PORT:-5601}"
export SERVER_HOST="${SERVER_HOST:-::}"
export SERVER_NAME="${SERVER_NAME:-kibana}"
export ELASTICSEARCH_USERNAME="${ELASTICSEARCH_USERNAME:-kibana_system}"
# Lets Railway's health check read /api/status without a login. Anonymous
# callers only get the overall level; everything else still needs a login.
export STATUS_ALLOWANONYMOUS="${STATUS_ALLOWANONYMOUS:-true}"
export TELEMETRY_OPTIN="${TELEMETRY_OPTIN:-false}"
export MONITORING_UI_CONTAINER_ELASTICSEARCH_ENABLED="${MONITORING_UI_CONTAINER_ELASTICSEARCH_ENABLED:-false}"
# Kibana keeps all of its data in Elasticsearch. The only local state is its
# instance UUID, so pin it to the Railway service ID: it stays the same across
# redeploys without a volume.
if [ -z "$SERVER_UUID" ] && [ -n "$RAILWAY_SERVICE_ID" ]; then
  export SERVER_UUID="$RAILWAY_SERVICE_ID"
fi
for v in ELASTICSEARCH_HOSTS ELASTICSEARCH_PASSWORD XPACK_SECURITY_ENCRYPTIONKEY XPACK_ENCRYPTEDSAVEDOBJECTS_ENCRYPTIONKEY XPACK_REPORTING_ENCRYPTIONKEY; do
  if [ -z "${!v}" ]; then echo "railway-template: $v is empty" >&2; exit 1; fi
done
echo "railway-template: Kibana on port $SERVER_PORT, Elasticsearch at $ELASTICSEARCH_HOSTS as $ELASTICSEARCH_USERNAME, public URL ${SERVER_PUBLICBASEURL:-unset}"
exec /usr/local/bin/kibana-docker
