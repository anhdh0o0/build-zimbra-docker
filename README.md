# Đây là bản build image vps ubuntu 20.04

Có cài sẵn một số thư viện, update để phù hợp build zimbra

Bạn run

```
git clone https://github.com/anhdh0o0/build-zimbra-docker.git
```

Sau khi clone docker file về thì build nó ra thành image

```
docker build -t anhit:zcsub2004 .
```

Run image này lên

```
docker run -dit --name zcs -h localhost -p 25:25 -p 80:80 -p 443:443 -p 465:465 -p 587:587 -p 993:993 -p 995:995 -p 7071:7071 -v $(pwd)/zimbra:/opt/zimbra anhit:zcsub2004
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
docker exec -it zcs sh -c "cd /home/zimbra/ && ./install.sh"
```

## Link lib
- wget https://files.zimbra.com/downloads/8.8.15_GA/zcs-8.8.15_GA_4179.UBUNTU20_64.20211118033954.tgz
