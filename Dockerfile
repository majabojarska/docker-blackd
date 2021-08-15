# syntax=docker/dockerfile:1
FROM --platform=$BUILDPLATFORM python:3-alpine AS build

ARG BLACK_VERSION
ARG BLACK_EXTRAS=python2,uvloop

ENV PYTHONUNBUFFERED=1

# Install build dependencies
RUN apk add \
    gcc \
    musl-dev \
    build-base \
    python3-dev

# Create venv and install black with HTTP server support
RUN python -m venv --copies /app/venv
RUN /app/venv/bin/pip install -U pip setuptools wheel
RUN /app/venv/bin/pip install black[d]==$BLACK_VERSION
RUN if [ ! -z $BLACK_EXTRAS ] ; then /app/venv/bin/pip install black[$BLACK_EXTRAS] ; fi


# Remove packages that are not needed anymore
RUN /app/venv/bin/pip uninstall pip setuptools wheel -y

FROM python:alpine AS prod

COPY --from=build /app/venv /app/venv/

ARG BLACKD_PORT=45484
ARG NAME="blackd"
ARG MAINTAINER
LABEL image="${NAME}:${BLACK_VERSION}"
LABEL maintainer="${MAINTAINER}"
LABEL url="https://github.com/majabojarska/docker-blackd"

ENV PYTHONUNBUFFERED=1
ENV PATH /app/venv/bin:$PATH
ENV BLACKD_PORT $BLACKD_PORT

# As healthcheck, format empty string
HEALTHCHECK CMD curl localhost:${BLACKD_PORT} -d ""

CMD blackd --bind-host 0.0.0.0 --bind-port ${BLACKD_PORT}
