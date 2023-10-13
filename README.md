Đây là bản build image vps ubuntu 23.10

Có cài sẵn một số thư viện, update để phù hợp build zimbra

Bạn run
git clone https://github.com/anhdh0o0/build-zimbra-docker.git

Docker build -t anhit:ubuntu2301 .

11  docker run -dit --name ubuntu2301 -h mail.sai.io.vn -p 25:25 -p 80:80 -p 443:443 -p 465:465 -p 587:587 -p 993:993 -p 995:995 -p 7071:7071 anhit:ubuntu2301
