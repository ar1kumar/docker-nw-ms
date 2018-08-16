#
# To run this image after installing Docker, use a command like this:
# docker run --rm -it -p 443:443 -v ~/.msf4:/root/.msf4 -v /tmp/msf:/tmp/data {dockerimagename}

FROM ubuntu:14.04

WORKDIR /opt
USER root

#Gauntlt version
ARG GAUNTLT_VERSION=1.0.13

# Base packages
RUN apt-get update && apt-get -y install \
  git build-essential zlib1g zlib1g-dev \
  libxml2 libxml2-dev libxslt-dev locate curl \
  libreadline6-dev libcurl4-openssl-dev git-core \
  libssl-dev libyaml-dev openssl autoconf libtool \
  ncurses-dev bison curl wget xsel postgresql \
  postgresql-contrib postgresql-client libpq-dev \
  libapr1 libaprutil1 libsvn1 \
  libpcap-dev libsqlite3-dev libgmp3-dev \
  nasm tmux vim nmap \
  && rm -rf /var/lib/apt/lists/*

#Custom changes - disabled til git clone issue is solved
#RUN apt-get install --yes --no-install-recommends nmap iputils-ping ruby ruby-dev zlib1g-dev python python-dev python-pip make gcc curl &&  apt-get clean && gem install json gauntlt:${GAUNTLT_VERSION} --no-document && \

# startup script and tmux configuration file
RUN curl -sSL https://github.com/REMnux/docker/raw/master/metasploit/scripts/init.sh --output /usr/local/bin/init.sh && \
  chmod a+xr /usr/local/bin/init.sh && \
  curl -sSL https://github.com/REMnux/docker/raw/master/metasploit/conf/tmux.conf --output /root/.tmux.conf

COPY scripts/metasploit.sh /usr/local/bin/metasploit.sh

# Get Metasploit
#RUN git clone https://github.com/rapid7/metasploit-framework.git msf
#COPY ../../../usr/share/metasploit-framework msf
RUN apt-get update
RUN apt-get install -y software-properties-common
RUN apt-get install software-properties-common
RUN apt-get install apt-transport-https
RUN add-apt-repository "deb [arch=amd64] https://apt.metasploit.com/ trusty main"
RUN apt-get update
RUN apt-get install -y metasploit-framework --force-yes
WORKDIR msf

#Install WPSCAN
#RUN apt-get install libcurl4-openssl-dev libxml2 libxml2-dev libxslt1-dev ruby-dev build-essential libgmp-dev zlib1g-dev
#RUN git clone https://github.com/wpscanteam/wpscan.git && cd wpscan

# Install PosgreSQL
RUN curl -sSL https://github.com/REMnux/docker/raw/master/metasploit/scripts/db.sql --output /tmp/db.sql
RUN /etc/init.d/postgresql start && su postgres -c "psql -f /tmp/db.sql"
#RUN curl -sSL https://github.com/REMnux/docker/raw/master/metasploit/conf/database.yml --output /opt/msf/config/database.yml

# RVM
#RUN curl -sSL https://rvm.io/mpapis.asc | gpg --import
#RUN curl -L https://get.rvm.io | bash -s stable
#RUN /bin/bash -l -c "rvm requirements"
#RUN /bin/bash -l -c "rvm install 2.3.1"
#RUN /bin/bash -l -c "rvm use 2.3.1 --default"
#RUN /bin/bash -l -c "source /usr/local/rvm/scripts/rvm"
#RUN /bin/bash -l -c "gem install bundler --no-ri --no-rdoc"
#RUN /bin/bash -l -c "source /usr/local/rvm/scripts/rvm && which bundle"
#RUN /bin/bash -l -c "which bundle"

# Get dependencies
#RUN /bin/bash -l -c "BUNDLEJOBS=$(expr $(cat /proc/cpuinfo | grep vendor_id | wc -l) - 1)"
#RUN /bin/bash -l -c "bundle config --global jobs $BUNDLEJOBS"
#RUN /bin/bash -l -c "bundle install"

# Symlink tools to $PATH
RUN for i in `ls /opt/msf/tools/*/*`; do ln -s $i /usr/local/bin/; done
RUN ln -s /opt/msf/msf* /usr/local/bin

# settings and custom scripts folder
VOLUME /root/.msf4/
VOLUME /tmp/data/

# Starting script (DB + updates)
#CMD /usr/local/bin/init.sh

#Custom Start script + env Variables
ENV TARGET_HOST=127.0.0.1

CMD /usr/local/bin/metasploit.sh 
