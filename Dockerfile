# gcloud-sdk include docker already and based on Debian
ARG BASE_IMAGE=gcr.io/google.com/cloudsdktool/cloud-sdk
ARG TARGETPLATFORM
ARG BUILDPLATFOM
FROM ${BASE_IMAGE}

RUN echo "Traget: ${TARGETPLATFORM}, Build: ${BUILDPLATFOM}"
ENV ARCH=amd64 \
    OS=linux
RUN curl -H 'CI: true' --fail --location --output /tmp/ns.tar.gz "https://get.namespace.so/packages/ns/latest?arch=${ARCH}&os=${OS}" && \
    tar -xzf /tmp/ns.tar.gz -C /usr/bin && \
    chmod +x /usr/bin/ns && \
    rm -f /tmp/ns.tar.gz

RUN /usr/bin/ns config disable telemetry

ENTRYPOINT [ "/usr/bin/ns" ]