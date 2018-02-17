# jenkins container with addons
#
# VERSION               0.2

# TODO use jenkins LTS
FROM jenkins/jenkins:lts

ARG uid=1000

USER root
RUN chown ${uid} -R "$JENKINS_HOME"

# Install plugins, see https://github.com/jenkinsci/docker#preinstalling-plugins
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt
# tell jenkins that this Jenkins installation is fully configured. Otherwise a
# banner will appear prompting the user to install additional plugins, which may be inappropriate.
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false
# drop back to the regular jenkins user - good practice
USER jenkins

# User

ENV JENKINS_USER admin
ENV JENKINS_PASS admin

COPY groovy_init/init.groovy /usr/share/jenkins/ref/init.groovy.d/init.groovy
COPY config/jenkins /usr/share/jenkins/ref/config
