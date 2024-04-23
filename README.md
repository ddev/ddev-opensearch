# DDEV OpenSearch Add-on

This addon sets up two services in your [DDEV](https://ddev.com) project.

- [OpenSearch](https://opensearch.org/) service (Docker Image: `opensearchproject/opensearch:latest`)
- [OpenSearch Dashboards](https://opensearch.org/) service (Docker Image: `opensearchproject/opensearch-dashboards:latestopensearch:latest`)

We activate these plugins out-of-the-box:
- analysis-phonetic
- analysis-icu

To change the version, update the `.ddev/opensearch/Dockerfile` for the main OpenSearch Service.
Update the file `.ddev/docker-compose.opensearch.yaml` for a compatible Dashboards version.

## Installation

1. Run `ddev get ddev/ddev-opensearch` to install the addon in your exiting DDEV project.
2. `ddev restart` to restart your project.

## Usage

After installation, you can access the OpenSearch instance by visiting `https://<yourname>.ddev.site:9201` (encrypted) or `http://<yourname>.ddev.site:9200`.

The Dashboards can be accessed via: `https://<yourname>.ddev.site:5602`.

Run `ddev describe` to list your project's services and their URLs.

## Logging

All logs are directed to the container's stdout.

You can view the logs with `ddev logs -s opensearch` and `ddev logs -s opensearch-dashboards`

**Contributed and maintained by [@cmuench](https://github.com/cmuench) from [@netz98](https://github.com/netz98) org**

**Co-maintained by [@stasadev](https://github.com/stasadev)**
