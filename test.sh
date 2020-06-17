docker network create test &>/dev/null
docker stop php php74 php73 web  &>/dev/null
docker run -d --rm --name php --network test -v $(pwd)/code:/code php:7.3-fpm-alpine &>/dev/null
docker run -d --rm --name php74 --network test -v $(pwd)/code:/code php:7.4-fpm-alpine &>/dev/null
docker run -d --rm --name web --network test -v $(pwd)/code:/code -v $(pwd)/conf:/etc/nginx/conf.d/ nginx:latest &>/dev/null

echo 'Getting current php version'
docker run --rm --name curl --network test curlimages/curl -S web | grep PHP_VERSION
echo
echo 'Switching php version'
docker rename php php73
docker rename php74 php
docker exec web nginx -s reload &>/dev/null
echo 'Getting current php version'
docker run --rm --network test curlimages/curl -S web | grep PHP_VERSION
