# Đây là bản build image vps ubuntu 18.04

Có cài sẵn một số thư viện, update để phù hợp build zimbra

Bạn run

```
git clone https://github.com/anhdh0o0/build-zimbra-docker.git
```
or
```
git clone -b ubuntu/18.04 https://github.com/anhdh0o0/build-zimbra-docker.git
```
truy cập vào thư mục và download gói cài đặt zimbra
```
cd build-zimbra-docker
```

```
wget https://files.zimbra.com/downloads/8.8.15_GA/zcs-8.8.15_GA_4179.UBUNTU20_64.20211118033954.tgz
```

Từ trong thưc mục build-zimbra-docker, build image


```
docker build -t anhit:zcsub2004 .
```

Run image này lên

```
docker run -dit --name zcs -h nexlesoft.io.vn -p 25:25 -p 80:80 -p 443:443 -p 465:465 -p 587:587 -p 993:993 -p 995:995 -p 7071:7071 -v /data/zimbra:/opt/zimbra anhit:zcsub2004
```
or use docker-compose
```
docker compose up -d
```

Để truy cập vào container này ta có thể dùng lệnh

```
docker exec -it zcs bash
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
docker exec -it zcs sh -c "cd /home/zimbra/ && ./install.sh --platform-override"
```

## Lệnh xử lý cho zimbra

Trong container cần chuyển sang dùng user zimbra để thực thi lệnh
```
su – zimbra
```

```
zmcontrol status
```
hoặc dùng  
```
su – zimbra -c “zmcontrol status”

/etc/init.d/zimbra restart
```

su - zimbra -c "zmproxyctl stop"
or 
su -zimbra

zmproxyctl stop

cd letsencrypt

## Link lib
- https://files.zimbra.com/downloads/8.8.15_GA/zcs-8.8.15_GA_4179.UBUNTU20_64.20211118033954.tgz
