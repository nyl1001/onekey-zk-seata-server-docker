FROM zookeeper:3.7

##
## docker image for zookeeper with init data feature.
##
## author: dan neil<yinliangnie@gmail.com>  2022.02.08


LABEL maintainer="dan neil<yinliangnie@gmail.com>" \
    reference="https://github.com/cnscud/cnscud-docker" \
    specification="https://blog.51cto.com/u_15069450/4562047"

## my entrypoint script
ADD onekey-zookeeper-docker-entrypoint.sh /

## declare the volumen for init data
VOLUME /init.data /init.data

## declare the port
EXPOSE 2181

## ===================================

## from official zookeeper as reference
# ENTRYPOINT ["/docker-entrypoint.sh"]
# CMD ["zkServer.sh" "start-foreground"]

ENTRYPOINT ["/onekey-zookeeper-docker-entrypoint.sh"]
CMD ["zkServer.sh","start-foreground"]