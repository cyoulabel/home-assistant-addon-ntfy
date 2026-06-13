ARG BUILD_ARCH=amd64
ARG BUILD_VERSION=1.0.0

FROM binwiederhier/ntfy:latest

RUN apk add --no-cache jq

LABEL \
  io.hass.version="${BUILD_VERSION}" \
  io.hass.type="addon" \
  io.hass.arch="${BUILD_ARCH}"

COPY run.sh /run.sh
RUN chmod +x /run.sh

ENTRYPOINT ["/run.sh"]
