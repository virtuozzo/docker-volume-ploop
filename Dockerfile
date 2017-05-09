FROM centos:7

ADD virtuozzo.repo /etc/yum.repos.d/

RUN printf "upgrade \n install ploop gdisk \n run" | yum shell -y

RUN mkdir -p /run/docker/plugins /mnt/vstorage/docker /mnt/docker

COPY docker-volume-ploop docker-volume-ploop

CMD ["./docker-volume-ploop"]
