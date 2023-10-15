#################################################################
# Dockerfile for Zimbra Ubuntu
# Based on Ubuntu 18.04
# Created by AnhIT
#################################################################
FROM ubuntu:18.04 as cache-image
MAINTAINER AnhIT <anhdh.workspace@gmailcom>

ARG DEBIAN_FRONTEND=noninteractive


RUN mkdir /home/zimbra
# Copy tệp cài đặt vào thư mục /tmp trong container
COPY zcs-8.8.15_GA_3869.UBUNTU18_64.20190917004220.tgz /tmp/

# Giải nén tệp cài đặt và sao chép vào thư mục /home/root

RUN tar -xzvf /tmp/zcs-8.8.15_GA_3869.UBUNTU18_64.20190917004220.tgz -C /tmp/ && \
    cp -r /tmp/zcs-8.8.15_GA_3869.UBUNTU18_64.20190917004220/*  /home/zimbra

# Xóa tệp cài đặt và thư mục tạm sau khi đã sao chép
RUN rm /tmp/zcs-8.8.15_GA_3869.UBUNTU18_64.20190917004220.tgz && \
    rm -rf /tmp/zcs-8.8.15_GA_3869.UBUNTU18_64.20190917004220

# Build frontend
FROM cache-image as builder

ENV TZ=Asia/Ho_Chi_Minh

## Set Local Repos
RUN cp /etc/apt/sources.list /tmp/
RUN echo "deb http://singapore.mirrors.linode.com/ubuntu/ bionic main restricted universe multiverse" > /etc/apt/sources.list
RUN echo "deb http://singapore.mirrors.linode.com/ubuntu/ bionic-updates main restricted universe multiverse" >> /etc/apt/sources.list
RUN echo "deb http://singapore.mirrors.linode.com/ubuntu/ bionic-security main restricted universe multiverse" >> /etc/apt/sources.list


# Update and Upgrade Ubuntu
RUN     apt-get update -y && \
        apt-get upgrade -y && apt-get install sudo -y

# Enable install resolvconf
RUN echo 'resolvconf resolvconf/linkify-resolvconf boolean false' | debconf-set-selections

# Install dependencies
RUN apt-get install -y bind9 bind9utils ssh netcat-openbsd sudo libidn11 libpcre3 libgmp10 libexpat1 libstdc++6 libperl5.26 libaio1 resolvconf unzip pax sysstat sqlite3 dnsutils iputils-ping w3m gnupg less lsb-release rsyslog net-tools vim tzdata wget iproute2 locales curl

# Configure Timezone
RUN echo "tzdata tzdata/Areas select Asia\ntzdata tzdata/Zones/Asia select Jakarta" > /tmp/tz ; debconf-set-selections /tmp/tz; rm /etc/localtime /etc/timezone; dpkg-reconfigure -f noninteractive tzdata
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
RUN sed -i '/imklog/s/^/#/' /etc/rsyslog.conf

# Crontab for rsyslog
RUN (crontab -l 2>/dev/null; echo "1 * * * * /etc/init.d/rsyslog restart > /dev/null 2>&1") | crontab -

# Startup service
RUN echo 'cat /etc/resolv.conf > /tmp/resolv.ori' > /services.sh
RUN echo 'echo "nameserver 127.0.0.1" > /tmp/resolv.add' >> /services.sh
RUN echo 'cat /tmp/resolv.add /tmp/resolv.ori > /etc/resolv.conf' >> /services.sh
RUN echo '/etc/init.d/bind9 restart' >> /services.sh
RUN echo '/etc/init.d/rsyslog restart' >> /services.sh
#RUN echo '/etc/init.d/zimbra restart' >> /services.sh
RUN chmod +x /services.sh

# Entrypoint
ENTRYPOINT /services.sh && /bin/bash
