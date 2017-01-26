FROM oberthur/docker-ubuntu-java:jdk8_8.112.15

ENV SWARM_VERSION=2.2 \
  GRADLE_VERSION=2.2 \
  MAVEN_VERSION=3.3.9 \
  ANDROID_VERSION=25 \
  ANDROID_SDK_VERSION=24.4.1 \
  GRADLE_HOME=/usr/share/gradle \
  MAVEN_HOME=/usr/share/maven \
  ANDROID_HOME=/opt/android-sdk-linux

ENV PATH $GRADLE_HOME/bin:$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$PATH

RUN curl -o /opt/swarm-client-${SWARM_VERSION}-jar-with-dependencies.jar http://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/${SWARM_VERSION}/swarm-client-${SWARM_VERSION}-jar-with-dependencies.jar \
  && echo '#!/bin/bash\n\nexec java -jar /opt/swarm-client-$SWARM_VERSION-jar-with-dependencies.jar -disableClientsUniqueId -username $JENKINS_USERNAME -password $JENKINS_PASSWORD -mode ${JENKINS_MODE:-exclusive} -name $JENKINS_SLAVE_NAME -executors ${JENKINS_EXEC_NR:-1} -master ${JENKINS_URL:-127.0.0.1} -fsroot $JENKINS_FS_ROOT -labels "${JENKINS_LABELS:-swarm}"' > /usr/bin/swarm_slave.sh \
  && chmod +x /usr/bin/swarm_slave.sh \
  && mkdir -p /etc/supervisor/conf.d \
  && echo "[program:swarm-slave]\ncommand=/usr/bin/swarm_slave.sh\nuser=root" > /etc/supervisor/conf.d/supervisor.conf \

  # Make sure the package repository is up to date.
  && apt-get update \
  && apt-get install -y git supervisor openssh-client zip unzip wget bzip2 python-yaml rsync \

  # install gradle 
  && curl -L https://services.gradle.org/distributions/gradle-$GRADLE_VERSION-all.zip > /usr/share/gradle-$GRADLE_VERSION-all.zip \
  && unzip -d /usr/share/ /usr/share/gradle-$GRADLE_VERSION-all.zip \
  && ln -s /usr/share/gradle-$GRADLE_VERSION /usr/share/gradle \
  && rm /usr/share/gradle-$GRADLE_VERSION-all.zip \
  && ln -s /usr/share/gradle/bin/gradle /usr/bin/gradle \

  # install maven
  && curl -fsSL http://apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | tar xzf - -C /usr/share \
  && mv /usr/share/apache-maven-$MAVEN_VERSION /usr/share/maven \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn \

  # install android deps
  && apt-get install -y unzip libc6-i386 lib32stdc++6 lib32gcc1 lib32ncurses5 lib32z1 \

  # install android sdk
  && curl -o /opt/android-sdk_r$ANDROID_SDK_VERSION-linux.tgz -L https://dl.google.com/android/android-sdk_r$ANDROID_SDK_VERSION-linux.tgz \
  && cd /opt && tar xzvf ./android-sdk_r$ANDROID_SDK_VERSION-linux.tgz \
  && rm android-sdk_r$ANDROID_SDK_VERSION-linux.tgz \
  && echo "y" | android update sdk --force --no-ui --all --filter platform-tools,build-tools-$ANDROID_VERSION.0.1,android-$ANDROID_VERSION,addon-google_apis-google-$ANDROID_VERSION,sys-img-x86-addon-google_apis-google-$ANDROID_VERSION,source-$ANDROID_VERSION,extra-android-m2repository,extra-google-m2repository \
  && mkdir -p /opt/android-sdk-linux/build-tools \
  && cd /opt/android-sdk-linux/build-tools \

  # install android build tools
  && cd /opt && curl -LO https://dl.google.com/android/repository/build-tools_r$ANDROID_VERSION-linux.zip \
  && unzip build-tools_r$ANDROID_VERSION-linux.zip \
  && rm build-tools_r$ANDROID_VERSION-linux.zip \

  # clean all cache to clean space
  && apt-get purge -y unzip \
  && rm -rf /var/lib/apt/lists/* \
  && apt-get clean \
  && apt-get -y autoremove

ENTRYPOINT ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf"]
