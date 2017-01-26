FROM otomato/ubuntu32:14.04

RUN locale-gen en_US.UTF-8  

ENV SWARM_VERSION=2.2 \
  JAVA_HOME=/usr/lib/jvm/java-7-oracle \
  ANT_VERSION=1.9.4 \
  ANT_HOME=/usr/share/ant \
  PHANTOMJS_VERSION=2.1.1 \
  PHANTOMJS_PLATFORM=linux-x86_64 \
  PATH=~/.rbenv/bin:$PATH \
  DEBIAN_FRONTEND=noninteractive \
  LANGUAGE=en_US.en \
  LANG=en_US.UTF-8 \
  LC_ALL=en_US.UTF-8

RUN echo 'APT::Install-Recommends "0"; \n\
          APT::Get::Assume-Yes "true"; \n\
          APT::Install-Suggests "0";' > /etc/apt/apt.conf \
  && apt-get update \
  && apt-get install vim-nox curl telnet software-properties-common dnsutils net-tools less netcat \
  && add-apt-repository ppa:webupd8team/java -y \
  && apt-get update \
  && curl -o /opt/swarm-client-${SWARM_VERSION}-jar-with-dependencies.jar http://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/${SWARM_VERSION}/swarm-client-${SWARM_VERSION}-jar-with-dependencies.jar \
  && echo '#!/bin/bash\n\nexec java -jar /opt/swarm-client-$SWARM_VERSION-jar-with-dependencies.jar -disableClientsUniqueId -username $JENKINS_USERNAME -password $JENKINS_PASSWORD -mode ${JENKINS_MODE:-exclusive} -name $JENKINS_SLAVE_NAME -executors ${JENKINS_EXEC_NR:-1} -master ${JENKINS_URL:-127.0.0.1} -fsroot $JENKINS_FS_ROOT -labels "${JENKINS_LABELS:-swarm}"' > /usr/bin/swarm_slave.sh \
  && chmod +x /usr/bin/swarm_slave.sh \
  && mkdir -p /etc/supervisor/conf.d \
  && echo "[program:swarm-slave]\ncommand=/usr/bin/swarm_slave.sh\nuser=root" > /etc/supervisor/conf.d/supervisor.conf \
 
  # Install ant
  && curl -fsSL http://archive.apache.org/dist/ant/binaries/apache-ant-$ANT_VERSION-bin.tar.gz | tar xzf - -C /usr/share \
  && mv /usr/share/apache-ant-$ANT_VERSION /usr/share/ant \
  && ln -s /usr/share/ant/bin/ant /usr/bin/ant \

  # Make sure the package repository is up to date.
  && echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections \
  && apt-get install -y oracle-java7-installer git openssh-client zip unzip wget bzip2 file make dos2unix supervisor \

  # Add SIM deps
  && apt-get install -y libomnithread3-dev libomniorb4-dev libcurl4-openssl-dev python-dev binutils g++ gcc omniidl omniorb libaio-dev flex \

  # clean all cache to clean space
  && rm -rf /var/lib/apt/lists/* \
  && apt-get clean \
  && apt-get -y autoremove

ENTRYPOINT [ "/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf" ]
