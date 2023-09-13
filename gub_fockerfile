FROM python:3.9-alpine3.13
LABEL maintainer="mariskx"
ENV PYTHONUNBUFFERED 1

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./MyGarage /MyGarage

WORKDIR /MyGarage
EXPOSE 8050

ARG DEV=false

RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    apk add --update --no-cache postgresql-client && \
    apk add --update --no-cache --virtual .tmp-build-deps \
        build-base postgresql-dev musl-dev && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true" ] ; \
        then echo "--DEV BUILD--" && /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    rm -rf /tmp && \
    apk del .tmp-build-deps && \
    addgroup -g 1000 gitpod && \
    adduser \
    --disabled-password \
    --no-create-home \
    --uid 1000 \
    --ingroup gitpod \
    django-user

ENV PATH="/py/bin:$PATH"

USER django-user
