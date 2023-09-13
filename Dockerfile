FROM python:3.9-alpine3.13
LABEL maintainer="mariskx"
ENV PYTHONUNBUFFERED 1

# Install git
RUN apk add --no-cache git

WORKDIR /MyGarage
