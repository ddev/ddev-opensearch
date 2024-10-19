#ddev-generated
ARG OPENSEARCH_TAG=latest

FROM opensearchproject/opensearch:${OPENSEARCH_TAG}

ARG INSTALL_PLUGIN_ANALYSIS_PHONETIC=true
ARG INSTALL_PLUGIN_ANALYSIS_ICU=true

WORKDIR /usr/share/opensearch

# Install plugins
RUN if [ "${INSTALL_PLUGIN_ANALYSIS_PHONETIC}" = "true" ]; then bin/opensearch-plugin install analysis-phonetic; fi
RUN if [ "${INSTALL_PLUGIN_ANALYSIS_ICU}" = "true" ]; then bin/opensearch-plugin install analysis-icu; fi
