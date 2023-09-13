FROM gitpod/workspace-full
LABEL maintainer="mariskx"
ENV PYTHONUNBUFFERED 1

# Application setup
COPY ./MyGarage /MyGarage
WORKDIR /MyGarage
EXPOSE 8050

# Install dependencies and create Gitpod user
RUN apk add --no-cache git bash sudo docker iptables \
        libgcc gcompat libstdc++ postgresql-client \
        build-base postgresql-dev musl-dev && \
    echo '%gitpod ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/gitpod && \
    addgroup -g 33333 gitpod && \
    adduser -u 33333 -G gitpod -h /home/gitpod -s /bin/bash -D gitpod && \
    python -m venv /py && \
    /py/bin/pip install --upgrade pip

# Copy requirements
COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt

# Install Python packages
RUN /py/bin/pip install -r /tmp/requirements.txt

# Conditionally install dev requirements
ARG DEV=false
RUN if [ "$DEV" = "true" ]; then \
        /py/bin/pip install -r /tmp/requirements.dev.txt; \
    fi

# Cleanup
RUN rm -rf /tmp && \
    apk del build-base postgresql-dev musl-dev

# Setup environment and switch to Gitpod user
ENV PATH="/py/bin:$PATH"
USER gitpod
