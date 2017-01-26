FROM oberthur/docker-ubuntu-java:jdk8_8.112.15

ENV SWARM_VERSION=2.2 \
  ANT_VERSION=1.9.4 \
  ANT_HOME=/usr/share/ant \
  PHANTOMJS_VERSION=2.1.1 \
  PHANTOMJS_PLATFORM=linux-x86_64

ENV PATH="$PATH:$DOCKER_PATH:$HOME/.rbenv/bin"

# Add external repository
RUN add-apt-repository -y ppa:brightbox/ruby-ng-experimental

RUN curl -Lo /opt/swarm-client-${SWARM_VERSION}-jar-with-dependencies.jar http://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/${SWARM_VERSION}/swarm-client-${SWARM_VERSION}-jar-with-dependencies.jar \

  && echo '#!/bin/bash\n\nexec java -jar /opt/swarm-client-$SWARM_VERSION-jar-with-dependencies.jar -disableClientsUniqueId -username $JENKINS_USERNAME -password $JENKINS_PASSWORD -mode ${JENKINS_MODE:-exclusive} -name $JENKINS_SLAVE_NAME -executors ${JENKINS_EXEC_NR:-1} -master ${JENKINS_URL:-127.0.0.1} -fsroot $JENKINS_FS_ROOT -labels "${JENKINS_LABELS:-swarm}"' > /usr/bin/swarm_slave.sh \
  && chmod +x /usr/bin/swarm_slave.sh \
  && mkdir -p /etc/supervisor/conf.d \
  && echo "[program:swarm-slave]\ncommand=/usr/bin/swarm_slave.sh\nuser=root" > /etc/supervisor/conf.d/supervisor.conf \

  # install ant
  && curl -fsSL http://archive.apache.org/dist/ant/binaries/apache-ant-$ANT_VERSION-bin.tar.gz | tar xzf - -C /usr/share \
  && mv /usr/share/apache-ant-$ANT_VERSION /usr/share/ant \
  && ln -s /usr/share/ant/bin/ant /usr/bin/ant \

  # Make sure the package repository is up to date.
  && apt-get update \
  && apt-get install -y git supervisor openssh-client zip unzip wget bzip2 gitstats python-yaml libyaml-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties libffi-dev rsync \

  && mkdir -p /opt/phantomjs \
  && curl -fsSL https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-${PHANTOMJS_VERSION}-${PHANTOMJS_PLATFORM}.tar.bz2 | tar xjf - -C /opt/phantomjs --strip 1 \
  && ln -s /opt/phantomjs/bin/phantomjs /usr/bin/phantomjs \

  # Install ruby deps
  && apt-get -y install ruby2.1 ruby2.1-dev ruby2.2-dev nodejs build-essential libssl-dev libreadline-dev zlib1g-dev libsqlite3-dev libmysqlclient-dev bundler libgmp3-dev libmysqlclient20 \
  && gem install bundler --no-ri --no-rdoc \

  # Install some common things like make and gcc
  && apt-get -y install gcc perl make g++ \

  # update path
  && mkdir -p $DOCKER_PATH \
  && apt-get install -y iptables kmod libnfnetlink0 module-init-tools \

  # clean all cache to clean space
  && rm -rf /var/lib/apt/lists/* \
  && apt-get clean \
  && apt-get -y autoremove \

  # install rbenv and ruby-build to manage ruby versions
  && git clone https://github.com/rbenv/rbenv.git ~/.rbenv \
  && git clone https://github.com/rbenv/ruby-build ~/.rbenv/plugins/ruby-build \
  && git clone https://github.com/rbenv/rbenv-default-gems ~/.rbenv/plugins/rbenv-default-gems \
  && echo 'eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh \
  && echo 'eval "$(rbenv init -)"' >> .bashrc \
  && echo 'gem: --no-rdoc --no-ri' >> /.gemrc \
  && echo 'bundler\nrake' > ~/.rbenv/default-gems

ENTRYPOINT [ "/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf" ]
