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

1. Run `ddev add-on get ddev/ddev-opensearch` to install the addon in your exiting DDEV project.
2. `ddev restart` to restart your project.

## Configuration

To modify the build of the used OpenSearch image for the container there are dotenv variables available.

- `OPENSEARCH_TAG` - The version of the OpenSearch image to use. Default: `latest`
- `OPENSEARCH_DASHBOARDS_TAG` - The version of the OpenSearch Dashboards image to use. Default: `latest`
- `INSTALL_PLUGIN_ANALYSIS_PHONETIC` - Install the analysis-phonetic plugin. Default: `true`
- `INSTALL_PLUGIN_ANALYSIS_ICU` - Install the analysis-icu plugin. Default: `true`

Use the `ddev dotenv` command to set these variables.

Example:

```bash
ddev dotenv set .ddev/.env.opensearch \
    --opensearch-tag=2.15.0 \
    --opensearch-dashboards-tag=2.15.0 \
    --install-plugin-analytics-phonetic=false \ 
    --install-plugin-analytics-icu=false
```

## Usage

After installation, you can access the OpenSearch instance by visiting `https://<yourname>.ddev.site:9201` (encrypted) or `http://<yourname>.ddev.site:9200`.

The Dashboards can be accessed via: `https://<yourname>.ddev.site:5602`.

Run `ddev describe` to list your project's services and their URLs.

## Logging

All logs are directed to the container's stdout.

You can view the logs with `ddev logs -s opensearch` and `ddev logs -s opensearch-dashboards`

**Contributed and maintained by [@cmuench](https://github.com/cmuench) from [@netz98](https://github.com/netz98) org**

**Co-maintained by [@stasadev](https://github.com/stasadev)**
