FROM realityforge/busybox-java:jdk7
MAINTAINER Peter Donald <peter@realityforge.org>

ENV GLASSFISH_BASE_DIR /opt/glassfish
ENV GLASSFISH_DOMAINS_DIR /srv/glassfish/domains
ENV OPENMQ_INSTANCES_DIR /srv/openmq/instances

RUN opkg-install shadow-groupadd shadow-useradd && \
    useradd -d /srv/glassfish -M --comment "GlassFish User"  glassfish && \
    curl -jksSL http://s3-eu-west-1.amazonaws.com/payara.co/Payara+Downloads/payara-4.1.151.zip > /tmp/payara-4.1.151.zip && \
    unzip -o -q /tmp/payara-4.1.151.zip -d /opt && \
    mv /opt/payara41 ${GLASSFISH_BASE_DIR} && \
    rm /tmp/payara-4.1.151.zip && \
    mkdir -p ${GLASSFISH_DOMAINS_DIR} ${OPENMQ_INSTANCES_DIR} && \
    chown -R glassfish:glassfish /srv/glassfish /srv/openmq && \
    rm -rf ${GLASSFISH_BASE_DIR}/glassfish/domains/domain1 \
    ${GLASSFISH_BASE_DIR}/glassfish/modules/console-updatecenter-plugin.jar \
    ${GLASSFISH_BASE_DIR}/README.txt \
    ${GLASSFISH_BASE_DIR}/bin/*.bat \
    ${GLASSFISH_BASE_DIR}/bin/updatetool \
    ${GLASSFISH_BASE_DIR}/bin/pkg \
    ${GLASSFISH_BASE_DIR}/mq/bin/*.exe \
    ${GLASSFISH_BASE_DIR}/mq/lib/help \
    ${GLASSFISH_BASE_DIR}/mq/lib/images

# Should also delete ${GLASSFISH_BASE_DIR}/javadb but can't until timer database is configured to point at a real database

USER glassfish:glassfish

ENV PATH ${PATH}:${GLASSFISH_BASE_DIR}/glassfish/bin:${GLASSFISH_BASE_DIR}/mq/bin
