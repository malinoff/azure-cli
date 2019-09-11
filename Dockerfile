FROM python:3.7-alpine3.7 as builder

ARG AZURE_CLI_VERSION=2.0.73

RUN apk add --no-cache \
      build-base linux-headers openssl-dev libffi-dev

RUN pip wheel --no-cache-dir --disable-pip-version-check \
      --wheel-dir /root/wheels/ \
      azure-cli==$AZURE_CLI_VERSION

FROM python:3.7-alpine3.7

COPY --from=builder /root/wheels /root/.wheels
RUN pip install /root/.wheels/*

# Because azure-cli NEEDS bash
RUN apk add --no-cache bash

ENTRYPOINT ["az"]
