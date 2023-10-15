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
cd /opt/
wget -c https://files.zimbra.com/downloads/8.8.15_GA/zcs-8.8.15_GA_3869.UBUNTU18_64.20190917004220.tgz
tar -zxvf zcs-8.8.15_GA_3869.UBUNTU18_64.20190917004220.tgz
cd zcs-8.8.15_GA_3869.UBUNTU18_64.20190917004220
./install.sh

wget https://files.zimbra.com/downloads/8.8.15_GA/zcs-8.8.15_GA_4179.UBUNTU20_64.20211118033954.tgz

```

Từ trong thưc mục build-zimbra-docker, build image


```
docker build -t anhit:zcsub1804 .
```

Run image này lên

```
docker run -dit --name zcs -h mail.domain.com -p 25:25 -p 80:80 -p 443:443 -p 465:465 -p 587:587 -p 993:993 -p 995:995 -p 7071:7071 -v /data/zimbra:/opt/zimbra anhit:zcsub1804
```
or use docker-compose
```
docker compose up -d
```

Để truy cập vào container này ta có thể dùng lệnh

```
docker exec -it zcs bash
```
## Configure local dns on this container ubuntu
```
/srv/dns-auto.sh
```
or

docker exec -it zcs sh -c "/srv/dns-auto.sh"
Check tình trạng bind9
exec -it zcs sh -c "/etc/init.d/bind9 status"
Restart bind9
/etc/init.d/bind9 restart
Nếu gặp lỗi thì run lệnh:
docker
và check lỗi
or từ ngoài container thì run:
exec -it zcs sh -c "named -g"
exec -it zcs sh -c "/etc/init.d/bind9 "
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

restart zimbra

```
/etc/init.d/zimbra restart
```

zmproxyctl stop

cd letsencrypt

## Link lib
- https://files.zimbra.com/downloads/8.8.15_GA/zcs-8.8.15_GA_4179.UBUNTU20_64.20211118033954.tgz
wget -c https://files.zimbra.com/downloads/8.8.15_GA/zcs-8.8.15_GA_3869.UBUNTU18_64.20190917004220.tgz