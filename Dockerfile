#################################################################
# Dockerfile for Zimbra Ubuntu
# Based on Ubuntu 20.04
# Created by AnhIT
#################################################################
FROM ubuntu:20.04 as cache-image
MAINTAINER AnhIT <anhdh.workspace@gmailcom>

ENV DEBIAN_FRONTEND=noninteractive
## Set Local Repos
RUN cp /etc/apt/sources.list /tmp/
RUN echo "deb http://singapore.mirrors.linode.com/ubuntu/ focal main restricted universe multiverse" > /etc/apt/sources.list
RUN echo "deb http://singapore.mirrors.linode.com/ubuntu/ focal-updates main restricted universe multiverse" >> /etc/apt/sources.list
RUN echo "deb http://singapore.mirrors.linode.com/ubuntu/ focal-security main restricted universe multiverse" >> /etc/apt/sources.list

# Enable install resolvconf
RUN echo 'resolvconf resolvconf/linkify-resolvconf boolean false' | debconf-set-selections

# Update package lists
RUN apt-get update -y && \
    apt-get upgrade -y && apt-get install sudo -y
RUN apt-get install -y bind9 bind9utils openssh-client netcat-openbsd sudo libidn11 libpcre3 libgmp10 libexpat1 libstdc++6 libperl5.30 libaio1 resolvconf unzip pax sysstat sqlite3 dnsutils iputils-ping w3m gnupg2 less lsb-release   net-tools vim tzdata wget iproute2 locales curl

RUN apt-get -y install nano

ENV TZ=Asia/Ho_Chi_Minh

# Configure Timezone
RUN ln -sf /usr/share/zoneinfo/Asia/Ho_Chi_Minh /etc/localtime
RUN echo "Asia/Ho_Chi_Minh" > /etc/timezone

# Add LC_ALL on .bashrc
RUN echo 'export LC_ALL="en_US.UTF-8"' >> /root/.bashrc
RUN locale-gen en_US.UTF-8

# Download dns-auto.sh
RUN curl -k https://raw.githubusercontent.com/imanudin11/zimbra-docker/master/dns-auto.sh > /srv/dns-auto.sh
RUN chmod +x /srv/dns-auto.sh

# Copy rsyslog services
RUN mv /etc/init.d/rsyslog /tmp/
RUN curl -k https://raw.githubusercontent.com/imanudin11/zimbra-docker/master/rsyslog > /etc/init.d/rsyslog
RUN chmod +x /etc/init.d/rsyslog

# Crontab for rsyslog
RUN (crontab -l 2>/dev/null; echo "1 * * * * /etc/init.d/rsyslog restart > /dev/null 2>&1") | crontab -

# Build frontend
FROM cache-image as builder

# Bộ cài zimbra
RUN cd /tmp/ && \ 
    wget https://files.zimbra.com/downloads/8.8.15_GA/zcs-8.8.15_GA_4179.UBUNTU20_64.20211118033954.tgz

RUN mkdir /home/Zimbra

RUN tar -xzf /tmp/zcs-8.8.15_GA_4179.UBUNTU20_64.20211118033954.tgz -C /tmp/ && \
    cp -r /tmp/zcs-8.8.15_GA_4179.UBUNTU20_64.20211118033954/*  /home/zimbra

# Xóa tệp cài đặt và thư mục tạm sau khi đã sao chép
RUN rm /tmp/zcs-8.8.15_GA_4179.UBUNTU20_64.20211118033954.tgz && \
    rm -rf /tmp/zcs-8.8.15_GA_4179.UBUNTU20_64.20211118033954
# Startup service
RUN echo 'cat /etc/resolv.conf > /tmp/resolv.ori' > /services.sh
RUN echo 'echo "nameserver 127.0.0.1" > /tmp/resolv.add' >> /services.sh
RUN echo 'cat /tmp/resolv.add /tmp/resolv.ori > /etc/resolv.conf' >> /services.sh
RUN echo '/etc/init.d/named restart' >> /services.sh
RUN echo '/etc/init.d/rsyslog restart' >> /services.sh
RUN chmod +x /services.sh

# Entrypoint
ENTRYPOINT /services.sh && /bin/bash
