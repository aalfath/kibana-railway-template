[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/new/template/kibana-1?utm_medium=integration&utm_source=button&utm_campaign=kibana)

# Kibana on Railway

A one-click [Railway](https://railway.com) template for [Kibana](https://www.elastic.co/kibana) with its own Elasticsearch node.

| Service | Folder | Image (pinned by version and digest) | Volume |
|---|---|---|---|
| Kibana (public) | `kibana/` | `elastic/kibana:9.5.6@sha256:c7ed45da5c3cfea020fc6c99ce027f4d21d19dab330379c5115d5eb95f6ecebc` | none: Kibana keeps its data in Elasticsearch |
| Elasticsearch (private) | `elasticsearch/` | `elastic/elasticsearch:9.5.6@sha256:79b4f1de4c15e6eca824723086a51e5934406d614d410cc11be77748cafac537` | `/usr/share/elasticsearch/data` |

The Docker Hub `elastic/*` images are the same builds as `docker.elastic.co` (identical digests). Both services build from this repo, so Railway tells everyone who deployed the template when a new version lands on `main`.

## What you get

- Kibana 9.5.6 on a public HTTPS domain, behind Elastic's login page.
- A single-node Elasticsearch 9.5.6 with security on, reachable only over Railway's private network. Its data lives on a volume, so it survives redeploys and restarts.
- Generated passwords: `elastic` (the superuser you log in with) and `kibana_system` (the account Kibana uses). Kibana never holds the superuser password.
- Generated encryption keys for sessions, saved objects (alerting, connectors) and reports, so those keep working across redeploys.
- Health checks: Kibana `/api/status`, Elasticsearch `/_cluster/health` (the only call allowed without a login).

## After deploying

1. Open the Kibana service's domain.
2. Log in as `elastic` with the `ELASTIC_PASSWORD` shown in the **Elasticsearch** service's Variables tab.
3. Create more users under Stack Management → Security → Users, and use them day to day.

The first start takes 2 to 4 minutes while Elasticsearch creates its system indices.

## Variables

| Service | Variable | Default | Notes |
|---|---|---|---|
| Elasticsearch | `ELASTIC_PASSWORD` | generated | Password of the `elastic` superuser. Elasticsearch stores it on the first start; changing the variable later does not change the password. |
| Elasticsearch | `KIBANA_SYSTEM_PASSWORD` | generated | Set for the `kibana_system` user on every start. |
| Elasticsearch | `ES_JAVA_OPTS` | `-Xms1g -Xmx1g` | Java heap. Keep it at about half the memory you give the service. |
| Elasticsearch | `PORT` | `9200` | HTTP port on the private network. |
| Kibana | `ELASTICSEARCH_HOSTS` | private URL of Elasticsearch | Reference variable. |
| Kibana | `ELASTICSEARCH_PASSWORD` | `${{Elasticsearch.KIBANA_SYSTEM_PASSWORD}}` | Reference variable. |
| Kibana | `SERVER_PUBLICBASEURL` | `https://${{RAILWAY_PUBLIC_DOMAIN}}` | Update it if you add a custom domain. |
| Kibana | `XPACK_*_ENCRYPTIONKEY` (3) | generated | Don't change them after the first start, or saved secrets can't be decrypted. |
| Kibana | `PORT` | `5601` | |

Optional: send data from outside Railway by adding a public domain to the Elasticsearch service (port 9200) and using an API key or a dedicated user. Kibana's fixed settings (`status.allowAnonymous`, telemetry off, `server.host`) are in `kibana/start.sh`; any [Kibana setting](https://www.elastic.co/docs/reference/kibana/configuration-reference) can also be set as an upper-case variable, for example `SERVER_BASEPATH`.

## Updates

Version bumps land on `main` with an entry in [CHANGELOG.md](CHANGELOG.md), breaking changes first. Railway then shows an "update available" notice in your project, and you choose when to apply it. Elasticsearch and Kibana must stay on the same version, so apply the update to both services together. Elasticsearch can upgrade in place within a major version; read Elastic's upgrade notes before a major upgrade.
