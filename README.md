# Đây là bản build image vps ubuntu 20.04

Có cài sẵn một số thư viện, update để phù hợp build zimbra

Bạn run

```
git clone https://github.com/anhdh0o0/build-zimbra-docker.git
```

Sau khi clone docker file về thì build nó ra thành image

```
Docker build -t anhit:zcsub2004 .
```

Run image này lên

```
docker run -dit --name zcs -h [domain] -p 25:25 -p 80:80 -p 443:443 -p 465:465 -p 587:587 -p 993:993 -p 995:995 -p 7071:7071 anhit:zcsub2004
```

Tiếp theo ta cần truy cập vào container này để setup vps

```
docker exec -it zcs bash
```

## Installing Zimbra Open Source Edition



wget https://files.zimbra.com/downloads/8.8.15_GA/zcs-8.8.15_GA_4179.UBUNTU20_64.20211118033954.tg


tar xvzf zcs-8.8.15_GA_4179.UBUNTU20_64.20211118033954.tgz
