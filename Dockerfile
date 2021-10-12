# syntax=docker/dockerfile:1
FROM python:3.9-alpine3.13 AS build

WORKDIR /app

ARG BLACK_VERSION
ARG BLACK_EXTRAS=python2,uvloop

ENV PYTHONUNBUFFERED=1

# Install build dependencies

RUN apk add --no-cache \
    gcc \
    build-base \
    musl-dev \
    python3-dev 

# Create venv and install black with HTTP server support, then unintall excessive packages
RUN python -m venv --copies venv && \
    venv/bin/pip install -U pip setuptools wheel && \
    venv/bin/pip install black[d]==$BLACK_VERSION && \
    if [ ! -z $BLACK_EXTRAS ] ; then venv/bin/pip install black[$BLACK_EXTRAS] ; fi && \
    venv/bin/pip uninstall pip setuptools wheel -y

FROM python:3.9-alpine3.13 AS prod

COPY --from=build /app/venv /app/venv

ARG NAME="blackd"
ARG MAINTAINER

ENV PYTHONUNBUFFERED=1
ENV PATH /app/venv/bin:$PATH
ENV BLACKD_PORT 45484

LABEL image="${NAME}:${BLACK_VERSION}"
LABEL maintainer="${MAINTAINER}"
LABEL url="https://github.com/majabojarska/docker-blackd"

EXPOSE ${BLACKD_PORT}

# As healthcheck, format empty string
HEALTHCHECK --interval=10s CMD curl localhost:${BLACKD_PORT} -d ""

CMD blackd --bind-host 0.0.0.0
