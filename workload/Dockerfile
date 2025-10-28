# Start from a thin linux distribution.
FROM docker.io/library/alpine:latest
LABEL maintainer="Antithesis <support@antithesis.com>"

# Make sure to update the current packages, then grab the two programs
# we'll need to have in order for the workload driver to run.
RUN apk update
RUN apk upgrade
RUN apk add bash curl

# Create my first test directory and switch to it.
WORKDIR /opt/antithesis/test/v1/quickstart

# Add source code
COPY workload.sh ./parallel_driver_workload.sh
COPY healthcheck.sh ./parallel_driver_healthcheck.sh

RUN chmod +x *.sh

# Define the entrypoint.
# Make sure to use the array version of this specification, so other command-line
# arguments and parameters can be specified in the Dockerfile.
ENTRYPOINT [ "/bin/bash", "./parallel_driver_healthcheck.sh" ]