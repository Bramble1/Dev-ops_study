# Base Image
FROM jenkins/jenkins:lts-jdk11


USER root


#Install plugins
#jenkins-pluugin-cli is sed to installrequired plugins, and we switch to root
#to install them

RUN jenkins-plugin-cli --plugins\
	git \
	workflow-aggregator \
	docker-workflow \
	credentials-binding \
	ssh \
	ws-cleanup \
	ansicolor



USER jenkins

#skip iniital setup
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"

# Copy custom configuration files (if any)
COPY config/*.groovy /usr/share/jenkins/ref/init.groovy.d/

#set the desired Jenkns home directory permissions
USER root
RUN chown -R jenkins:jenkins /var/jenkins_home/

#EXpose the jenkins port
EXPOSE 8080


#RUN wget -O /sbin/tini https://github.com/krallin/tini/releases/download/v0.19.0/tini-static && chmod +x /sbin/tini

#start jenkins
#ENTRYPOINT ["/usr/bin/bash", "--", "/usr/local/bin/jenkins.sh"]
