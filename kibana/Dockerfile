# Kibana for the Kibana Railway template.
# Same build as docker.elastic.co/kibana/kibana:9.5.6 (identical digest on Docker Hub).
FROM elastic/kibana:9.5.6@sha256:c7ed45da5c3cfea020fc6c99ce027f4d21d19dab330379c5115d5eb95f6ecebc

COPY --chmod=0755 start.sh /usr/local/bin/railway-start.sh
ENTRYPOINT ["/bin/tini", "-s", "--", "/usr/local/bin/railway-start.sh"]
