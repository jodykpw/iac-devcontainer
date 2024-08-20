# Set version as a build argument
ARG FROM_IMAGE_NAME
ARG FROM_IMAGE_TAG

FROM ${FROM_IMAGE_NAME}:${FROM_IMAGE_TAG}

USER root

# Update package lists and install dev packages
RUN microdnf update -y && \
    microdnf install -y python3-pip wget unzip diffutils tar gzip git && \
    microdnf clean all && \
    python3 -m pip install --upgrade pip

# Ensure Python and Pip are in PATH
ENV PATH="/usr/bin/python3:${PATH}"

# Copy the requirements.txt file to the container's /app directory
COPY requirements.txt /tmp/requirements.txt

# Install packages listed in requirements.txt
RUN python3 -m pip install -r /tmp/requirements.txt

# Create a non-root user and group with UID and GID
RUN groupadd -g 1001 adminjody && useradd -u 1000 -g adminjody -ms /bin/bash adminjody

# Set the working directory and user
WORKDIR /app