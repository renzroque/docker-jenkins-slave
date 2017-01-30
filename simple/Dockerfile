FROM oberthur/docker-ubuntu-java:jdk8_8.121.13

ENV SWARM_VERSION=2.2

RUN curl -o /opt/swarm-client-${SWARM_VERSION}-jar-with-dependencies.jar http://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/${SWARM_VERSION}/swarm-client-${SWARM_VERSION}-jar-with-dependencies.jar 
COPY swarm_slave.sh /usr/bin/swarm_slave.sh
COPY socat_slave.sh /usr/bin/socat_slave.sh

RUN chmod +x /usr/bin/*_slave.sh \
  && mkdir -p /etc/supervisor/conf.d \

  # Make sure the package repository is up to date.
  && apt-get update \
  && apt-get install -y git supervisor openssh-client unzip wget bzip2 socat python-yaml rsync \

  # clean all cache to clean space
  && rm -rf /var/lib/apt/lists/* \
  && apt-get clean \
  && apt-get -y autoremove

ENTRYPOINT ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf"]
