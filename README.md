# Đây là bản build image vps ubuntu 23.10

Có cài sẵn một số thư viện, update để phù hợp build zimbra

Bạn run

```
git clone https://github.com/anhdh0o0/build-zimbra-docker.git
```

Sau khi clone docker file về thì build nó ra thành image

```
Docker build -t anhit:anhit2310 .
```

Run image này lên

```
docker run -dit --name anhit2310 -h [domain] -p 25:25 -p 80:80 -p 443:443 -p 465:465 -p 587:587 -p 993:993 -p 995:995 -p 7071:7071 anhit:anhit
```

Tiếp theo ta cần truy cập vào container này để setup vps


```
docker exec -it anhit2310 bash
```
