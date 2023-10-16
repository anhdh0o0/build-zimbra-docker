# Build Redmine 8.8 on Ubuntu 20.04
Link download zimbra:
- https://files.zimbra.com/downloads/10.0.0_GA/zcs-NETWORK-10.0.0_GA_4518.UBUNTU20_64.20230301065514.tgz

## Step 1: Chuẩn bị resouce trên vps cài đặt

Clone resouce này về local

```
git clone https://github.com/anhdh0o0/build-zimbra-docker.git
```
Từ trong thư mục chứa resouce build zimbra tải bản cài zimbra
```
cd build-zimbra-docker && \
wget https://files.zimbra.com/downloads/8.8.15_GA/zcs-8.8.15_GA_4179.UBUNTU20_64.20211118033954.tgz
```
Trong thư mục chứa resource của bạn, cần:
- Dockerfile
- zcs-8.8.15_GA_4179.UBUNTU20_64.20211118033954.tgz

Build image

```
docker build -t anhit:zcsub2004 .
```

Run image này lên

```
docker run -dit --name zcs -h mail.nexlesoft.io.vn -p 25:25 -p 80:80 -p 443:443 -p 465:465 -p 587:587 -p 993:993 -p 995:995 -p 7071:7071 -v $(pwd)/zimbra:/opt/zimbra anhit:zcsub2004
```


Để truy cập vào container này ta có thể dùng lệnh

```
docker exec -it zcs bash
```
## Setup DNS auto

```
/srv/dns-auto.sh
```
## Installing Zimbra Open Source Edition

Manuel thì cứ

```
docker exec -it zcs bash
```
```
#Trong container
cd /home/zimbra/ && ./install.sh
```

or Từ ngoài container dùng lệnh

```
docker exec -it zcs sh -c "cd /home/zimbra/ && ./install.sh"
```

## Link lib
- wget https://files.zimbra.com/downloads/8.8.15_GA/zcs-8.8.15_GA_4179.UBUNTU20_64.20211118033954.tgz
- wget https://files.zimbra.com/downloads/10.0.0_GA/zcs-NETWORK-10.0.0_GA_4518.UBUNTU20_64.20230301065514.tgz