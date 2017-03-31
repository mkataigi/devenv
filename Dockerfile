FROM ubuntu:latest
MAINTAINER Makoto Kataigi mkataigi@gmail.com

RUN apt-get -y update && apt-get -y upgrade

# fuse workaround
RUN chmod go+w,u+s /tmp
RUN apt-get install -y libfuse2
RUN mkdir /tmp/fuse \
  && cd /tmp/fuse \
  && apt-get download fuse \
  && dpkg-deb -x fuse_* . \
  && dpkg-deb -e fuse_* \
  && rm fuse_*.deb \
  && echo -en '#!/bin/bash\nexit 0\n' > DEBIAN/postinst \
  && dpkg-deb -b . /fuse.deb \
  && dpkg -i /fuse.deb \
  && cd / \
  && rm -rf /tmp/fuse /fuse.deb
RUN dpkg-divert --local --rename --add /sbin/initctl && rm -f /sbin/initctl && ln -s /bin/true /sbin/initctl

# packages
RUN apt-get install -y language-pack-ja
RUN apt-get install -y zsh tmux git vim
RUN apt-get install -y wget unzip curl tree
RUN apt-get install -y openssh-server
RUN apt-get autoremove && apt-get clean
RUN dpkg-reconfigure openssh-server

# setup root
RUN echo 'root:root' |chpasswd
RUN locale-gen en_US en_US.UTF-8 &&  locale-gen ja_JP ja_JP.UTF-8 && dpkg-reconfigure locales

# setup ssh
RUN mkdir /var/run/sshd
RUN sed -i 's/.*session.*required.*pam_loginuid.so.*/session optional pam_loginuid.so/g' /etc/pam.d/sshd
RUN /bin/echo -e "LANG=\"ja_JP.UTF-8\"" > /etc/default/local

# add user
ARG userpasswd="userpassword"
RUN useradd -m mkataigi -g users
RUN echo 'mkataigi:$userpasswd' | chpasswd
RUN echo "mkataigi ALL=(ALL) ALL" >> /etc/sudoers
RUN chsh -s /bin/zsh mkataigi

ADD id_rsa_app /home/mkataigi/id_rsa_app
ADD id_rsa.pub /home/mkataigi/id_rsa.pub
RUN cat /home/mkataigi/id_rsa.pub >> /home/mkataigi/authorized_keys

RUN mkdir /home/mkataigi/.ssh \
  && mv /home/mkataigi/id_rsa_app /home/mkataigi/.ssh/id_rsa \
  && mv /home/mkataigi/id_rsa.pub /home/mkataigi/.ssh/id_rsa.pub \
  && mv /home/mkataigi/authorized_keys /home/mkataigi/.ssh/authorized_keys \
  && chmod 400 /home/mkataigi/.ssh/id_rsa \
  && chmod 700 /home/mkataigi/.ssh \
  && chown -R mkataigi:users /home/mkataigi/.ssh

RUN mkdir /home/mkataigi/repo \
  && chown -R mkataigi:users /home/mkataigi/repo

# Setup
USER mkataigi
ENV HOME /home/mkataigi
WORKDIR /home/mkataigi/repo
ARG githuboauthtoken
RUN git clone https://$githuboauthtoken:x-oauth-basic@github.com/mkataigi/devenv.git
RUN /home/mkataigi/repo/devenv/bin/init_myenv.sh -f

# Start
USER root
EXPOSE 22
CMD /usr/sbin/sshd -D
