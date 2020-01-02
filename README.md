php73-centos8
====

php-7.4(mod_php) + Apache-2.4(prefork) + CentOS-8

定番のミニマム構成のためのイメージ


### docker-compose で起動する例
```bash
cd docker
docker-compose up -d

docker-compose ps
```

### 単体実行の例
```bash
docker run -it --name php74-centos8-build \
  -p 80:80 -p 443:443 \
  -v "C:\projects\docker_build\docker-php74-centos8\src/:/var/www/html" \
  iamapen/php74-centos8
```

