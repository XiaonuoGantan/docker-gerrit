FROM phusion/baseimage:0.9.15

ENV HOME /root

RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

CMD ["/sbin/my_init"]

ENV GERRIT_WAR /home/gerrit/gerrit.war
ENV GERRIT_ROOT /home/gerrit/gerrit
ENV GERRIT_USER gerrit
ENV GERRIT_HOME /home/gerrit

RUN useradd -m $GERRIT_USER
RUN mkdir -p $GERRIT_HOME
RUN apt-get update -y && apt-get install -y openjdk-7-jre-headless git-core

RUN chown ${GERRIT_USER}:${GERRIT_USER} $GERRIT_HOME

RUN mkdir -p /etc/my_init.d
ADD http://gerrit-releases.storage.googleapis.com/gerrit-2.9.3.war $GERRIT_WAR
ADD run_gerrit.sh /etc/my_init.d/run_gerrit.sh
RUN chown $GERRIT_USER:$GERRIT_USER $GERRIT_WAR

USER gerrit
RUN java -jar $GERRIT_WAR init --batch -d $GERRIT_ROOT
RUN chown -R $GERRIT_USER:$GERRIT_USER $GERRIT_ROOT

USER root
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
EXPOSE 8080 29418
