[![tests](https://github.com/ddev/ddev-opensearch/actions/workflows/tests.yml/badge.svg?branch=main)](https://github.com/ddev/ddev-opensearch/actions/workflows/tests.yml?query=branch%3Amain)
[![last commit](https://img.shields.io/github/last-commit/ddev/ddev-opensearch)](https://github.com/ddev/ddev-opensearch/commits)
[![release](https://img.shields.io/github/v/release/ddev/ddev-opensearch)](https://github.com/ddev/ddev-opensearch/releases/latest)

# DDEV OpenSearch

## Overview

[OpenSearch](https://opensearch.org/) is a community-driven, Apache 2.0-licensed open source search and analytics suite that makes it easy to ingest, search, visualize, and analyze data.

This add-on sets up two services in your [DDEV](https://ddev.com) project:

- [OpenSearch](https://opensearch.org/) service (Docker Image: `opensearchproject/opensearch:latest`)
- [OpenSearch Dashboards](https://opensearch.org/docs/latest/dashboards/) service (Docker Image: `opensearchproject/opensearch-dashboards:latestopensearch:latest`)

We activate these [OpenSearch plugins](https://opensearch.org/docs/latest/install-and-configure/additional-plugins/index/) out-of-the-box:

- analysis-icu
- analysis-phonetic

## Installation

```bash
ddev add-on get ddev/ddev-opensearch
ddev restart
```

After installation, make sure to commit the `.ddev` directory to version control.

## Usage

| Command | Description |
| ------- | ----------- |
| `ddev launch :9201` | OpenSearch |
| `ddev launch :5602` | OpenSearch Dashboards |
| `ddev describe` | View service status and used ports for OpenSearch |
| `ddev logs -s opensearch` | View OpenSearch logs |
| `ddev logs -s opensearch-dashboards` | View OpenSearch Dashboards logs |

## Advanced Customization

To upgrade or downgrade:

```bash
# remove old opensearch volume (if this is downgrade)
ddev stop
docker volume rm ddev-$(ddev status -j | docker run -i --rm ddev/ddev-utilities jq -r '.raw.name')_opensearch

# set the desired versions for OpenSearch
ddev dotenv set .ddev/.env.opensearch --opensearch-tag="2" --opensearch-dashboards-tag="2"
ddev add-on get ddev/ddev-opensearch
ddev restart
```

Make sure to commit the `.ddev/.env.opensearch` file to version control.

To change the installed plugins:

```bash
# https://opensearch.org/docs/latest/install-and-configure/additional-plugins/index/
ddev dotenv set .ddev/.env.opensearch --opensearch-plugins="analysis-icu analysis-phonetic"
ddev add-on get ddev/ddev-opensearch
# rebuild opensearch image
ddev debug rebuild -s opensearch
```

Make sure to commit the `.ddev/.env.opensearch` file to version control.

All customization options (use with caution):

| Variable | Flag | Default |
| -------- | ---- | ------- |
| `OPENSEARCH_PLUGINS` | `--opensearch-plugins` | `analysis-icu analysis-phonetic` |
| `OPENSEARCH_TAG` | `--opensearch-tag` | `latest` |
| `OPENSEARCH_DASHBOARDS_TAG` | `--opensearch-dashboards-tag` | `latest` |

**Contributed and maintained by [@cmuench](https://github.com/cmuench) from [@netz98](https://github.com/netz98) org**

**Co-maintained by the [DDEV team](https://ddev.com/support-ddev/)**
