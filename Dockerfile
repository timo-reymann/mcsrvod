FROM ubuntu:18.04

ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8
ENV KILL_INTERVAL 9999999 

# Install system updates and stuff
RUN apt-get update && \
  apt-get update && \
  apt-get install -y --no-install-recommends locales gnupg netcat procps screen python3 python3-pip python3-setuptools xinetd iputils-ping openjdk-8-jre-headless && \
  apt-get clean all && \
  rm -rf /var/apt/cache/*

# Install dinnerbones great mcstatus tool, we will need this one for determing if any players are online, so we can kill the server!
RUN pip3 install mcstatus

# Add config file for xinetd
ADD conf/serviceConfig /etc/xinetd.d/mcsrvod

# Add some cmd scripts
ADD cmd/mcsrvod-start /usr/bin/mcsrvod-start
ADD cmd/mcsrvod-stop /usr/bin/mcsrvod-stop
ADD cmd/mcsrvod-playercount /usr/bin/mcsrvod-playercount
ADD cmd/mcsrvod-killtask /usr/bin/mcsrvod-killtask

# Make the cmd scripts executable
RUN chmod +x /usr/bin/mcsrvod*

# Add the run script
ADD run.sh /run.sh

# Make that executable too
RUN chmod +x /run.sh

# Set entrypoint
ENTRYPOINT /run.sh

# Specify volume
VOLUME ["/srv/mcsrvod"]

# Expose the port for our minecraft server
EXPOSE 3000
